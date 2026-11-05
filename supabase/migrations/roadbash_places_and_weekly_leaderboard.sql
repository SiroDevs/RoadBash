-- RoadBash: visitor countries and places, and the weekly leaderboard.
-- Run once on an existing database (Supabase SQL editor). It is safe to run again.
-- The same changes are also folded into roadbash.sql for fresh installs.

alter table public.rb_visits
  add column if not exists country_code text,
  add column if not exists country text,
  add column if not exists region text,
  add column if not exists city text,
  add column if not exists lat real,
  add column if not exists lng real;
create index if not exists rb_visits_country_idx on public.rb_visits (country_code, started_at);

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

grant execute on function
  public.rb_track_visit(uuid, text, text, text, text, text, double precision, double precision),
  public.rb_leaderboard(text, int),
  public.rb_stats_places(int, int, int)
  to anon, authenticated;
