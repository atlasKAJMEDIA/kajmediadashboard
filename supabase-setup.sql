-- ============================================================
--  KAJ Media Command — Supabase setup
--  Run this ONCE: Supabase dashboard → SQL Editor → paste → Run.
-- ============================================================

-- Shared workspace: the whole app state lives in one JSON row.
create table if not exists public.workspace (
  id          text primary key default 'main',
  data        jsonb       not null default '{"clients":[],"members":[],"activity":[],"meta":{}}'::jsonb,
  updated_at  timestamptz not null default now(),
  updated_by  text
);

-- Row Level Security: only signed-in users can touch it.
alter table public.workspace enable row level security;

drop policy if exists "authenticated read"   on public.workspace;
drop policy if exists "authenticated insert" on public.workspace;
drop policy if exists "authenticated update" on public.workspace;

create policy "authenticated read"   on public.workspace for select to authenticated using (true);
create policy "authenticated insert" on public.workspace for insert to authenticated with check (true);
create policy "authenticated update" on public.workspace for update to authenticated using (true) with check (true);

-- Seed the single shared row.
insert into public.workspace (id, data)
values ('main', '{"clients":[],"members":[],"activity":[],"meta":{}}'::jsonb)
on conflict (id) do nothing;

-- Realtime: every open dashboard updates live when anyone saves.
do $$
begin
  alter publication supabase_realtime add table public.workspace;
exception
  when duplicate_object then null;  -- already added, ignore
end $$;

-- Done. Open your deployed site and create the first (team) account.
