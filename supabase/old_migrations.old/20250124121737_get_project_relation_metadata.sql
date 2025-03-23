-- get_project_relation_metadata returns a json object with the following fields:
-- - project_id: the id of the project
-- - total_tasks: the total number of tasks in the project
-- - completed_tasks: the number of completed tasks in the project
-- - total_pages: the total number of pages in the project
create or replace function get_project_relation_metadata(project_id text)
returns json
language plpgsql
security definer
as $$
declare
  result json;
begin
  select json_build_object(
    'project_id', p.id,
    'total_tasks', (select count(*) from tasks t where t.project_id = p.id),
    'completed_tasks', (select count(*) from tasks t where t.project_id = p.id and t.checkbox_state = 'checked'),
    'total_pages', (select count(*) from pages pg where pg.project_id = p.id)
  ) into result
  from projects p
  where p.id = project_id::uuid;
  
  return result;
end;
$$; 


-- get_projects_with_metadata returns a json array containing project details and their relation metadata
create or replace function get_projects_with_metadata()
returns json[]
language plpgsql
security definer
as $$
declare
  result json[];
begin
  select array_agg(
    json_build_object(
      'project', row_to_json(p),
      'relation_metadata', json_build_object(
        'project_id', p.id,
        'total_tasks', (select count(*) from tasks t where t.project_id = p.id),
        'completed_tasks', (select count(*) from tasks t where t.project_id = p.id and t.checkbox_state = 'checked'),
        'total_pages', (select count(*) from pages pg where pg.project_id = p.id)
      )
    )
  ) into result
  from projects p;

  return result;
end;
$$;
