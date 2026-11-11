-- Run this once in Supabase: SQL Editor > New query > paste > Run

create table if not exists public.sitelog (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  json       text   not null,
  saved_at   bigint,
  updated_at timestamptz not null default now()
);

alter table public.sitelog enable row level security;

-- Each signed-in user can only see and change their own row
create policy "read own data"   on public.sitelog for select using (auth.uid() = user_id);
create policy "insert own data" on public.sitelog for insert with check (auth.uid() = user_id);
create policy "update own data" on public.sitelog for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "delete own data" on public.sitelog for delete using (auth.uid() = user_id);
