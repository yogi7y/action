-- First add the columns as nullable
ALTER TABLE tasks ADD COLUMN user_id UUID REFERENCES auth.users(id);
ALTER TABLE projects ADD COLUMN user_id UUID REFERENCES auth.users(id);
ALTER TABLE contexts ADD COLUMN user_id UUID REFERENCES auth.users(id);

-- Get the first admin user or create a default one for existing data
-- You might want to adjust this based on your needs
DO $$ 
DECLARE
    default_user_id UUID;
BEGIN
    -- Get the first user from auth.users
    SELECT id INTO default_user_id FROM auth.users LIMIT 1;
    
    -- Update existing records with the default user
    UPDATE tasks SET user_id = default_user_id WHERE user_id IS NULL;
    UPDATE projects SET user_id = default_user_id WHERE user_id IS NULL;
    UPDATE contexts SET user_id = default_user_id WHERE user_id IS NULL;
END $$;

-- Now make the columns NOT NULL
ALTER TABLE tasks ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE projects ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE contexts ALTER COLUMN user_id SET NOT NULL;

-- Enable RLS and create policies
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE contexts ENABLE ROW LEVEL SECURITY;

-- Create policies for tasks table
CREATE POLICY "Users can view their own tasks" 
ON tasks FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own tasks" 
ON tasks FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own tasks" 
ON tasks FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own tasks" 
ON tasks FOR DELETE 
USING (auth.uid() = user_id);

-- Create policies for projects table
CREATE POLICY "Users can view their own projects" 
ON projects FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own projects" 
ON projects FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own projects" 
ON projects FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own projects" 
ON projects FOR DELETE 
USING (auth.uid() = user_id);

-- Create policies for contexts table
CREATE POLICY "Users can view their own contexts" 
ON contexts FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own contexts" 
ON contexts FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own contexts" 
ON contexts FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own contexts" 
ON contexts FOR DELETE 
USING (auth.uid() = user_id);