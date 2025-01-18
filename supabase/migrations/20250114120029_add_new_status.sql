-- First drop the existing task_status enum type 
DROP TYPE task_status;

-- Create new task_status enum with detailed statuses
CREATE TYPE task_status AS ENUM (
    'todo', -- todo
    'do_next', -- todo
    'in_progress', -- in_progress
    'done', -- done
    'cancelled' -- done
);

-- Add computed columns for grouping
ALTER TABLE tasks 
    -- First drop the old status column but preserve the data
    ALTER COLUMN status TYPE TEXT;

-- Now recreate it as enum and add computed columns
ALTER TABLE tasks
    ALTER COLUMN status TYPE task_status USING status::task_status,
    ADD COLUMN is_todo BOOLEAN GENERATED ALWAYS AS (
        status IN ('todo', 'do_next')
    ) STORED,
    ADD COLUMN is_in_progress BOOLEAN GENERATED ALWAYS AS (
        status = 'in_progress'
    ) STORED,
    ADD COLUMN is_done BOOLEAN GENERATED ALWAYS AS (
        status IN ('done', 'cancelled')
    ) STORED;
