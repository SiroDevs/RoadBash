-- Migration: wallets, prize money, fines and crash bills
-- Run once on the live database (Supabase SQL editor). Safe to run twice.
--
-- What it does
--   1. Adds rb_wallets (one balance per player, it may go negative) and
--      rb_wallet_entries (every change, with its reason).
--   2. Gives every existing player a wallet at 0 and every new player one too.
--   3. rb_record_game now also pays the prize for the place (1st 5000, 2nd 3000,
--      3rd 1500, 4th 500, KSh) and returns it with the new balance.
--   4. rb_charge_race takes the fine of a busted race, or the hospital and
--      garage bills of a nasty crash (100 km/h or more).
--   5. rb_my_wallet returns the balance shown in the menu.
--
-- Old app versions keep working: they call rb_record_game with the same
-- arguments, and their prizes land in the wallet too.

begin;

create table if not exists public.rb_wallets (
  player_id uuid primary key references public.rb_players(id) on delete cascade,
  balance bigint not null default 0,
  updated_at timestamptz not null default now()
);

-- Every change of a wallet, so a negative balance can be explained.
create table if not exists public.rb_wallet_entries (
  id bigint generated always as identity primary key,
  player_id uuid not null references public.rb_players(id) on delete cascade,
  amount bigint not null,
  reason text not null check (reason in ('prize', 'fine', 'hospital', 'garage')),
  game_id bigint references public.rb_games(id) on delete set null,
  balance_after bigint not null,
  created_at timestamptz not null default now()
);
create index if not exists rb_wallet_entries_player_idx
  on public.rb_wallet_entries (player_id, created_at desc);

alter table public.rb_wallets enable row level security;
alter table public.rb_wallet_entries enable row level security;
revoke all on public.rb_wallets, public.rb_wallet_entries from public, anon, authenticated;

-- A wallet for every player, the existing ones and the ones to come.
insert into public.rb_wallets (player_id)
select id from public.rb_players
on conflict (player_id) do nothing;

create or replace function public.rb_create_wallet()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.rb_wallets (player_id) values (new.id)
  on conflict (player_id) do nothing;
  return new;
end;
$$;

drop trigger if exists rb_players_wallet on public.rb_players;
create trigger rb_players_wallet
  after insert on public.rb_players
  for each row execute function public.rb_create_wallet();

-- Prize money by finishing place (KSh).
create or replace function public.rb_prize_for_place(p_place int)
returns int language sql immutable as $$
  select case p_place when 1 then 5000 when 2 then 3000 when 3 then 1500 when 4 then 500 else 0 end;
$$;

-- A nasty crash is one at 100 km/h or more; the bills grow with the speed.
create or replace function public.rb_hospital_cost(p_kmh int)
returns int language sql immutable as $$
  select 2000 + 40 * (least(greatest(p_kmh, 100), 240) - 100);
$$;

create or replace function public.rb_garage_cost(p_kmh int)
returns int language sql immutable as $$
  select 1500 + 30 * (least(greatest(p_kmh, 100), 240) - 100);
$$;

-- Adds money to a wallet (negative to take it) and returns the new balance.
create or replace function public.rb_wallet_add(
  p_player uuid,
  p_amount bigint,
  p_reason text,
  p_game bigint default null
)
returns bigint language plpgsql security definer set search_path = public as $$
declare
  v_balance bigint;
begin
  insert into public.rb_wallets (player_id, balance)
  values (p_player, p_amount)
  on conflict (player_id) do update
    set balance = public.rb_wallets.balance + excluded.balance, updated_at = now()
  returning balance into v_balance;
  insert into public.rb_wallet_entries (player_id, amount, reason, game_id, balance_after)
  values (p_player, p_amount, p_reason, p_game, v_balance);
  return v_balance;
end;
$$;

-- Records a finished race and pays the prize for the place.
create or replace function public.rb_record_game(
  p_token uuid,
  p_scene text,
  p_place int,
  p_time_ms int
)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_player public.rb_players;
  v_game bigint;
  v_prize int;
  v_balance bigint;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  if p_scene is null or p_scene !~ '^[A-Za-z0-9_-]{1,40}$'
     or p_place is null or p_place not between 1 and 6
     or p_time_ms is null or p_time_ms not between 10000 and 3600000 then
    return jsonb_build_object('ok', false, 'error', 'invalid_game');
  end if;
  if exists (
    select 1 from public.rb_games
    where player_id = v_player.id and finished_at > now() - interval '10 seconds'
  ) then
    return jsonb_build_object('ok', false, 'error', 'too_fast');
  end if;
  insert into public.rb_games (player_id, scene, place, time_ms)
  values (v_player.id, p_scene, p_place, p_time_ms)
  returning id into v_game;
  v_prize := public.rb_prize_for_place(p_place);
  if v_prize > 0 then
    v_balance := public.rb_wallet_add(v_player.id, v_prize, 'prize', v_game);
  else
    select balance into v_balance from public.rb_wallets where player_id = v_player.id;
  end if;
  return jsonb_build_object('ok', true, 'prize', v_prize, 'balance', coalesce(v_balance, 0));
end;
$$;

-- Takes the fine of a busted race, or the hospital and garage bills of a nasty crash.
create or replace function public.rb_charge_race(
  p_token uuid,
  p_outcome text,
  p_fine int default 0,
  p_crash_kmh int default 0
)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_player public.rb_players;
  v_fine int := 0;
  v_hospital int := 0;
  v_garage int := 0;
  v_balance bigint;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  if coalesce(p_outcome, '') not in ('busted', 'crashed') then
    return jsonb_build_object('ok', false, 'error', 'invalid_outcome');
  end if;
  if p_outcome = 'crashed' and coalesce(p_crash_kmh, 0) < 100 then
    return jsonb_build_object('ok', false, 'error', 'invalid_crash');
  end if;
  if exists (
    select 1 from public.rb_wallet_entries
    where player_id = v_player.id
      and reason in ('fine', 'hospital')
      and created_at > now() - interval '10 seconds'
  ) then
    return jsonb_build_object('ok', false, 'error', 'too_fast');
  end if;

  if p_outcome = 'busted' then
    v_fine := least(greatest(coalesce(p_fine, 0), 0), 9500);
    if v_fine > 0 then
      v_balance := public.rb_wallet_add(v_player.id, -v_fine, 'fine');
    end if;
  else
    v_hospital := public.rb_hospital_cost(p_crash_kmh);
    v_garage := public.rb_garage_cost(p_crash_kmh);
    perform public.rb_wallet_add(v_player.id, -v_hospital, 'hospital');
    v_balance := public.rb_wallet_add(v_player.id, -v_garage, 'garage');
  end if;

  if v_balance is null then
    select balance into v_balance from public.rb_wallets where player_id = v_player.id;
  end if;
  return jsonb_build_object(
    'ok', true,
    'fine', v_fine,
    'hospital', v_hospital,
    'garage', v_garage,
    'balance', coalesce(v_balance, 0)
  );
end;
$$;

-- The wallet balance of the signed-in player; it can be negative.
create or replace function public.rb_my_wallet(p_token uuid)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_player public.rb_players;
  v_balance bigint;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  select balance into v_balance from public.rb_wallets where player_id = v_player.id;
  return jsonb_build_object('ok', true, 'balance', coalesce(v_balance, 0));
end;
$$;

revoke execute on function
  public.rb_prize_for_place(int),
  public.rb_hospital_cost(int),
  public.rb_garage_cost(int),
  public.rb_wallet_add(uuid, bigint, text, bigint),
  public.rb_create_wallet(),
  public.rb_record_game(uuid, text, int, int),
  public.rb_charge_race(uuid, text, int, int),
  public.rb_my_wallet(uuid)
  from public, anon, authenticated;

grant execute on function
  public.rb_record_game(uuid, text, int, int),
  public.rb_charge_race(uuid, text, int, int),
  public.rb_my_wallet(uuid)
  to anon, authenticated;

commit;
