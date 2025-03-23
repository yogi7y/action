-- Project Status Enum based on the ProjectEntity in Dart
CREATE TYPE project_status AS ENUM (
    'not_started',
    'on_hold',
    'do_next',
    'in_progress',
    'done',
    'archive'
);

-- Create Projects table
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL CHECK (length(trim(name)) > 0),
    status project_status NOT NULL DEFAULT 'not_started',
    due_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by UUID NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id)
);

-- Create Contexts table
CREATE TABLE contexts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL CHECK (length(trim(name)) > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by UUID NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id)
);

-- Create update triggers for projects and contexts
-- We're reusing the update_updated_at_column function from the base schema
CREATE TRIGGER update_projects_updated_at
    BEFORE UPDATE ON projects
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contexts_updated_at
    BEFORE UPDATE ON contexts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- Projects with metadata function
CREATE OR REPLACE FUNCTION get_projects_with_metadata()
RETURNS json[]
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  result json[];
BEGIN
  SELECT array_agg(
    json_build_object(
      'project', row_to_json(p),
      'relation_metadata', json_build_object(
        'project_id', p.id,
        'total_tasks', (SELECT count(*) FROM tasks t WHERE t.project_id = p.id),
        'completed_tasks', (SELECT count(*) FROM tasks t WHERE t.project_id = p.id AND t.status = 'done')
      )
    )
  ) INTO result
  FROM projects p;

  RETURN result;
END;
$$;

-- Enable RLS
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE contexts ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Projects
CREATE POLICY "Users can view own projects" ON projects
    FOR SELECT USING (auth.uid() = created_by);

CREATE POLICY "Users can create projects" ON projects
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own projects" ON projects
    FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Users can delete own projects" ON projects
    FOR DELETE USING (auth.uid() = created_by);

-- RLS Policies for Contexts
CREATE POLICY "Users can view own contexts" ON contexts
    FOR SELECT USING (auth.uid() = created_by);

CREATE POLICY "Users can create contexts" ON contexts
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own contexts" ON contexts
    FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Users can delete own contexts" ON contexts
    FOR DELETE USING (auth.uid() = created_by);

-- Indexes for projects table
CREATE INDEX idx_projects_status ON projects(status);

-- Indexes for contexts table

-- Foreign key constraints on tasks
-- This adds the necessary relationship between tasks and projects/contexts
ALTER TABLE tasks 
    ADD CONSTRAINT fk_tasks_project_id 
    FOREIGN KEY (project_id) 
    REFERENCES projects(id) 
    ON DELETE SET NULL;

ALTER TABLE tasks 
    ADD CONSTRAINT fk_tasks_context_id 
    FOREIGN KEY (context_id) 
    REFERENCES contexts(id) 
    ON DELETE SET NULL;
