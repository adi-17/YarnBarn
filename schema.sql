-- Run in Supabase SQL Editor after creating your project.
create extension if not exists pgcrypto;
create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade
);
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 120),
  description text not null default '',
  price numeric(10,2) not null check (price >= 0),
  image_path text,
  category text not null default 'Handmade',
  available boolean not null default true,
  created_at timestamptz not null default now()
);
create index if not exists products_created_at_idx on public.products(created_at desc);
alter table public.admin_users enable row level security;
alter table public.products enable row level security;
create policy "Admins can see own membership" on public.admin_users for select to authenticated using (user_id = (select auth.uid()));
create policy "Anyone can see products" on public.products for select to anon, authenticated using (true);
create policy "Admins can add products" on public.products for insert to authenticated with check (exists (select 1 from public.admin_users where user_id = (select auth.uid())));
create policy "Admins can edit products" on public.products for update to authenticated using (exists (select 1 from public.admin_users where user_id = (select auth.uid()))) with check (exists (select 1 from public.admin_users where user_id = (select auth.uid())));
create policy "Admins can delete products" on public.products for delete to authenticated using (exists (select 1 from public.admin_users where user_id = (select auth.uid())));
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('product-photos', 'product-photos', true, 5242880, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set public = true, file_size_limit = 5242880, allowed_mime_types = array['image/jpeg','image/png','image/webp','image/gif'];
create policy "Anyone can view product photos" on storage.objects for select to anon, authenticated using (bucket_id = 'product-photos');
create policy "Admins upload product photos" on storage.objects for insert to authenticated with check (bucket_id = 'product-photos' and exists (select 1 from public.admin_users where user_id = (select auth.uid())));
create policy "Admins delete product photos" on storage.objects for delete to authenticated using (bucket_id = 'product-photos' and exists (select 1 from public.admin_users where user_id = (select auth.uid())));
-- After signing up your admin user in Supabase Authentication, run:
-- insert into public.admin_users (user_id) values ('PASTE_ADMIN_USER_UUID_HERE');
