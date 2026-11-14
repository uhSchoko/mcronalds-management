-- McRonalds Management Portal starter schema for Supabase (PostgreSQL)
-- Run in Supabase SQL Editor after creating a project.
-- IMPORTANT: Roblox identity verification and role assignment must happen server-side.
create type public.staff_status as enum ('active','on_leave','inactive');
create type public.request_status as enum ('pending','under_review','approved','declined');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  roblox_user_id text unique not null,
  roblox_username text not null,
  display_name text,
  rank_name text not null default 'Trainee',
  department text not null default 'Operations',
  staff_status public.staff_status not null default 'active',
  portal_role text not null default 'employee'
    check (portal_role in ('employee','hr','management','corporate','presidential')),
  created_at timestamptz not null default now()
);

create table public.applications (
  id uuid primary key default gen_random_uuid(),
  applicant_roblox_id text,
  applicant_username text not null,
  application_type text not null,
  status public.request_status not null default 'pending',
  reviewer uuid references public.profiles(id),
  notes text,
  created_at timestamptz not null default now()
);

create table public.rank_changes (
  id uuid primary key default gen_random_uuid(),
  employee uuid not null references public.profiles(id),
  old_rank text not null,
  new_rank text not null,
  approved_by uuid not null references public.profiles(id),
  reason text,
  created_at timestamptz not null default now()
);

create table public.activity_logs (
  id uuid primary key default gen_random_uuid(),
  employee uuid not null references public.profiles(id),
  activity_type text not null,
  details text,
  duration_minutes integer check (duration_minutes is null or duration_minutes >= 0),
  recorded_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table public.training_sessions (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  host uuid references public.profiles(id),
  starts_at timestamptz not null,
  capacity integer check (capacity is null or capacity > 0),
  status text not null default 'scheduled',
  created_at timestamptz not null default now()
);

create table public.training_attendance (
  session_id uuid references public.training_sessions(id) on delete cascade,
  employee uuid references public.profiles(id) on delete cascade,
  result text,
  attended_at timestamptz,
  primary key (session_id, employee)
);

create table public.loa_requests (
  id uuid primary key default gen_random_uuid(),
  employee uuid not null references public.profiles(id),
  reason text not null,
  starts_on date not null,
  ends_on date not null,
  status public.request_status not null default 'pending',
  reviewed_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  check (ends_on >= starts_on)
);

alter table public.profiles enable row level security;
alter table public.applications enable row level security;
alter table public.rank_changes enable row level security;
alter table public.activity_logs enable row level security;
alter table public.training_sessions enable row level security;
alter table public.training_attendance enable row level security;
alter table public.loa_requests enable row level security;

-- Do not add broad public write policies. Add role-aware policies only after
-- implementing a trusted server-side Roblox verification + role provisioning flow.
-- Never expose the Supabase service_role key in browser code.
