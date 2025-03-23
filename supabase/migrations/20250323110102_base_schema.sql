-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create task status enum
CREATE TYPE task_status AS ENUM (
    'todo',
    'do_next',
    'in_progress',
    'done',
    'discard'
);

-- Create checklist status enum (for checklist items)
CREATE TYPE checklist_status AS ENUM ('todo', 'done');

-- Tasks table with all needed fields matching TaskEntity
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL CHECK (length(trim(name)) > 0),
    status task_status NOT NULL DEFAULT 'todo',
    due_date DATE,
    project_id UUID, -- We'll add the foreign key later if needed
    context_id UUID, -- We'll add the foreign key later if needed
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by UUID NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id)
);

-- Create checklist items table (related to tasks)
CREATE TABLE checklist_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE, -- what does delete cascade mean?
    title TEXT NOT NULL CHECK (length(trim(title)) > 0),
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
    RETURN task_project_id IS NOT NULL OR task_status IN ('done', 'discard');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Add generated column for is_organized
ALTER TABLE tasks ADD COLUMN is_organized BOOLEAN 
    GENERATED ALWAYS AS (is_task_organized(project_id, status)) STORED;

-- Updated at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create update triggers for tasks and checklist items
CREATE TRIGGER update_tasks_updated_at
    BEFORE UPDATE ON tasks
    FOR EACH ROW -- why do we have for each row? does it mean it'll iterate over all rows each time?
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_checklist_items_updated_at
    BEFORE UPDATE ON checklist_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_items ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Tasks
CREATE POLICY "Users can view own tasks" ON tasks
    FOR SELECT USING (auth.uid() = created_by);

CREATE POLICY "Users can create tasks" ON tasks
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own tasks" ON tasks
    FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Users can delete own tasks" ON tasks
    FOR DELETE USING (auth.uid() = created_by);

-- RLS Policies for Checklist Items
CREATE POLICY "Users can view own checklist items" ON checklist_items
    FOR SELECT USING (auth.uid() = created_by);

CREATE POLICY "Users can create checklist items" ON checklist_items
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own checklist items" ON checklist_items
    FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Users can delete own checklist items" ON checklist_items
    FOR DELETE USING (auth.uid() = created_by);

-- Add indexes for columns frequently used in WHERE clauses
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_tasks_context_id ON tasks(context_id);
CREATE INDEX idx_tasks_created_by ON tasks(created_by);
CREATE INDEX idx_tasks_is_organized ON tasks(is_organized);
CREATE INDEX idx_checklist_items_task_id ON checklist_items(task_id);

-- User management for local development
CREATE OR REPLACE FUNCTION public.create_user(
    email text,
    password text
) RETURNS uuid AS $$
DECLARE
    user_id uuid;
    encrypted_pw text;
BEGIN
    user_id := gen_random_uuid();
    encrypted_pw := crypt(password, gen_salt('bf'));

    INSERT INTO auth.users (
        instance_id, id, aud, role, email, encrypted_password, 
        email_confirmed_at, recovery_sent_at, last_sign_in_at,
        raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
        confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
        '00000000-0000-0000-0000-000000000000',
        user_id,
        'authenticated',
        'authenticated',
        email,
        encrypted_pw,
        now(),
        now(),
        now(),
        '{"provider":"email","providers":["email"]}',
        '{}',
        now(),
        now(),
        '',
        '',
        '',
        ''
    );

    -- Create identity
    INSERT INTO auth.identities (
        id, user_id, identity_data, provider, provider_id,
        last_sign_in_at, created_at, updated_at
    ) VALUES (
        gen_random_uuid(),
        user_id,
        format('{"sub":"%s","email":"%s"}', user_id::text, email)::jsonb,
        'email',
        email,
        now(),
        now(),
        now()
    );

    RETURN user_id;
END;
$$ LANGUAGE plpgsql;

-- Create function to set authentication context for seeding
CREATE OR REPLACE FUNCTION set_authenticated_context() RETURNS void AS $$
DECLARE
    created_user_id uuid;
BEGIN
    created_user_id := (SELECT id FROM auth.users WHERE email = 'yogeshparwani99.yp@gmail.com' LIMIT 1);
    
    IF created_user_id IS NULL THEN
        created_user_id := public.create_user('yogeshparwani99.yp@gmail.com', 'localtest');
    END IF;

    PERFORM set_config('request.jwt.claim.sub', created_user_id::text, true);
    PERFORM set_config('request.jwt.claims', 
        format('{"sub": "%s", "role": "authenticated"}', created_user_id)::jsonb::text,
        true);
END;
$$ LANGUAGE plpgsql;
