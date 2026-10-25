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

create table if not exists public.rb_suggestions (
  id bigint generated always as identity primary key,
  player_id uuid references public.rb_players(id) on delete set null,
  player_name text not null,
  message text not null check (char_length(message) between 3 and 1000),
  created_at timestamptz not null default now()
);
create index if not exists rb_suggestions_created_idx on public.rb_suggestions (created_at desc);

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
alter table public.rb_suggestions enable row level security;

revoke all on public.rb_players, public.rb_reserved_names, public.rb_config,
  public.rb_sessions, public.rb_visits, public.rb_presence, public.rb_games,
  public.rb_suggestions, public.rb_player_activity
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

create or replace function public.rb_track_visit(p_visitor uuid, p_platform text default null)
returns jsonb language plpgsql security definer set search_path = public as $$
begin
  if p_visitor is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_visitor');
  end if;
  if not exists (
    select 1 from public.rb_visits
    where visitor_id = p_visitor and started_at > now() - interval '1 minute'
  ) then
    insert into public.rb_visits (visitor_id, platform)
    values (p_visitor, left(coalesce(p_platform, ''), 20));
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

create or replace function public.rb_record_game(
  p_token uuid,
  p_scene text,
  p_place int,
  p_time_ms int
)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_player public.rb_players;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  if p_scene not in ('city', 'suburbs')
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
  values (v_player.id, p_scene, p_place, p_time_ms);
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

create or replace function public.rb_leaderboard(p_limit int default 50)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_data jsonb;
begin
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
      group by p.id, p.name
    ) t
    order by t.wins desc, t.games asc, lower(t.name)
    limit least(greatest(coalesce(p_limit, 50), 1), 200)
  ) r;
  return jsonb_build_object('ok', true, 'data', v_data);
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

create or replace function public.rb_submit_suggestion(p_token uuid, p_message text)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_player public.rb_players;
  v_message text := btrim(coalesce(p_message, ''));
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  if char_length(v_message) < 3 or char_length(v_message) > 1000 then
    return jsonb_build_object('ok', false, 'error', 'invalid_message');
  end if;
  if (select count(*) from public.rb_suggestions
      where player_id = v_player.id and created_at > now() - interval '1 hour') >= 5 then
    return jsonb_build_object('ok', false, 'error', 'rate_limited');
  end if;
  insert into public.rb_suggestions (player_id, player_name, message)
  values (v_player.id, v_player.name, v_message);
  return jsonb_build_object('ok', true);
end;
$$;

create or replace function public.rb_list_suggestions(p_token uuid, p_limit int default 100)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare
  v_player public.rb_players;
  v_data jsonb;
begin
  select * into v_player from public.rb_session_player(p_token);
  if v_player.id is null then
    return jsonb_build_object('ok', false, 'error', 'invalid_session');
  end if;
  if not v_player.is_admin then
    return jsonb_build_object('ok', false, 'error', 'forbidden');
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', s.id, 'player_name', s.player_name, 'message', s.message, 'created_at', s.created_at
  ) order by s.created_at desc), '[]'::jsonb)
  into v_data
  from (
    select * from public.rb_suggestions
    order by created_at desc
    limit least(greatest(coalesce(p_limit, 100), 1), 500)
  ) s;
  return jsonb_build_object('ok', true, 'data', v_data);
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
  public.rb_track_visit(uuid, text),
  public.rb_heartbeat(uuid, uuid),
  public.rb_record_game(uuid, text, int, int),
  public.rb_my_games(uuid, int),
  public.rb_leaderboard(int),
  public.rb_stats_summary(int),
  public.rb_stats_series(int, int),
  public.rb_stats_heatmap(int, int),
  public.rb_submit_suggestion(uuid, text),
  public.rb_list_suggestions(uuid, int)
  to anon, authenticated;
