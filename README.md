# KAJ Media Command

A client progress tracker & KPI dashboard for **KAJ Media** — appointment setting + personal branding tracks, with soft sign-in, per-edit attribution, an activity feed, an agency business roll-up (MRR / ARPU / LTV / churn), and live client-facing reports.

It's a **single static file** (`index.html`) — no build step, no dependencies.

## Deploy on Vercel (2 minutes)

1. Go to **vercel.com → Add New → Project**.
2. Import this repo: **`atlasKAJMEDIA/kajmediadashboard`** (authorize Vercel for GitHub if asked).
3. On the import screen leave everything default:
   - **Framework Preset** → **Other**
   - **Root Directory** → `./` (root — the app is here)
   - Build & Output settings → leave empty (it's static)
4. Click **Deploy**. You'll get a live URL like `kajmediadashboard.vercel.app` — share it with your team and clients.

Every push to `main` auto-redeploys.

## How data is saved

- **On Vercel (this hosted version):** state is saved in each visitor's **browser (localStorage)** — fully usable and private per device, but **not shared across people or devices**, and there is **no password login** (sign-in is name-based identity only).
- **Inside the Claude artifact link:** state is saved to a shared file so everyone on the link sees the same data live.

### Want real shared logins + synced data across everyone?
That needs a small backend (database + auth). Recommended: **Supabase** (free tier) or **Vercel KV**. The app is built so this is a contained upgrade — `state` is one JSON object loaded in `boot()` and written in `doSave()`; swap localStorage for a Supabase table and sign-in maps straight onto real auth.

## Features

- **Sign-in** — name + role (KAJ team / client). Clients see only their own brand's dashboard & report.
- **Agency Overview** — retainer MRR, ARPU, est. client LTV, churn, calls booked/closed, client-movement breakdown, time-range switch (day/week/month/quarter/year).
- **Per-client dashboards** — Overview (strategy + goals vs actuals), Log KPIs (daily entry), Trends (sparklines + deltas), Tasks, Pipeline (setting) / Delivery (branding), and a client-facing Report.
- **KPIs from KAJ SOPs** — appointment-setting funnel (outreach → closed) and personal-branding metrics (reach, followers, engagement, revenue…), plus agency benchmarks.
- **Activity feed + members** — every edit stamped with who did it and when.
- **Light / dark theme**, responsive, keyboard-friendly.

## Local preview

```bash
python3 -m http.server 8080   # then visit http://localhost:8080
```
