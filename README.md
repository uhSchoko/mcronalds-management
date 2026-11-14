# McRonalds Management Portal — starter build

## Included
- `index.html`: responsive corporate-style portal preview.
- `supabase_schema.sql`: starter PostgreSQL schema for a real hosted database.

## Preview it
Open `index.html` in a browser. Choose **Enter preview workspace**.
The preview includes sample employees and working add/update/export controls.
Preview records are stored in that browser's local storage only; they are not shared
between employees, devices or browsers.

## Free hosting path
1. Create a GitHub repository and upload `index.html`.
2. Deploy the repository with Cloudflare Pages (free plan) or GitHub Pages.
3. Create a Supabase project on its free plan for shared data and authentication.
4. Run `supabase_schema.sql` in the Supabase SQL Editor.
5. Build a server-side API (for example Cloudflare Worker) to verify Roblox identity,
   provision a Supabase user, check company roles, and perform privileged actions.

## Roblox login — important
This package does NOT pretend to authenticate Roblox accounts. The Roblox button
explains that setup is required. Do not ask staff for Roblox passwords, browser
cookies, `.ROBLOSECURITY` values or two-factor codes.

A safe implementation needs a trusted identity verification method (such as an
established Roblox group verification provider with an API, or a carefully designed
server-side username-ownership challenge), plus server-side authorization. Roblox
group rank changes also require a secure server-side integration and appropriate
Open Cloud permissions. Never put API keys or service-role keys in `index.html`.

## Before real company use
- Replace demo data and remove preview/admin access.
- Add real authentication and server-enforced role permissions.
- Add audit logs for rank changes and presidential actions.
- Configure database row-level security policies.
- Add backups, privacy notice, and staff data retention rules.
