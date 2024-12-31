-- First, let's add the generated columns
ALTER TABLE tasks 
ADD COLUMN is_organized BOOLEAN GENERATED ALWAYS AS (
    -- A task is organized if it has a project_id OR status = 'done'
    project_id IS NOT NULL OR status = 'done'
) STORED;

-- For inbox status, we'll need a function to handle the date comparison
CREATE OR REPLACE FUNCTION is_task_in_inbox(
    is_organized boolean,
    created_at timestamptz
) RETURNS boolean AS $$
BEGIN
    RETURN NOT is_organized AND 
           created_at > (CURRENT_TIMESTAMP - interval '24 hours');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Add the is_in_inbox computed column
ALTER TABLE tasks
ADD COLUMN is_in_inbox BOOLEAN GENERATED ALWAYS AS (
    is_task_in_inbox(is_organized, created_at)
) STORED;

-- Create an index to improve query performance
CREATE INDEX idx_tasks_organization ON tasks(is_organized, is_in_inbox);

-- Update the RLS policies to include these new fields
CREATE POLICY "Users can view organization status of their tasks" 
ON tasks FOR SELECT 
USING (auth.uid() = user_id);