# Week of Outfits

Plan a week of outfits with reference photos for each day, then check today's look each morning.

- `index.html`: the whole app, a single static page (no build step). Deployed on Vercel.
- `supabase/setup.sql`: one-time Supabase setup. Creates the `days` table (one row per weekday with photo paths and a note), the public `outfits` photo bucket, and the access rules.

## Storage

Data lives in Supabase. The project URL and publishable key are in `index.html`; the publishable key is meant for browser code, and the rules in `setup.sql` limit it to reading/editing the week and adding/removing photos.

Access is "anyone with the link": there is no login, so anyone with the site's address can view and edit the plan.

## Run locally

```bash
python3 -m http.server 5173
```

Then open http://127.0.0.1:5173.
