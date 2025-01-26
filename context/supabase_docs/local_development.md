# Local development with schema migrations

Supabase is a flexible platform that lets you decide how you want to build your projects. You can use the Dashboard directly to get up and running quickly, or use a proper local setup. We suggest you work locally and deploy your changes to a linked project on the [Supabase Platform](https://app.supabase.io/).

Develop locally using the CLI to run a local Supabase stack. You can use the integrated Studio Dashboard to make changes, then capture your changes in schema migration files, which can be saved in version control.

Alternatively, if you're comfortable with migration files and SQL, you can write your own migrations and push them to the local database for testing before sharing your changes.

## Database migrations

Database changes are managed through "migrations." Database migrations are a common way of tracking changes to your database over time.

For this guide, we'll create a table called `employees` and see how we can make changes to it.

### Step 1: Create your first migration file

To get started, generate a [new migration](https://supabase.com/docs/reference/cli/supabase-migration-new) to store the SQL needed to create our `employees` table:

```bash
supabase migration new create_employees_table
```

### Step 2: Add the SQL to your migration file

This creates a new migration file: `supabase/migrations/<timestamp>_create_employees_table.sql`. Add the following SQL to create the `employees` table:

```sql
create table employees (
  id bigint primary key generated always as identity,
  name text,
  email text,
  created_at timestamptz default now()
);
```

### Step 3: Apply your migration

Now that you have a migration file, run this migration to create the `employees` table. Use the `reset` command to reset the database to the current migrations:

```bash
supabase db reset
```

### Step 4: Modify your employees table

Visit your new `employees` table in the Dashboard. Next, modify it by adding a column for department. Create a new migration file:

```bash
supabase migration new add_department_to_employees_table
```

### Step 5: Add a new column to your table

This creates a new migration file: `supabase/migrations/<timestamp>_add_department_to_employees_table.sql`. Add the following SQL to the file to create the new department column:

```sql
alter table if exists public.employees add department text default 'Hooli';
```

### Add sample data

Now that you are managing your database with migration scripts, you can add seed data to use every time you reset the database. Create a seed script in `supabase/seed.sql`:

#### Step 1: Populate your table

Insert data into your `employees` table with the `supabase/seed.sql` file:

```sql
-- in supabase/seed.sql
insert into public.employees (name)
values
('Erlich Bachman'),
('Richard Hendricks'),
('Monica Hall');
```

#### Step 2: Reset your database

Reset your database to apply the current migrations and populate it with seed data:

```bash
supabase db reset
```

You should now see the `employees` table, along with your seed data in the Dashboard. All of your database changes are captured in code, and you can reset to a known state at any time, complete with seed data.

## Diffing changes

This workflow is great if you know SQL and are comfortable creating tables and columns. If not, you can still use the Dashboard to create tables and columns, then use the CLI to diff your changes and create migrations.

Create a new table called `cities` with columns `id`, `name`, and `population`. To see the corresponding SQL, use the `supabase db diff --schema public` command:

```bash
supabase db diff --schema public
```

The output will look something like this:

```sql
create table "public"."cities" (
  "id" bigint primary key generated always as identity,
  "name" text,
  "population" bigint
);
```

Copy this SQL into a new migration file and run `supabase db reset` to apply the changes.

## Deploy your project

Once you're satisfied with your local changes, deploy your project to the Supabase Platform and scale up to millions of users!

### Log in to the Supabase CLI

```bash
supabase login
```

### Link your project

Associate your project with your remote project using `supabase link`:

```bash
supabase link --project-ref <project-id>
```

### Deploy database changes

Deploy any local database migrations using `db push`:

```bash
supabase db push
```

### Deploy Edge Functions

If your project uses Edge Functions, deploy them using `functions deploy`:

```bash
supabase functions deploy <function_name>
```

## Use Auth locally

Update your `supabase/config.toml` file to configure Auth providers. For example:

```toml
[auth.external.github]
enabled = true
client_id = "env(SUPABASE_AUTH_GITHUB_CLIENT_ID)"
secret = "env(SUPABASE_AUTH_GITHUB_SECRET)"
redirect_uri = "http://localhost:54321/auth/v1/callback"
```

Add secret values to your `.env` file:

```bash
SUPABASE_AUTH_GITHUB_CLIENT_ID="redacted"
SUPABASE_AUTH_GITHUB_SECRET="redacted"
```

Restart your local Supabase instance:

```bash
supabase stop
supabase start
```

## Sync storage buckets

To define storage buckets locally, add them to your `supabase/config.toml` file:

```toml
[storage.buckets.images]
public = false
file_size_limit = "50MiB"
allowed_mime_types = ["image/png", "image/jpeg"]
objects_path = "./images"
```

Sync files using:

```bash
supabase seed buckets
```

## Limitations and considerations

- You cannot update your project settings in the Dashboard locally.
- Keep your [Supabase CLI up to date](https://github.com/supabase/cli#getting-started).
