-- Week of Outfits: one-time Supabase setup.
-- Run once in the Supabase SQL Editor. Access is "anyone with the link":
-- the public (anon) key can read and edit the week and manage photos, nothing else.

-- One row per weekday: ordered photo paths plus a note.
create table public.days (
  day text primary key check (day in ('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun')),
  photos text[] not null default '{}',
  note text not null default '' check (char_length(note) <= 2000),
  updated_at timestamptz not null default now()
);

alter table public.days enable row level security;

insert into public.days (day)
values ('mon'), ('tue'), ('wed'), ('thu'), ('fri'), ('sat'), ('sun');

-- The seven rows are fixed, so the app only needs to read and update them.
grant select, update on public.days to anon;

create policy "Anyone can read the week"
  on public.days for select to anon using (true);

create policy "Anyone can edit the week"
  on public.days for update to anon using (true) with check (true);

-- Live sync between devices.
alter publication supabase_realtime add table public.days;

-- Photo storage: public bucket, JPEGs up to 10 MB (the app resizes before upload).
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('outfits', 'outfits', true, 10485760, array['image/jpeg']);

create policy "Anyone can view outfit photos"
  on storage.objects for select to anon using (bucket_id = 'outfits');

create policy "Anyone can upload outfit photos"
  on storage.objects for insert to anon with check (bucket_id = 'outfits');

create policy "Anyone can delete outfit photos"
  on storage.objects for delete to anon using (bucket_id = 'outfits');
