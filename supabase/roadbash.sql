create extension if not exists pgcrypto with schema extensions;

create table if not exists public.rb_players (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  name_key text not null unique,
  question text not null,
  answer_hash text not null,
  is_admin boolean not null default false,
  failed_attempts int not null default 0,
  locked_until timestamptz,
  created_at timestamptz not null default now(),
  last_login_at timestamptz
);

create table if not exists public.rb_reserved_names (
  name_key text primary key,
  failed_attempts int not null default 0,
  locked_until timestamptz
);

create table if not exists public.rb_config (
  key text primary key,
  value text not null
);

create table if not exists public.rb_sessions (
  token uuid primary key default gen_random_uuid(),
  player_id uuid not null references public.rb_players(id) on delete cascade,
  created_at timestamptz not null default now(),
  expires_at timestamptz not null default now() + interval '7 days'
);
create index if not exists rb_sessions_created_idx on public.rb_sessions (created_at);

create table if not exists public.rb_visits (
  id bigint generated always as identity primary key,
  visitor_id uuid not null,
  platform text,
  started_at timestamptz not null default now()
);
create index if not exists rb_visits_started_idx on public.rb_visits (started_at);
create index if not exists rb_visits_visitor_idx on public.rb_visits (visitor_id, started_at);

alter table public.rb_visits
  add column if not exists country_code text,
  add column if not exists country text,
  add column if not exists region text,
  add column if not exists city text,
  add column if not exists lat real,
  add column if not exists lng real;
create index if not exists rb_visits_country_idx on public.rb_visits (country_code, started_at);

create table if not exists public.rb_presence (
  visitor_id uuid primary key,
  player_id uuid references public.rb_players(id) on delete set null,
  last_seen timestamptz not null default now()
);
create index if not exists rb_presence_seen_idx on public.rb_presence (last_seen);

create table if not exists public.rb_games (
  id bigint generated always as identity primary key,
  player_id uuid not null references public.rb_players(id) on delete cascade,
  scene text not null check (scene in ('city', 'suburbs')),
  place int not null check (place between 1 and 6),
  time_ms int not null check (time_ms between 10000 and 3600000),
  won boolean generated always as (place = 1) stored,
  finished_at timestamptz not null default now()
);
create index if not exists rb_games_player_idx on public.rb_games (player_id, finished_at);
create index if not exists rb_games_finished_idx on public.rb_games (finished_at);

-- Boardroom posts. Three kinds share this table:
--   announcement  admin only, always public
--   suggestion    any signed-in player, private until an admin makes it public
--   comment       a reply (parent_id) under an announcement or a suggestion;
--                 it is visible whenever its parent is visible
-- Older databases have this table as rb_suggestions: rename it in place.
do $$
begin
  if to_regclass('public.rb_suggestions') is not null
     and to_regclass('public.rb_posts') is null then
    alter table public.rb_suggestions rename to rb_posts;
    alter index if exists public.rb_suggestions_pkey rename to rb_posts_pkey;
    alter index if exists public.rb_suggestions_created_idx rename to rb_posts_created_idx;
    alter sequence if exists public.rb_suggestions_id_seq rename to rb_posts_id_seq;
    alter table public.rb_posts drop constraint if exists rb_suggestions_message_check;
    alter table public.rb_posts drop constraint if exists rb_suggestions_player_id_fkey;
    alter table public.rb_posts add constraint rb_posts_player_id_fkey
      foreign key (player_id) references public.rb_players(id) on delete set null;
  end if;
end $$;

create table if not exists public.rb_posts (
  id bigint generated always as identity primary key,
  kind text not null default 'suggestion',
  parent_id bigint references public.rb_posts(id) on delete cascade,
  player_id uuid references public.rb_players(id) on delete set null,
  player_name text not null,
  message text not null,
  is_public boolean not null default false,
  created_at timestamptz not null default now()
);

-- Columns for databases that had the old suggestions table.
alter table public.rb_posts add column if not exists kind text not null default 'suggestion';
alter table public.rb_posts add column if not exists parent_id bigint
  references public.rb_posts(id) on delete cascade;
alter table public.rb_posts add column if not exists is_public boolean not null default false;

alter table public.rb_posts drop constraint if exists rb_posts_message_check;
alter table public.rb_posts add constraint rb_posts_message_check
  check (char_length(message) between 1 and 1000);
alter table public.rb_posts drop constraint if exists rb_posts_kind_check;
alter table public.rb_posts add constraint rb_posts_kind_check
  check (kind in ('announcement', 'suggestion', 'comment'));
alter table public.rb_posts drop constraint if exists rb_posts_parent_check;
alter table public.rb_posts add constraint rb_posts_parent_check
  check ((kind = 'comment') = (parent_id is not null));
alter table public.rb_posts drop constraint if exists rb_posts_announcement_check;
alter table public.rb_posts add constraint rb_posts_announcement_check
  check (kind <> 'announcement' or is_public);

create index if not exists rb_posts_created_idx on public.rb_posts (created_at desc);
create index if not exists rb_posts_parent_idx on public.rb_posts (parent_id);

insert into public.rb_reserved_names (name_key)
values ('admin'), ('siro'), ('sirodevs'), ('sirodevske')
on conflict do nothing;

insert into public.rb_config (key, value)
values ('reserved_challenge_hash', '$2a$10$KdPK0b1dvRQqbakKUPKtWOq2rtihuuc2AkVoKjK3teKvtosvEetzm')
on conflict do nothing;

create or replace view public.rb_player_activity
with (security_invoker = true) as
  select player_id, created_at as at from public.rb_sessions
  union all
  select player_id, finished_at as at from public.rb_games;

alter table public.rb_players enable row level security;
alter table public.rb_reserved_names enable row level security;
alter table public.rb_config enable row level security;
alter table public.rb_sessions enable row level security;
alter table public.rb_visits enable row level security;
alter table public.rb_presence enable row level security;
alter table public.rb_games enable row level security;
alter table public.rb_posts enable row level security;

revoke all on public.rb_players, public.rb_reserved_names, public.rb_config,
  public.rb_sessions, public.rb_visits, public.rb_presence, public.rb_games,
  public.rb_posts, public.rb_player_activity
  from public, anon, authenticated;

create or replace function public.rb_name_key(p_name text)
returns text language sql immutable set search_path = public as $$
  select lower(regexp_replace(btrim(coalesce(p_name, '')), '[ _]', '', 'g'));
$$;

create or replace function public.rb_valid_name(p_name text)
returns boolean language sql immutable set search_path = public as $$
  select btrim(coalesce(p_name, '')) ~ '^[A-Za-z0-9][A-Za-z0-9 _]{1,10}[A-Za-z0-9]$'
     and public.rb_name_key(p_name) <> 'anonplayer';
$$;

create or replace function public.rb_norm_answer(p_text text)
returns text language sql immutable set search_path = public as $$
  select lower(regexp_replace(btrim(coalesce(p_text, '')), '\s+', ' ', 'g'));
$$;

create or replace function public.rb_session_player(p_token uuid)
returns public.rb_players
language sql stable security definer set search_path = public as $$
  select p.*
  from public.rb_sessions s
  join public.rb_players p on p.id = s.player_id
  where s.token = p_token and s.expires_at > now();
$$;

create or replace function public.rb_open_session(p_player uuid)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_token uuid;
  v_player public.rb_players;
begin
  delete from public.rb_sessions where expires_at < now();
  insert into public.rb_sessions (player_id) values (p_player) returning token into v_token;
  update public.rb_players
    set last_login_at = now(), failed_attempts = 0, locked_until = null
    where id = p_player
    returning * into v_player;
  return jsonb_build_object(
    'ok', true,
    'token', v_token,
    'player_id', v_player.id,
    'name', v_player.name,
    'is_admin', v_player.is_admin
  );
end;
$$;

create or replace function public.rb_name_status(p_name text)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_key text := public.rb_name_key(p_name);
  v_player public.rb_players;
begin
  if not public.rb_valid_name(p_name) then
    return jsonb_build_object('ok', true, 'status', 'invalid');
  end if;
  select * into v_player from public.rb_players where name_key = v_key;
  if found then
    return jsonb_build_object('ok', true, 'status', 'taken', 'name', v_player.name, 'question', v_player.question);
  end if;
  if exists (select 1 from public.rb_reserved_names where name_key = v_key) then
    return jsonb_build_object('ok', true, 'status', 'reserved_open');
  end if;
  return jsonb_build_object('ok', true, 'status', 'available');
end;
$$;

create or replace function public.rb_verify_challenge(p_key text, p_challenge text)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare
  v_reserved public.rb_reserved_names;
  v_hash text;
begin
  select * into v_reserved from public.rb_reserved_names where name_key = p_key;
  if not found then
    return jsonb_build_object('ok', false, 'error', 'not_reserved');
  end if;
  if v_reserved.locked_until is not null and v_reserved.locked_until > now() then
    return jsonb_build_object(
      'ok', false, 'error', 'locked',
      'retry_after', ceil(extract(epoch from (v_reserved.locked_until - now())))::int
    );
  end if;
  if btrim(coalesce(p_challenge, '')) = '' then
    return jsonb_build_object('ok', false, 'error', 'challenge_required');
  end if;
  select value into v_hash from public.rb_config where key = 'reserved_challenge_hash';
  if v_hash is not null and extensions.crypt(public.rb_norm_answer(p_challenge), v_hash) = v_hash then
    return jsonb_build_object('ok', true);
  end if;
  update public.rb_reserved_names
    set failed_attempts = case when failed_attempts + 1 >= 5 then 0 else failed_attempts + 1 end,
        locked_until = case when failed_attempts + 1 >= 5 then now() + interval '10 minutes' else locked_until end
    where name_key = p_key
    returning * into v_reserved;
  if v_reserved.locked_until is not null and v_reserved.locked_until > now() then
    return jsonb_build_object(
      'ok', false, 'error', 'locked',
      'retry_after', ceil(extract(epoch from (v_reserved.locked_until - now())))::int
    );
  end if;
  return jsonb_build_object('ok', false, 'error', 'wrong_challenge', 'remaining', 5 - v_reserved.failed_attempts);
end;
$$;

create or replace function public.rb_check_challenge(p_name text, p_challenge text)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_key text := public.rb_name_key(p_name);
begin
  if exists (select 1 from public.rb_players where name_key = v_key) then
    return jsonb_build_object('ok', false, 'error', 'name_taken');
  end if;
  return public.rb_verify_challenge(v_key, p_challenge);
end;
$$;

create or replace function public.rb_register(
  p_name text,
  p_question text,
  p_answer text,
  p_challenge text default null
)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare
  v_name text := btrim(coalesce(p_name, ''));
  v_key text := public.rb_name_key(p_name);
  v_question text := btrim(coalesce(p_question, ''));
  v_answer text := public.rb_norm_answer(p_answer);
  v_reserved public.rb_reserved_names;
  v_admin boolean := false;
  v_check jsonb;
  v_id uuid;
begin
  if not public.rb_valid_name(v_name) then
    return jsonb_build_object('ok', false, 'error', 'invalid_name');
  end if;
  if char_length(v_question) < 5 or char_length(v_question) > 80 then
    return jsonb_build_object('ok', false, 'error', 'invalid_question');
  end if;
  if char_length(v_answer) < 2 or char_length(v_answer) > 60 then
    return jsonb_build_object('ok', false, 'error', 'invalid_answer');
  end if;
  if exists (select 1 from public.rb_players where name_key = v_key) then
    return jsonb_build_object('ok', false, 'error', 'name_taken');
  end if;

  select * into v_reserved from public.rb_reserved_names where name_key = v_key;
  if found then
    v_check := public.rb_verify_challenge(v_key, p_challenge);
    if not (v_check->>'ok')::boolean then
      return v_check;
    end if;
    v_admin := true;
  end if;

  begin
    insert into public.rb_players (name, name_key, question, answer_hash, is_admin)
    values (v_name, v_key, v_question, extensions.crypt(v_answer, extensions.gen_salt('bf', 10)), v_admin)
    returning id into v_id;
  exception when unique_violation then
    return jsonb_build_object('ok', false, 'error', 'name_taken');
  end;

  if v_admin then
    update public.rb_reserved_names set failed_attempts = 0, locked_until = null where name_key = v_key;
  end if;
  return public.rb_open_session(v_id);
end;
$$;

create or replace function public.rb_login(p_name text, p_answer text)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare
  v_player public.rb_players;
  v_answer text := public.rb_norm_answer(p_answer);
begin
  select * into v_player from public.rb_players where name_key = public.rb_name_key(p_name);
  if not found then
    return jsonb_build_object('ok', false, 'error', 'unknown_name');
  end if;
  if v_player.locked_until is not null and v_player.locked_until > now() then
    return jsonb_build_object(
      'ok', false, 'error', 'locked',
      'retry_after', ceil(extract(epoch from (v_player.locked_until - now())))::int
    );
  end if;
  if extensions.crypt(v_answer, v_player.answer_hash) <> v_player.answer_hash then
    update public.rb_players
      set failed_attempts = case when failed_attempts + 1 >= 5 then 0 else failed_attempts + 1 end,
          locked_until = case when failed_attempts + 1 >= 5 then now() + interval '10 minutes' else locked_until end
      where id = v_player.id
      returning * into v_player;
    if v_player.locked_until is not null and v_player.locked_until > now() then
      return jsonb_build_object(
        'ok', false, 'error', 'locked',
        'retry_after', ceil(extract(epoch from (v_player.locked_until - now())))::int
      );
    end if;
    return jsonb_build_object('ok', false, 'error', 'wrong_answer', 'remaining', 5 - v_player.failed_attempts);
  end if;
  return public.rb_open_session(v_player.id);
end;
$$;

create or replace function public.rb_logout(p_token uuid)
returns jsonb language plpgsql security definer set search_path = public as $$
begin
  delete from public.rb_sessions where token = p_token;
  return jsonb_build_object('ok', true);
end;
$$;

drop function if exists public.rb_track_visit(uuid, text);

-- Records a visit with the visitor's approximate place. Only the country,
-- region and city are kept, and the position is rounded to about 10 km.
-- When the app sends no country, the one the hosting edge reports is used.
create or replace function public.rb_track_visit(
  p_visitor uuid,
  p_platform text default null,
  p_country_code text default null,
  p_country text default null,
  p_region text default null,
  p_city text default null,
  p_lat double precision default null,
  p_lng double precision default null
)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_code text := upper(left(btrim(coalesce(p_country_code, '')), 2));
  v_edge text;
  v_lat real;
  v_lng real;
begin
  if p_visitor is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_visitor');
  end if;
  if v_code !~ '^[A-Z]{2}$' then
    v_code := null;
  end if;
  if v_code is null then
    begin
      v_edge := upper(left(btrim(coalesce(
        nullif(current_setting('request.headers', true), '')::json ->> 'cf-ipcountry', ''
      )), 2));
    exception when others then
      v_edge := null;
    end;
    if v_edge ~ '^[A-Z]{2}$' and v_edge not in ('XX', 'T1') then
      v_code := v_edge;
    end if;
  end if;
  if v_code is not null and p_lat between -90 and 90 and p_lng between -180 and 180 then
    v_lat := round(p_lat::numeric, 1);
    v_lng := round(p_lng::numeric, 1);
  end if;
  if not exists (
    select 1 from public.rb_visits
    where visitor_id = p_visitor and started_at > now() - interval '1 minute'
  ) then
    insert into public.rb_visits (visitor_id, platform, country_code, country, region, city, lat, lng)
    values (
      p_visitor,
      left(coalesce(p_platform, ''), 20),
      v_code,
      case when v_code is null then null else nullif(left(btrim(coalesce(p_country, '')), 80), '') end,
      case when v_code is null then null else nullif(left(btrim(coalesce(p_region, '')), 80), '') end,
      case when v_code is null then null else nullif(left(btrim(coalesce(p_city, '')), 80), '') end,
      v_lat,
      v_lng
    );
  end if;
  insert into public.rb_presence (visitor_id, last_seen)
  values (p_visitor, now())
  on conflict (visitor_id) do update set last_seen = excluded.last_seen;
  return jsonb_build_object('ok', true);
end;
$$;

create or replace function public.rb_heartbeat(p_visitor uuid, p_token uuid default null)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_player public.rb_players;
begin
  if p_visitor is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_visitor');
  end if;
  if p_token is not null then
    select * into v_player from public.rb_session_player(p_token);
  end if;
  insert into public.rb_presence (visitor_id, player_id, last_seen)
  values (p_visitor, v_player.id, now())
  on conflict (visitor_id) do update
    set player_id = excluded.player_id, last_seen = excluded.last_seen;
  if random() < 0.02 then
    delete from public.rb_presence where last_seen < now() - interval '1 day';
  end if;
  return jsonb_build_object('ok', true);
end;
$$;

create or replace function public.rb_my_games(p_token uuid, p_limit int default 500)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_player public.rb_players;
  v_data jsonb;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'scene', g.scene, 'place', g.place, 'time_ms', g.time_ms, 'finished_at', g.finished_at
  ) order by g.finished_at desc), '[]'::jsonb)
  into v_data
  from (
    select * from public.rb_games
    where player_id = v_player.id
    order by finished_at desc
    limit least(greatest(coalesce(p_limit, 500), 1), 1000)
  ) g;
  return jsonb_build_object('ok', true, 'data', v_data);
end;
$$;

drop function if exists public.rb_leaderboard(int);

-- The leaderboard of a period: 'week' (this week, the default), 'last_week' or
-- 'all'. Weeks run from Monday 00:00 to the next Monday, UTC.
create or replace function public.rb_leaderboard(p_period text default 'week', p_limit int default 50)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_week timestamptz := date_trunc('week', now() at time zone 'utc') at time zone 'utc';
  v_from timestamptz;
  v_to timestamptz;
  v_data jsonb;
begin
  if p_period = 'last_week' then
    v_from := v_week - interval '7 days';
    v_to := v_week;
  elsif p_period = 'all' then
    v_from := null;
    v_to := null;
  else
    v_from := v_week;
    v_to := v_week + interval '7 days';
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'rank', r.rank, 'name', r.name, 'games', r.games, 'wins', r.wins
  ) order by r.rank), '[]'::jsonb)
  into v_data
  from (
    select row_number() over (order by t.wins desc, t.games asc, lower(t.name)) as rank,
           t.name, t.games, t.wins
    from (
      select p.name, count(g.id)::int as games, (count(g.id) filter (where g.won))::int as wins
      from public.rb_players p
      join public.rb_games g on g.player_id = p.id
      where (v_from is null or g.finished_at >= v_from)
        and (v_to is null or g.finished_at < v_to)
      group by p.id, p.name
    ) t
    order by t.wins desc, t.games asc, lower(t.name)
    limit least(greatest(coalesce(p_limit, 50), 1), 200)
  ) r;
  return jsonb_build_object('ok', true, 'from', v_from, 'to', v_to, 'data', v_data);
end;
$$;

create or replace function public.rb_stats_summary(p_tz_offset int default 0)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_off interval := make_interval(mins => greatest(least(coalesce(p_tz_offset, 0), 840), -720));
  v_today timestamptz := (date_trunc('day', (now() at time zone 'utc') + v_off) - v_off) at time zone 'utc';
  v_d int;
  v_start timestamptz;
  v_periods jsonb := '[]'::jsonb;
begin
  foreach v_d in array array[1, 7, 28, 90, 365] loop
    v_start := v_today - make_interval(days => v_d - 1);
    v_periods := v_periods || jsonb_build_array(jsonb_build_object(
      'days', v_d,
      'visitors', (select count(distinct visitor_id) from public.rb_visits where started_at >= v_start),
      'visits', (select count(*) from public.rb_visits where started_at >= v_start),
      'players', (select count(distinct player_id) from public.rb_player_activity where at >= v_start),
      'games', (select count(*) from public.rb_games where finished_at >= v_start)
    ));
  end loop;
  return jsonb_build_object(
    'ok', true,
    'online', (select count(*) from public.rb_presence where last_seen > now() - interval '90 seconds'),
    'online_players', (select count(*) from public.rb_presence
                       where last_seen > now() - interval '90 seconds' and player_id is not null),
    'total_players', (select count(*) from public.rb_players),
    'total_games', (select count(*) from public.rb_games),
    'total_visitors', (select count(distinct visitor_id) from public.rb_visits),
    'periods', v_periods
  );
end;
$$;

create or replace function public.rb_stats_series(p_days int default 7, p_tz_offset int default 0)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_days int := case when p_days in (1, 7, 28, 90, 365) then p_days else 7 end;
  v_off interval := make_interval(mins => greatest(least(coalesce(p_tz_offset, 0), 840), -720));
  v_local_now timestamp := (now() at time zone 'utc') + v_off;
  v_unit text := case when v_days = 1 then 'hour' when v_days <= 90 then 'day' else 'week' end;
  v_step interval := case when v_days = 1 then interval '1 hour'
                          when v_days <= 90 then interval '1 day'
                          else interval '1 week' end;
  v_first timestamp;
  v_last timestamp;
  v_from timestamptz;
  v_data jsonb;
begin
  if v_days = 1 then
    v_first := date_trunc('day', v_local_now);
    v_last := v_first + interval '23 hours';
  else
    v_first := date_trunc(v_unit, v_local_now - make_interval(days => v_days - 1));
    v_last := date_trunc(v_unit, v_local_now);
  end if;
  v_from := (v_first - v_off) at time zone 'utc';

  select coalesce(jsonb_agg(jsonb_build_object(
    't', to_char(g.b, 'YYYY-MM-DD"T"HH24:MI:SS'),
    'visitors', coalesce(v.visitors, 0),
    'visits', coalesce(v.visits, 0),
    'players', coalesce(p.players, 0),
    'games', coalesce(m.games, 0)
  ) order by g.b), '[]'::jsonb)
  into v_data
  from generate_series(v_first, v_last, v_step) as g(b)
  left join (
    select date_trunc(v_unit, (started_at at time zone 'utc') + v_off) as b,
           count(distinct visitor_id)::int as visitors, count(*)::int as visits
    from public.rb_visits where started_at >= v_from group by 1
  ) v on v.b = g.b
  left join (
    select date_trunc(v_unit, (at at time zone 'utc') + v_off) as b,
           count(distinct player_id)::int as players
    from public.rb_player_activity where at >= v_from group by 1
  ) p on p.b = g.b
  left join (
    select date_trunc(v_unit, (finished_at at time zone 'utc') + v_off) as b,
           count(*)::int as games
    from public.rb_games where finished_at >= v_from group by 1
  ) m on m.b = g.b;

  return jsonb_build_object('ok', true, 'unit', v_unit, 'data', v_data);
end;
$$;

create or replace function public.rb_stats_heatmap(p_days int default 28, p_tz_offset int default 0)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_days int := case when p_days in (7, 28, 90, 365) then p_days else 28 end;
  v_off interval := make_interval(mins => greatest(least(coalesce(p_tz_offset, 0), 840), -720));
  v_from timestamptz := (date_trunc('day', (now() at time zone 'utc') + v_off) - v_off
                         - make_interval(days => v_days - 1)) at time zone 'utc';
  v_data jsonb;
begin
  select coalesce(jsonb_agg(jsonb_build_object(
    'dow', c.dow, 'hour', c.hr, 'visitors', coalesce(c.v, 0), 'players', coalesce(c.p, 0)
  )), '[]'::jsonb)
  into v_data
  from (
    select coalesce(a.dow, b.dow) as dow, coalesce(a.hr, b.hr) as hr, a.v, b.p
    from (
      select extract(isodow from l)::int as dow, extract(hour from l)::int as hr,
             count(distinct visitor_id)::int as v
      from (select visitor_id, (started_at at time zone 'utc') + v_off as l
            from public.rb_visits where started_at >= v_from) x
      group by 1, 2
    ) a
    full join (
      select extract(isodow from l)::int as dow, extract(hour from l)::int as hr,
             count(distinct player_id)::int as p
      from (select player_id, (at at time zone 'utc') + v_off as l
            from public.rb_player_activity where at >= v_from) y
      group by 1, 2
    ) b on a.dow = b.dow and a.hr = b.hr
  ) c;
  return jsonb_build_object('ok', true, 'data', v_data);
end;
$$;

-- Where the visitors of the last p_days days come from: one row per country,
-- one per mapped place, and how many visitors have no known country. Each
-- visitor is counted once, from their best visit in the period.
create or replace function public.rb_stats_places(
  p_days int default 28,
  p_tz_offset int default 0,
  p_limit int default 200
)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_days int := case when p_days in (1, 7, 28, 90, 365) then p_days else 28 end;
  v_off interval := make_interval(mins => greatest(least(coalesce(p_tz_offset, 0), 840), -720));
  v_from timestamptz := (date_trunc('day', (now() at time zone 'utc') + v_off) - v_off
                         - make_interval(days => v_days - 1)) at time zone 'utc';
  v_limit int := least(greatest(coalesce(p_limit, 200), 1), 500);
  v_countries jsonb;
  v_places jsonb;
  v_unknown int;
begin
  with v as (
    select distinct on (visitor_id) visitor_id, country_code, country, region, city, lat, lng
    from public.rb_visits
    where started_at >= v_from
    order by visitor_id, (country_code is not null) desc, (lat is not null) desc, started_at desc
  ),
  c as (
    select country_code as code, max(country) as name, count(*)::int as visitors,
           (count(*) filter (where lat is not null))::int as located
    from v where country_code is not null
    group by country_code
    order by count(*) desc, country_code
    limit v_limit
  ),
  p as (
    select coalesce(city, '') as city, coalesce(region, '') as region,
           country_code as code, lat, lng, count(*)::int as visitors
    from v where lat is not null and lng is not null
    group by city, region, country_code, lat, lng
    order by count(*) desc
    limit v_limit
  )
  select
    coalesce((select jsonb_agg(to_jsonb(c) order by c.visitors desc, c.code) from c), '[]'::jsonb),
    coalesce((select jsonb_agg(to_jsonb(p) order by p.visitors desc) from p), '[]'::jsonb),
    (select count(*)::int from v where country_code is null)
  into v_countries, v_places, v_unknown;
  return jsonb_build_object(
    'ok', true, 'countries', v_countries, 'places', v_places, 'unknown', v_unknown
  );
end;
$$;

create or replace function public.rb_online_count()
returns jsonb language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'ok', true,
    'online', count(*),
    'players', count(*) filter (where player_id is not null)
  )
  from public.rb_presence
  where last_seen > now() - interval '90 seconds';
$$;

drop function if exists public.rb_submit_suggestion(uuid, text);
drop function if exists public.rb_list_suggestions(uuid, int);

create or replace function public.rb_submit_post(
  p_token uuid,
  p_kind text,
  p_message text,
  p_parent_id bigint default null
)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_player public.rb_players;
  v_message text := btrim(coalesce(p_message, ''));
  v_min int := case when p_kind = 'comment' then 1 else 3 end;
  v_parent public.rb_posts;
  v_id bigint;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  if coalesce(p_kind, '') not in ('announcement', 'suggestion', 'comment') then
    return jsonb_build_object('ok', false, 'error', 'invalid_kind');
  end if;
  if char_length(v_message) > 1000 or char_length(v_message) < v_min then
    return jsonb_build_object('ok', false, 'error', 'invalid_message');
  end if;

  if p_kind = 'announcement' then
    if not v_player.is_admin then
      return jsonb_build_object('ok', false, 'error', 'forbidden');
    end if;
    insert into public.rb_posts (kind, player_id, player_name, message, is_public)
    values ('announcement', v_player.id, v_player.name, v_message, true)
    returning id into v_id;

  elsif p_kind = 'suggestion' then
    if not v_player.is_admin and (select count(*) from public.rb_posts
        where player_id = v_player.id and kind = 'suggestion'
          and created_at > now() - interval '1 hour') >= 2 then
      return jsonb_build_object('ok', false, 'error', 'rate_limited');
    end if;
    insert into public.rb_posts (kind, player_id, player_name, message, is_public)
    values ('suggestion', v_player.id, v_player.name, v_message, false)
    returning id into v_id;

  else
    select * into v_parent from public.rb_posts where id = p_parent_id;
    if not found or v_parent.kind = 'comment' then
      return jsonb_build_object('ok', false, 'error', 'not_found');
    end if;
    -- Only admins may reply under a post that is not public yet.
    if not v_parent.is_public and not v_player.is_admin then
      return jsonb_build_object('ok', false, 'error', 'forbidden');
    end if;
    if not v_player.is_admin and (select count(*) from public.rb_posts
        where player_id = v_player.id and kind = 'comment'
          and created_at > now() - interval '1 hour') >= 10 then
      return jsonb_build_object('ok', false, 'error', 'rate_limited');
    end if;
    insert into public.rb_posts (kind, parent_id, player_id, player_name, message, is_public)
    values ('comment', v_parent.id, v_player.id, v_player.name, v_message, true)
    returning id into v_id;
  end if;

  return jsonb_build_object('ok', true, 'id', v_id);
end;
$$;

-- Admins see every announcement and suggestion. Everyone else sees the public
-- ones plus their own suggestions. Comments come with the post they belong to.
create or replace function public.rb_list_posts(p_token uuid, p_limit int default 100)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_player public.rb_players;
  v_data jsonb;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', t.id,
    'kind', t.kind,
    'player_name', t.player_name,
    'message', t.message,
    'is_public', t.is_public,
    'created_at', t.created_at,
    'mine', coalesce(t.player_id = v_player.id, false),
    'is_admin', coalesce(a.is_admin, false),
    'comments', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', c.id,
        'player_name', c.player_name,
        'message', c.message,
        'created_at', c.created_at,
        'mine', coalesce(c.player_id = v_player.id, false),
        'is_admin', coalesce(ca.is_admin, false)
      ) order by c.created_at asc), '[]'::jsonb)
      from public.rb_posts c
      left join public.rb_players ca on ca.id = c.player_id
      where c.parent_id = t.id
    )
  ) order by (t.kind = 'announcement') desc, t.created_at desc), '[]'::jsonb)
  into v_data
  from (
    select * from public.rb_posts p
    where p.kind <> 'comment'
      and (p.is_public or v_player.is_admin or p.player_id = v_player.id)
    order by (p.kind = 'announcement') desc, p.created_at desc
    limit least(greatest(coalesce(p_limit, 100), 1), 500)
  ) t
  left join public.rb_players a on a.id = t.player_id;
  return jsonb_build_object('ok', true, 'data', v_data);
end;
$$;

create or replace function public.rb_set_post_public(
  p_token uuid,
  p_post_id bigint,
  p_public boolean
)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_player public.rb_players;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  if not v_player.is_admin then
    return jsonb_build_object('ok', false, 'error', 'forbidden');
  end if;
  update public.rb_posts set is_public = coalesce(p_public, false)
  where id = p_post_id and kind = 'suggestion';
  if not found then
    return jsonb_build_object('ok', false, 'error', 'not_found');
  end if;
  return jsonb_build_object('ok', true);
end;
$$;

-- Deleting a post also deletes the comments under it.
create or replace function public.rb_delete_post(p_token uuid, p_post_id bigint)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_player public.rb_players;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  if not v_player.is_admin then
    return jsonb_build_object('ok', false, 'error', 'forbidden');
  end if;
  delete from public.rb_posts where id = p_post_id;
  if not found then
    return jsonb_build_object('ok', false, 'error', 'not_found');
  end if;
  return jsonb_build_object('ok', true);
end;
$$;

revoke execute on function
  public.rb_name_key(text), public.rb_valid_name(text), public.rb_norm_answer(text),
  public.rb_session_player(uuid), public.rb_open_session(uuid),
  public.rb_verify_challenge(text, text)
  from public, anon, authenticated;

grant execute on function
  public.rb_name_status(text),
  public.rb_check_challenge(text, text),
  public.rb_register(text, text, text, text),
  public.rb_login(text, text),
  public.rb_logout(uuid),
  public.rb_track_visit(uuid, text, text, text, text, text, double precision, double precision),
  public.rb_heartbeat(uuid, uuid),
  public.rb_my_games(uuid, int),
  public.rb_leaderboard(text, int),
  public.rb_stats_summary(int),
  public.rb_stats_series(int, int),
  public.rb_stats_heatmap(int, int),
  public.rb_stats_places(int, int, int),
  public.rb_online_count(),
  public.rb_submit_post(uuid, text, text, bigint),
  public.rb_list_posts(uuid, int),
  public.rb_set_post_public(uuid, bigint, boolean),
  public.rb_delete_post(uuid, bigint)
  to anon, authenticated;

-- Wallets, prize money, fines and crash bills.
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

-- Migration: level rules for the wallet
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

-- Migration: the player's level lives on the player
--
-- What it does
--   1. Adds rb_players.level (1 to 7, starts at 1).
--   2. Adds rb_sync_level: the app sends the level it has, the server keeps
--      the higher of the two and answers with the level to use. A level never
--      goes down, so the higher one is always the right one. This carries
--      progress made before this migration, offline or while playing
--      anonymously over to the account.

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
