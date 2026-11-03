
begin;

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

alter table public.rb_posts enable row level security;
revoke all on public.rb_posts from public, anon, authenticated;

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

-- Compatibility wrappers for app versions that still use the suggestion box.
create or replace function public.rb_submit_suggestion(p_token uuid, p_message text)
returns jsonb language sql security definer set search_path = public as $$
  select public.rb_submit_post(p_token, 'suggestion', p_message, null);
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
    select * from public.rb_posts
    where kind = 'suggestion'
    order by created_at desc
    limit least(greatest(coalesce(p_limit, 100), 1), 500)
  ) s;
  return jsonb_build_object('ok', true, 'data', v_data);
end;
$$;

revoke execute on function
  public.rb_submit_post(uuid, text, text, bigint),
  public.rb_list_posts(uuid, int),
  public.rb_set_post_public(uuid, bigint, boolean),
  public.rb_delete_post(uuid, bigint),
  public.rb_submit_suggestion(uuid, text),
  public.rb_list_suggestions(uuid, int)
  from public;

grant execute on function
  public.rb_submit_post(uuid, text, text, bigint),
  public.rb_list_posts(uuid, int),
  public.rb_set_post_public(uuid, bigint, boolean),
  public.rb_delete_post(uuid, bigint),
  public.rb_submit_suggestion(uuid, text),
  public.rb_list_suggestions(uuid, int)
  to anon, authenticated;

commit;
