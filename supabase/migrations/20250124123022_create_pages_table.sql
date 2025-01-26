-- Create Pages table
CREATE TABLE pages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL CHECK (length(trim(name)) > 0),
    url TEXT NOT NULL,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by UUID NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id)
);

-- Create update trigger for pages
CREATE TRIGGER update_pages_updated_at
    BEFORE UPDATE ON pages
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE pages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Pages
CREATE POLICY "Users can view own pages" ON pages
    FOR SELECT USING (auth.uid() = created_by);

CREATE POLICY "Users can create pages" ON pages
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own pages" ON pages
    FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Users can delete own pages" ON pages
    FOR DELETE USING (auth.uid() = created_by);
