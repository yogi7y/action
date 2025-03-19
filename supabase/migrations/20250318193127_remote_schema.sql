drop trigger if exists "update_pages_updated_at" on "public"."pages";

drop policy "Users can create pages" on "public"."pages";

drop policy "Users can delete own pages" on "public"."pages";

drop policy "Users can update own pages" on "public"."pages";

drop policy "Users can view own pages" on "public"."pages";

revoke delete on table "public"."pages" from "anon";

revoke insert on table "public"."pages" from "anon";

revoke references on table "public"."pages" from "anon";

revoke select on table "public"."pages" from "anon";

revoke trigger on table "public"."pages" from "anon";

revoke truncate on table "public"."pages" from "anon";

revoke update on table "public"."pages" from "anon";

revoke delete on table "public"."pages" from "authenticated";

revoke insert on table "public"."pages" from "authenticated";

revoke references on table "public"."pages" from "authenticated";

revoke select on table "public"."pages" from "authenticated";

revoke trigger on table "public"."pages" from "authenticated";

revoke truncate on table "public"."pages" from "authenticated";

revoke update on table "public"."pages" from "authenticated";

revoke delete on table "public"."pages" from "service_role";

revoke insert on table "public"."pages" from "service_role";

revoke references on table "public"."pages" from "service_role";

revoke select on table "public"."pages" from "service_role";

revoke trigger on table "public"."pages" from "service_role";

revoke truncate on table "public"."pages" from "service_role";

revoke update on table "public"."pages" from "service_role";

alter table "public"."checklist_items" drop constraint "checklist_items_title_check";

alter table "public"."contexts" drop constraint "contexts_name_check";

alter table "public"."pages" drop constraint "pages_created_by_fkey";

alter table "public"."pages" drop constraint "pages_name_check";

alter table "public"."pages" drop constraint "pages_project_id_fkey";

alter table "public"."projects" drop constraint "projects_name_check";

alter table "public"."tasks" drop constraint "tasks_name_check";

drop function if exists "public"."get_project_relation_metadata"(project_id text);

drop function if exists "public"."get_projects_with_metadata"();

alter table "public"."pages" drop constraint "pages_pkey";

drop index if exists "public"."pages_pkey";

drop table "public"."pages";

alter table "public"."tasks" alter column "status" drop default;

alter type "public"."task_status" rename to "task_status__old_version_to_be_dropped";

create type "public"."task_status" as enum ('todo', 'in_progress', 'done');

alter table "public"."tasks" alter column status type "public"."task_status" using status::text::"public"."task_status";

alter table "public"."tasks" alter column "status" set default 'todo'::task_status;

drop type "public"."task_status__old_version_to_be_dropped";

alter table "public"."projects" drop column "checkbox_state";

alter table "public"."projects" drop column "status";

alter table "public"."tasks" drop column "checkbox_state";

drop type "public"."checkbox_state";

drop type "public"."project_status";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_task_organized(task_project_id uuid, task_status task_status)
 RETURNS boolean
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
BEGIN
    RETURN task_project_id IS NOT NULL OR task_status = 'done';
END;
$function$
;


