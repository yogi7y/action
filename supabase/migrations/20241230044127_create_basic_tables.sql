-- Enable necessary extensions and create ENUMs
create extension if not exists "uuid-ossp";

create type task_status as enum ('todo', 'in_progress', 'done');

-- Create tables
create table if not exists projects (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists contexts (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists tasks (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  status task_status not null default 'todo',
  due_date date,
  project_id uuid references projects(id) on delete set null,
  context_id uuid references contexts(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Add triggers for updated_at
create or replace function update_updated_at_column()
returns trigger as $$
begin
    new.updated_at = now();
    return new;
end;
$$ language plpgsql;

create trigger update_tasks_updated_at
    before update on tasks
    for each row
    execute function update_updated_at_column();

create trigger update_projects_updated_at
    before update on projects
    for each row
    execute function update_updated_at_column();

create trigger update_contexts_updated_at
    before update on contexts
    for each row
    execute function update_updated_at_column();


-- Enable Row Level Security (RLS)
alter table projects enable row level security;
alter table contexts enable row level security;
alter table tasks enable row level security;
