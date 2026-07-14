create extension if not exists pgcrypto;

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 200),
  details text not null default '',
  deadline timestamptz,
  priority text not null default 'normal' check (priority in ('low','normal','high')),
  status text not null default 'active' check (status in ('active','done','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.tasks enable row level security;

drop policy if exists "Users can view own tasks" on public.tasks;
drop policy if exists "Users can create own tasks" on public.tasks;
drop policy if exists "Users can update own tasks" on public.tasks;
drop policy if exists "Users can delete own tasks" on public.tasks;

create policy "Users can view own tasks" on public.tasks for select to authenticated using ((select auth.uid()) = user_id);
create policy "Users can create own tasks" on public.tasks for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Users can update own tasks" on public.tasks for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "Users can delete own tasks" on public.tasks for delete to authenticated using ((select auth.uid()) = user_id);

create index if not exists tasks_user_id_idx on public.tasks(user_id);
create index if not exists tasks_user_status_idx on public.tasks(user_id,status);
create index if not exists tasks_user_deadline_idx on public.tasks(user_id,deadline);

alter publication supabase_realtime add table public.tasks;
