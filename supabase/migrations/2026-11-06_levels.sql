-- Migration: level rules for the wallet
-- Run once on the live database (Supabase SQL editor), after 2026-11-05_wallets.sql.
-- Safe to run twice.
--
-- What it does
--   1. Lets rb_games hold every scene (it only allowed city and suburbs, so a
--      race on Thika Road, Jungle or Dirt Road could not be saved).
--   2. Adds the 'bonus' and 'traffic' reasons to the wallet entries.
--   3. Adds the money of each level (see LevelRules in the app):
--        win prize        L2 250, L3 400, L4 750, L5 1200, L6 2000, L7 3000
--        new best time    +5% of the prize        (level 2 and up)
--        clean race       +3% of the prize        (no bashing of rivals)
--        traffic hit      -100 each               (level 2 and up)
--        hospital bill    L3-L4 1500, L5+ 3000    (a crash at 100 km/h or more)
--        garage bill      L5+ 3000
--        police fine      L5+ 2000
--   4. Adds rb_settle_race: one call that records a finished race for the
--      leaderboard and pays or charges everything above. The older functions
--      stay as they are, so old app versions keep working.
--
-- The app tells the server the level, whether the time was a new best for that
-- level and scene, whether the race was clean and how many vehicles were hit.
-- The server decides every amount.

begin;

alter table public.rb_games drop constraint if exists rb_games_scene_check;
alter table public.rb_games add constraint rb_games_scene_check
  check (scene in ('city', 'suburbs', 'thikaRoad', 'jungle', 'dirtRoad'));

alter table public.rb_wallet_entries drop constraint if exists rb_wallet_entries_reason_check;
alter table public.rb_wallet_entries add constraint rb_wallet_entries_reason_check
  check (reason in ('prize', 'bonus', 'traffic', 'fine', 'hospital', 'garage'));

create or replace function public.rb_level_prize(p_level int)
returns int language sql immutable as $$
  select case p_level
    when 2 then 250 when 3 then 400 when 4 then 750
    when 5 then 1200 when 6 then 2000 when 7 then 3000
    else 0 end;
$$;

create or replace function public.rb_level_hospital(p_level int)
returns int language sql immutable as $$
  select case when p_level >= 5 then 3000 when p_level >= 3 then 1500 else 0 end;
$$;

create or replace function public.rb_level_garage(p_level int)
returns int language sql immutable as $$
  select case when p_level >= 5 then 3000 else 0 end;
$$;

create or replace function public.rb_level_police_fine(p_level int)
returns int language sql immutable as $$
  select case when p_level >= 5 then 2000 else 0 end;
$$;

create or replace function public.rb_level_traffic_fine(p_level int)
returns int language sql immutable as $$
  select case when p_level >= 2 then 100 else 0 end;
$$;

-- Records a race and settles its money by the rules of the level.
-- p_outcome is 'finished', 'busted' or 'crashed'.
create or replace function public.rb_settle_race(
  p_token uuid,
  p_scene text,
  p_level int,
  p_outcome text,
  p_place int default 1,
  p_time_ms int default 0,
  p_new_best boolean default false,
  p_clean boolean default false,
  p_traffic_hits int default 0,
  p_crash_kmh int default 0
)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_player public.rb_players;
  v_game bigint;
  v_prize int := 0;
  v_best int := 0;
  v_clean int := 0;
  v_traffic int := 0;
  v_fine int := 0;
  v_hospital int := 0;
  v_garage int := 0;
  v_balance bigint;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  if p_scene is null or p_scene !~ '^[A-Za-z0-9_-]{1,40}$'
     or p_level is null or p_level not between 1 and 7
     or coalesce(p_outcome, '') not in ('finished', 'busted', 'crashed') then
    return jsonb_build_object('ok', false, 'error', 'invalid_game');
  end if;
  if exists (
    select 1 from public.rb_games
    where player_id = v_player.id and finished_at > now() - interval '10 seconds'
  ) or exists (
    select 1 from public.rb_wallet_entries
    where player_id = v_player.id and created_at > now() - interval '10 seconds'
  ) then
    return jsonb_build_object('ok', false, 'error', 'too_fast');
  end if;

  if p_outcome = 'finished' then
    if p_place is null or p_place not between 1 and 6
       or p_time_ms is null or p_time_ms not between 10000 and 3600000 then
      return jsonb_build_object('ok', false, 'error', 'invalid_game');
    end if;
    insert into public.rb_games (player_id, scene, place, time_ms)
    values (v_player.id, p_scene, p_place, p_time_ms)
    returning id into v_game;
    if p_place = 1 then
      v_prize := public.rb_level_prize(p_level);
      if v_prize > 0 then
        if coalesce(p_new_best, false) and p_level > 1 then
          v_best := round(v_prize * 0.05)::int;
        end if;
        if coalesce(p_clean, false) then
          v_clean := round(v_prize * 0.03)::int;
        end if;
      end if;
    end if;
  elsif p_outcome = 'busted' then
    v_fine := public.rb_level_police_fine(p_level);
  else
    if coalesce(p_crash_kmh, 0) < 100 or public.rb_level_hospital(p_level) = 0 then
      return jsonb_build_object('ok', false, 'error', 'invalid_crash');
    end if;
    v_hospital := public.rb_level_hospital(p_level);
    v_garage := public.rb_level_garage(p_level);
  end if;

  v_traffic := least(greatest(coalesce(p_traffic_hits, 0), 0), 50)
    * public.rb_level_traffic_fine(p_level);

  if v_prize > 0 then
    v_balance := public.rb_wallet_add(v_player.id, v_prize, 'prize', v_game);
  end if;
  if v_best > 0 then
    v_balance := public.rb_wallet_add(v_player.id, v_best, 'bonus', v_game);
  end if;
  if v_clean > 0 then
    v_balance := public.rb_wallet_add(v_player.id, v_clean, 'bonus', v_game);
  end if;
  if v_traffic > 0 then
    v_balance := public.rb_wallet_add(v_player.id, -v_traffic, 'traffic', v_game);
  end if;
  if v_fine > 0 then
    v_balance := public.rb_wallet_add(v_player.id, -v_fine, 'fine');
  end if;
  if v_hospital > 0 then
    v_balance := public.rb_wallet_add(v_player.id, -v_hospital, 'hospital');
  end if;
  if v_garage > 0 then
    v_balance := public.rb_wallet_add(v_player.id, -v_garage, 'garage');
  end if;

  if v_balance is null then
    select balance into v_balance from public.rb_wallets where player_id = v_player.id;
  end if;
  return jsonb_build_object(
    'ok', true,
    'prize', v_prize,
    'best_bonus', v_best,
    'clean_bonus', v_clean,
    'traffic', v_traffic,
    'fine', v_fine,
    'hospital', v_hospital,
    'garage', v_garage,
    'balance', coalesce(v_balance, 0)
  );
end;
$$;

revoke execute on function
  public.rb_level_prize(int),
  public.rb_level_hospital(int),
  public.rb_level_garage(int),
  public.rb_level_police_fine(int),
  public.rb_level_traffic_fine(int),
  public.rb_settle_race(uuid, text, int, text, int, int, boolean, boolean, int, int)
  from public, anon, authenticated;

grant execute on function
  public.rb_settle_race(uuid, text, int, text, int, int, boolean, boolean, int, int)
  to anon, authenticated;

commit;
