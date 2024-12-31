-- Set up authentication context before inserting data
SELECT set_authenticated_context();

-- Insert Projects
INSERT INTO projects (id, name, created_at, updated_at) 
VALUES 
    ('8a7d5f80-1234-4444-a111-111111111111', 'Personal Development', now(), now()),
    ('8a7d5f80-1234-4444-a222-222222222222', 'Work Tasks', now(), now()),
    ('8a7d5f80-1234-4444-a333-333333333333', 'Home Organization', now(), now()),
    ('8a7d5f80-1234-4444-a444-444444444444', 'Health & Fitness', now(), now());

-- Insert Contexts
INSERT INTO contexts (id, name, created_at, updated_at)
VALUES 
    ('9b8e6f90-5555-5555-b111-111111111111', 'Phone', now(), now()),
    ('9b8e6f90-5555-5555-b222-222222222222', 'Work', now(), now()),
    ('9b8e6f90-5555-5555-b333-333333333333', 'Computer', now(), now());

-- Insert Tasks
INSERT INTO tasks (id, name, status, due_date, project_id, context_id, created_at, updated_at)
VALUES
    -- Personal Development Tasks
    ('7c6d4e70-aaaa-aaaa-a111-111111111111', 'Read Clean Code book', 'todo', now() + interval '7 days', 
     '8a7d5f80-1234-4444-a111-111111111111', '9b8e6f90-5555-5555-b111-111111111111', now(), now()),
    
    -- Work Tasks
    ('7c6d4e70-aaaa-aaaa-a222-222222222222', 'Complete Project Presentation', 'in_progress', now() + interval '2 days',
     '8a7d5f80-1234-4444-a222-222222222222', '9b8e6f90-5555-5555-b222-222222222222', now(), now()),
    
    -- Home Organization Tasks
    ('7c6d4e70-aaaa-aaaa-a333-333333333333', 'Organize Home Office', 'todo', now() + interval '5 days',
     '8a7d5f80-1234-4444-a333-333333333333', '9b8e6f90-5555-5555-b111-111111111111', now(), now()),
    
    -- Health & Fitness Tasks
    ('7c6d4e70-aaaa-aaaa-a444-444444444444', 'Morning Run 5km', 'todo', now() + interval '1 day',
     '8a7d5f80-1234-4444-a444-444444444444', null, now(), now()),
     
    ('7c6d4e70-aaaa-aaaa-a555-555555555555', 'Weekly Meal Prep', 'done', now(),
     '8a7d5f80-1234-4444-a444-444444444444', '9b8e6f90-5555-5555-b111-111111111111', now(), now());