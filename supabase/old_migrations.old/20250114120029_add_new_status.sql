-- 1. First remove the function dependencies
ALTER TABLE tasks DROP COLUMN is_organized;
DROP FUNCTION IF EXISTS is_task_organized;

-- 2. Create new types we'll need
CREATE TYPE checkbox_state AS ENUM (
    'unchecked',
    'intermediate',
    'checked'
);

CREATE TYPE new_task_status AS ENUM (
    'todo',      
    'do_next',   
    'in_progress',
    'done',      
    'discard'    
);

CREATE TYPE project_status AS ENUM (
    'not_started',
    'on_hold',
    'do_next',
    'in_progress',
    'done',
    'archive'
);

-- 3. Remove constraints from status column
ALTER TABLE tasks 
    ALTER COLUMN status DROP DEFAULT,
    ALTER COLUMN status DROP NOT NULL;

-- 4. Convert to text temporarily to break enum dependency
ALTER TABLE tasks 
    ALTER COLUMN status TYPE text USING status::text;

-- 5. Now we can safely drop the enum
DROP TYPE task_status;
ALTER TYPE new_task_status RENAME TO task_status;

-- 6. Convert back to new enum and restore constraints
ALTER TABLE tasks
    ALTER COLUMN status TYPE task_status USING 
        CASE 
            WHEN status = 'todo' THEN 'todo'::task_status
            WHEN status = 'in_progress' THEN 'in_progress'::task_status
            WHEN status = 'done' THEN 'done'::task_status
            ELSE 'todo'::task_status
        END,
    ALTER COLUMN status SET NOT NULL,
    ALTER COLUMN status SET DEFAULT 'todo'::task_status;

-- 7. Add checkbox state to tasks
ALTER TABLE tasks
    ADD COLUMN checkbox_state checkbox_state 
    GENERATED ALWAYS AS (
        CASE 
            WHEN status IN ('todo', 'do_next') THEN 'unchecked'::checkbox_state
            WHEN status = 'in_progress' THEN 'intermediate'::checkbox_state
            WHEN status IN ('done', 'discard') THEN 'checked'::checkbox_state
        END
    ) STORED;

-- 8. Create new organized function with updated logic
CREATE OR REPLACE FUNCTION is_task_organized(
    task_project_id UUID,
    task_status task_status
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN task_project_id IS NOT NULL OR task_status IN ('done', 'discard');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- 9. Re-add is_organized column
ALTER TABLE tasks 
    ADD COLUMN is_organized BOOLEAN 
    GENERATED ALWAYS AS (is_task_organized(project_id, status)) STORED;

-- 10. Add status and checkbox_state to projects
ALTER TABLE projects
    ADD COLUMN status project_status NOT NULL DEFAULT 'not_started',
    ADD COLUMN checkbox_state checkbox_state 
    GENERATED ALWAYS AS (
        CASE 
            WHEN status IN ('not_started', 'do_next', 'on_hold') THEN 'unchecked'::checkbox_state
            WHEN status = 'in_progress' THEN 'intermediate'::checkbox_state
            WHEN status IN ('done', 'archive') THEN 'checked'::checkbox_state
        END
    ) STORED;