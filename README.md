# Week of Outfits

Plan a week of outfits with reference photos for each day, then check today's look each morning.

- `index.html`: the whole app, a single static page (no build step). Deployed on Vercel.
- `supabase/setup.sql`: one-time Supabase setup. Creates the original `days` table, the public `outfits` photo bucket, and the access rules.
- `supabase/weeks.sql`: run once after `setup.sql`. Adds the `plans` table (one row per day per week, keyed by the week's Monday) that the app now uses, and copies the old `days` rows into it.

Each week is its own plan. Photos from earlier weeks show up under **Past looks**, where any of them can be added to a day this week or next. You can also paste a copied image (for example from Pinterest's "Copy image") straight into a day.

## Storage

Data lives in Supabase. The project URL and publishable key are in `index.html`; the publishable key is meant for browser code, and the rules in `setup.sql` limit it to reading/editing the week and adding/removing photos.

Access is "anyone with the link": there is no login, so anyone with the site's address can view and edit the plan.

## Run locally

```bash
python3 -m http.server 5173
```

Then open http://127.0.0.1:5173.
