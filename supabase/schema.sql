-- SCAR 3D: esquema inicial para Supabase (PostgreSQL)
-- Ejecutar en Supabase > SQL Editor, después de crear el proyecto.
-- Administrador único autorizado: rufranz.chiqui@gmail.com

create extension if not exists pgcrypto;

-- Comprobación de administrador basada en el JWT autenticado.
-- La política se ejecuta en el servidor; no depende de ocultar botones en el navegador.
create or replace function public.scar3d_is_admin()
returns boolean
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce((auth.jwt() ->> 'email') = 'rufranz.chiqui@gmail.com', false);
$$;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null,
  description text not null default '',
  price numeric(12,2) not null default 0 check (price >= 0),
  image_urls text[] not null default '{}',
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.store_contacts (
  id integer primary key default 1 check (id = 1),
  whatsapp text not null default '59177748285',
  email text not null default 'rufranz.chiqui@gmail.com',
  address text not null default 'La Paz - El Alto, Bolivia',
  social_url text not null default '',
  updated_at timestamptz not null default now()
);
insert into public.store_contacts (id) values (1) on conflict (id) do nothing;

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  customer_phone text not null default '',
  customer_email text not null default '',
  items jsonb not null,
  total numeric(12,2) not null default 0 check (total >= 0),
  notes text not null default '',
  status text not null default 'recibido'
    check (status in ('recibido','confirmado','en_preparacion','listo','entregado','cancelado')),
  created_at timestamptz not null default now()
);

alter table public.products enable row level security;
alter table public.store_contacts enable row level security;
alter table public.orders enable row level security;

-- Lectura pública solo de productos activos.
drop policy if exists "Public can read active products" on public.products;
create policy "Public can read active products"
on public.products for select to anon, authenticated
using (active = true or public.scar3d_is_admin());

drop policy if exists "Only admin inserts products" on public.products;
create policy "Only admin inserts products"
on public.products for insert to authenticated
with check (public.scar3d_is_admin());

drop policy if exists "Only admin updates products" on public.products;
create policy "Only admin updates products"
on public.products for update to authenticated
using (public.scar3d_is_admin())
with check (public.scar3d_is_admin());

drop policy if exists "Only admin deletes products" on public.products;
create policy "Only admin deletes products"
on public.products for delete to authenticated
using (public.scar3d_is_admin());

drop policy if exists "Public can read store contacts" on public.store_contacts;
create policy "Public can read store contacts"
on public.store_contacts for select to anon, authenticated
using (true);

drop policy if exists "Only admin updates store contacts" on public.store_contacts;
create policy "Only admin updates store contacts"
on public.store_contacts for update to authenticated
using (public.scar3d_is_admin())
with check (public.scar3d_is_admin());

-- Los clientes pueden crear pedidos sin cuenta. Solo el administrador puede leerlos o gestionarlos.
drop policy if exists "Anyone can submit an order" on public.orders;
create policy "Anyone can submit an order"
on public.orders for insert to anon, authenticated
with check (
  length(trim(customer_name)) between 1 and 120
  and jsonb_typeof(items) = 'array'
  and jsonb_array_length(items) between 1 and 50
);

drop policy if exists "Only admin reads orders" on public.orders;
create policy "Only admin reads orders"
on public.orders for select to authenticated
using (public.scar3d_is_admin());

drop policy if exists "Only admin updates orders" on public.orders;
create policy "Only admin updates orders"
on public.orders for update to authenticated
using (public.scar3d_is_admin())
with check (public.scar3d_is_admin());

drop policy if exists "Only admin deletes orders" on public.orders;
create policy "Only admin deletes orders"
on public.orders for delete to authenticated
using (public.scar3d_is_admin());

-- Bucket público para mostrar imágenes de productos. Escritura y borrado solo del administrador.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('scar3d-products', 'scar3d-products', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public = true, file_size_limit = 5242880,
  allowed_mime_types = array['image/jpeg','image/png','image/webp'];

drop policy if exists "Public can view SCAR 3D product images" on storage.objects;
create policy "Public can view SCAR 3D product images"
on storage.objects for select to anon, authenticated
using (bucket_id = 'scar3d-products');

drop policy if exists "Only SCAR 3D admin uploads images" on storage.objects;
create policy "Only SCAR 3D admin uploads images"
on storage.objects for insert to authenticated
with check (bucket_id = 'scar3d-products' and public.scar3d_is_admin());

drop policy if exists "Only SCAR 3D admin updates images" on storage.objects;
create policy "Only SCAR 3D admin updates images"
on storage.objects for update to authenticated
using (bucket_id = 'scar3d-products' and public.scar3d_is_admin())
with check (bucket_id = 'scar3d-products' and public.scar3d_is_admin());

drop policy if exists "Only SCAR 3D admin deletes images" on storage.objects;
create policy "Only SCAR 3D admin deletes images"
on storage.objects for delete to authenticated
using (bucket_id = 'scar3d-products' and public.scar3d_is_admin());

-- Importante: no crear políticas públicas para actualizar productos, contactos o pedidos.
