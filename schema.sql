-- Run in Supabase: SQL Editor > New query
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  target_company text,
  created_at timestamptz default now()
);
alter table public.profiles enable row level security;
create policy "Read own profile" on public.profiles for select using (auth.uid() = id);
create policy "Update own profile" on public.profiles for update using (auth.uid() = id);

create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name, target_company)
  values (new.id,
          coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name'),
          new.raw_user_meta_data->>'target_company');
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute function public.handle_new_user();
