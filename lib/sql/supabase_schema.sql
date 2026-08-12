-- Supabase schema SQL for the Flutter app
-- Tables: profiles, messages, products
-- Row Level Security (RLS) policies so only owners can modify their data

-- Enable UUID generation
create extension if not exists "pgcrypto";

-- Profiles table (one row per auth user)
create table if not exists profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text,
  avatar_url text,
  updated_at timestamptz
);

-- Messages table
create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  content text not null,
  user_id uuid not null references auth.users (id) on delete cascade,
  room_id text not null default 'general',
  created_at timestamptz not null default now()
);

create index if not exists messages_room_created_idx on messages (room_id, created_at desc);

-- Optional products table used by the demo filter method
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text,
  price numeric(10,2) not null default 0,
  created_at timestamptz not null default now()
);

-- Row Level Security (RLS) policies

-- Profiles: allow public read, but only the user may insert/update/delete their profile
alter table profiles enable row level security;
create policy profiles_read on profiles for select using (true);
create policy profiles_modify_own on profiles for insert, update using (auth.uid() = id) with check (auth.uid() = id);
create policy profiles_delete_own on profiles for delete using (auth.uid() = id);

-- Messages: public read (channels), only owners can insert/update/delete their messages
alter table messages enable row level security;
create policy messages_read_public on messages for select using (true);
create policy messages_insert_own on messages for insert using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy messages_update_own on messages for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy messages_delete_own on messages for delete using (auth.uid() = user_id);

-- Products: allow public read (used by filter demo); writes are restricted (no generic write policy)
alter table products enable row level security;
create policy products_read on products for select using (true);

-- Notes:
-- - The app uses `supabase.auth.currentUser!.id` for `profiles.id` and `messages.user_id`.
-- - If you need server-side functions, triggers, or more granular roles (moderator/admin), add policies accordingly.
