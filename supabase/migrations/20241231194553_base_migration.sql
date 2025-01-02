-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create task status enum
CREATE TYPE task_status AS ENUM ('todo', 'in_progress', 'done');

-- Create checklist status enum
CREATE TYPE checklist_status AS ENUM ('todo', 'done');

-- Create Projects table
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by UUID NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id)
);

-- Create Contexts table
CREATE TABLE contexts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by UUID NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id)
);

-- Create Tasks table
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    status task_status NOT NULL DEFAULT 'todo',
    due_date DATE,
    project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
    context_id UUID REFERENCES contexts(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by UUID NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id)
);


-- Create checklist items table
CREATE TABLE checklist_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    status checklist_status NOT NULL DEFAULT 'todo',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by UUID NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id)
);

-- Function to check if task is organized
CREATE OR REPLACE FUNCTION is_task_organized(
    task_project_id UUID,
    task_status task_status
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN task_project_id IS NOT NULL OR task_status = 'done';
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Add generated columns
ALTER TABLE tasks ADD COLUMN is_organized BOOLEAN 
    GENERATED ALWAYS AS (is_task_organized(project_id, status)) STORED;

-- ALTER TABLE tasks ADD COLUMN is_in_inbox BOOLEAN 
--     GENERATED ALWAYS AS (
--         NOT is_task_organized(project_id, status) 
--         AND created_at > now() - interval '24 hours'
--     ) STORED;

-- Updated at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create update triggers for all tables
CREATE TRIGGER update_projects_updated_at
    BEFORE UPDATE ON projects
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contexts_updated_at
    BEFORE UPDATE ON contexts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at
    BEFORE UPDATE ON tasks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_checklist_items_updated_at
    BEFORE UPDATE ON checklist_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE contexts ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_items ENABLE ROW LEVEL SECURITY;

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

-- RLS Policies for Tasks
CREATE POLICY "Users can view own tasks" ON tasks
    FOR SELECT USING (auth.uid() = created_by);

CREATE POLICY "Users can create tasks" ON tasks
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own tasks" ON tasks
    FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Users can delete own tasks" ON tasks
    FOR DELETE USING (auth.uid() = created_by);

CREATE POLICY "Users can view own checklist items" ON checklist_items
    FOR SELECT USING (auth.uid() = created_by);

CREATE POLICY "Users can create checklist items" ON checklist_items
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own checklist items" ON checklist_items
    FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Users can delete own checklist items" ON checklist_items
    FOR DELETE USING (auth.uid() = created_by);