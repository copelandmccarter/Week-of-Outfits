-- Week of Outfits: separate weeks and past looks.
-- Run once in the Supabase SQL Editor, after setup.sql.
-- Same access model as before: anyone with the site's link can view and edit.

-- One row per day per week. Weeks run Monday to Sunday and are keyed by Monday's date.
create table if not exists public.plans (
  week date not null check (extract(isodow from week) = 1),
  day text not null check (day in ('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun')),
  photos text[] not null default '{}',
  note text not null default '' check (char_length(note) <= 2000),
  updated_at timestamptz not null default now(),
  primary key (week, day)
);

alter table public.plans enable row level security;

grant select, insert, update on public.plans to anon;

create policy "Anyone can read plans"
  on public.plans for select to anon using (true);

create policy "Anyone can add plans"
  on public.plans for insert to anon with check (true);

create policy "Anyone can edit plans"
  on public.plans for update to anon using (true) with check (true);

-- Live sync between devices.
alter publication supabase_realtime add table public.plans;

-- Carry over what's in the old single-week table: each day goes into
-- the week (New York time) when it was last edited. The old table is left
-- in place, untouched.
insert into public.plans (week, day, photos, note, updated_at)
select date_trunc('week', updated_at at time zone 'America/New_York')::date,
       day, photos, note, updated_at
from public.days
where cardinality(photos) > 0 or note <> ''
on conflict (week, day) do nothing;
