-- Migration: the player's level lives on the player
-- Run once on the live database (Supabase SQL editor), after 2026-11-06_levels.sql.
-- Safe to run twice.
--
-- What it does
--   1. Adds rb_players.level (1 to 7, starts at 1).
--   2. Adds rb_sync_level: the app sends the level it has, the server keeps
--      the higher of the two and answers with the level to use. A level never
--      goes down, so the higher one is always the right one. This carries
--      progress made before this migration, offline or while playing
--      anonymously over to the account.

begin;

alter table public.rb_players
  add column if not exists level int not null default 1;

alter table public.rb_players drop constraint if exists rb_players_level_check;
alter table public.rb_players add constraint rb_players_level_check
  check (level between 1 and 7);

-- Raises the level of the signed-in player to p_level if that is higher and
-- returns the level now on file.
create or replace function public.rb_sync_level(p_token uuid, p_level int default 1)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_player public.rb_players;
  v_level int;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  update public.rb_players
    set level = greatest(level, least(greatest(coalesce(p_level, 1), 1), 7))
    where id = v_player.id
    returning level into v_level;
  return jsonb_build_object('ok', true, 'level', v_level);
end;
$$;

revoke execute on function public.rb_sync_level(uuid, int)
  from public, anon, authenticated;

grant execute on function public.rb_sync_level(uuid, int)
  to anon, authenticated;

commit;
