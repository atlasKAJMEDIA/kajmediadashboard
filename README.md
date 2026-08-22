# KAJ Media Command

A client progress tracker & KPI dashboard for **KAJ Media** — appointment setting + personal branding tracks, with **real accounts**, live realtime sync, per-edit attribution, an activity feed, an agency business roll-up (MRR / ARPU / LTV / churn), and client-facing reports.

Single static `index.html` + a vendored Supabase client (`vendor/supabase.js`). No build step.

---

## Setup (one time, ~5 minutes)

### 1. Create the database table
Open **Supabase → SQL Editor**, paste the contents of [`supabase-setup.sql`](./supabase-setup.sql), and **Run**. This creates the `workspace` table, row-level security, a seed row, and turns on realtime.

### 2. Auth settings
In **Supabase → Authentication → Providers → Email**, make sure Email is enabled.
- Leave **"Confirm email" ON** for security (users click a link in their email before first login), **or**
- turn it **OFF** if you want teammates/clients to log in instantly after signing up.

The Supabase project URL + publishable key are already wired into `index.html` (the `window.KAJ` block at the top). The publishable key is safe to expose — RLS is what protects the data.

### 3. Deploy on Vercel
1. **vercel.com → Add New → Project** → import **`atlasKAJMEDIA/kajmediadashboard`**.
2. Framework preset **Other**, Root Directory `./`, no build settings.
3. **Deploy** → you get a live URL like `kajmediadashboard.vercel.app`.

Every push to `main` auto-redeploys.

---

## Using it

- **First run:** open the site → **Create an account** → "I'm KAJ team" → you're in. Add your clients.
- **Invite a teammate:** they open the same URL → Create an account → "I'm KAJ team". Everything they log is stamped with their name and synced live to everyone.
- **Invite a client:** they Create an account → **"I'm a client"** → pick their brand (you must add the client first). They see only their own brand's live dashboard & report, and can't edit.
- **Live sync:** any change anyone saves appears on every open screen within a second (Supabase realtime). The header shows **"Synced live"**.

## Data model

The whole app state is one JSON document in the `workspace` table's single row, saved on change and streamed back out over realtime. Sign-in identity (name / role / brand) lives in Supabase Auth user metadata.

### Security note (read this)
Current RLS lets **any signed-in user read the shared workspace row**. Client-role users only ever *see* their own brand in the UI — but a technically savvy client could read the raw row via the API. For agency↔client trust this is usually fine for v1. If you need **strict per-client data isolation** (a client physically cannot read other clients' data), that's a normalized-schema + per-row-RLS upgrade — open an issue / ask and it can be added.

## Runtime modes

The same file adapts to where it runs:
- **Supabase** (this deploy) — real accounts + shared realtime DB.
- **Local** — if Supabase can't load, it falls back to per-browser localStorage so the app still works.
- **Claude artifact** — uses the artifact's own shared store.

## Local preview
```bash
python3 -m http.server 8080   # then visit http://localhost:8080
```
