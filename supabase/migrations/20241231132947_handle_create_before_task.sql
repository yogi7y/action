create or replace function handle_new_task()
returns trigger as $$
begin
  -- Only set user_id if it's not already set
  if new.user_id is null then
    new.user_id = auth.uid();
  end if;
  return new;
end;
$$ language plpgsql security definer;

-- Create the trigger that runs before insert
create trigger set_task_user_id
  before insert on tasks
  for each row
  execute function handle_new_task();



-- Projects trigger
create or replace function handle_new_project()
returns trigger as $$
begin
  if new.user_id is null then
    new.user_id = auth.uid();
  end if;
  return new;
end;
$$ language plpgsql security definer;

create trigger set_project_user_id
  before insert or update on projects
  for each row
  execute function handle_new_project();

-- Contexts trigger
create or replace function handle_new_context()
returns trigger as $$
begin
  if new.user_id is null then
    new.user_id = auth.uid();
  end if;
  return new;
end;
$$ language plpgsql security definer;

create trigger set_context_user_id
  before insert or update on contexts
  for each row
  execute function handle_new_context();