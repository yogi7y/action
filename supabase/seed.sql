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
    ('7c6d4e70-aaaa-aaaa-a112-111111111111', 'Complete Flutter Course', 'in_progress', now() + interval '14 days',
     '8a7d5f80-1234-4444-a111-111111111111', '9b8e6f90-5555-5555-b333-333333333333', now(), now()),
    ('7c6d4e70-aaaa-aaaa-a113-111111111111', 'Practice Algorithms', 'todo', now() + interval '10 days',
     '8a7d5f80-1234-4444-a111-111111111111', '9b8e6f90-5555-5555-b333-333333333333', now(), now()),
    
    -- Work Tasks
    ('7c6d4e70-aaaa-aaaa-a222-222222222222', 'Complete Project Presentation', 'in_progress', now() + interval '2 days',
     '8a7d5f80-1234-4444-a222-222222222222', '9b8e6f90-5555-5555-b222-222222222222', now(), now()),
    ('7c6d4e70-aaaa-aaaa-a223-222222222222', 'Code Review for Team', 'todo', now() + interval '1 day',
     '8a7d5f80-1234-4444-a222-222222222222', '9b8e6f90-5555-5555-b222-222222222222', now(), now()),
    ('7c6d4e70-aaaa-aaaa-a224-222222222222', 'Sprint Planning', 'todo', now() + interval '3 days',
     '8a7d5f80-1234-4444-a222-222222222222', '9b8e6f90-5555-5555-b222-222222222222', now(), now()),
    ('7c6d4e70-aaaa-aaaa-a225-222222222222', 'Update Documentation', 'in_progress', now() + interval '4 days',
     '8a7d5f80-1234-4444-a222-222222222222', '9b8e6f90-5555-5555-b333-333333333333', now(), now()),
    
    -- Home Organization Tasks
    ('7c6d4e70-aaaa-aaaa-a333-333333333333', 'Organize Home Office', 'todo', now() + interval '5 days',
     '8a7d5f80-1234-4444-a333-333333333333', '9b8e6f90-5555-5555-b111-111111111111', now(), now()),
    ('7c6d4e70-aaaa-aaaa-a334-333333333333', 'Clean Garage', 'todo', now() + interval '6 days',
     '8a7d5f80-1234-4444-a333-333333333333', null, now(), now()),
    ('7c6d4e70-aaaa-aaaa-a335-333333333333', 'Sort Digital Files', 'in_progress', now() + interval '2 days',
     '8a7d5f80-1234-4444-a333-333333333333', '9b8e6f90-5555-5555-b333-333333333333', now(), now()),
    
    -- Health & Fitness Tasks
    ('7c6d4e70-aaaa-aaaa-a444-444444444444', 'Morning Run 5km', 'todo', now() + interval '1 day',
     '8a7d5f80-1234-4444-a444-444444444444', null, now(), now()),
    ('7c6d4e70-aaaa-aaaa-a555-555555555555', 'Weekly Meal Prep', 'done', now(),
     '8a7d5f80-1234-4444-a444-444444444444', '9b8e6f90-5555-5555-b111-111111111111', now(), now()),
    ('7c6d4e70-aaaa-aaaa-a556-555555555555', 'Yoga Session', 'todo', now() + interval '2 days',
     '8a7d5f80-1234-4444-a444-444444444444', null, now(), now()),
    ('7c6d4e70-aaaa-aaaa-a557-555555555555', 'Track Macros', 'in_progress', now() + interval '1 day',
     '8a7d5f80-1234-4444-a444-444444444444', '9b8e6f90-5555-5555-b111-111111111111', now(), now());

-- Insert Pages
INSERT INTO pages (id, name, url, project_id, created_at, updated_at)
VALUES
    -- Personal Development Project Pages
    ('6b5c3d60-cccc-cccc-c111-111111111111', 'Clean Code Book Notes', 'https://reading-notes.com/clean-code', 
     '8a7d5f80-1234-4444-a111-111111111111', now(), now()),
    ('6b5c3d60-cccc-cccc-c112-111111111111', 'Flutter Course Materials', 'https://flutter-course.dev/materials', 
     '8a7d5f80-1234-4444-a111-111111111111', now(), now()),
    ('6b5c3d60-cccc-cccc-c113-111111111111', 'Algorithm Practice Problems', 'https://leetcode.com/problems', 
     '8a7d5f80-1234-4444-a111-111111111111', now(), now()),

    -- Work Tasks Project Pages
    ('6b5c3d60-cccc-cccc-c221-222222222222', 'Project Documentation', 'https://company-docs.com/project-x', 
     '8a7d5f80-1234-4444-a222-222222222222', now(), now()),
    ('6b5c3d60-cccc-cccc-c222-222222222222', 'Team Wiki', 'https://company-wiki.com/team-a', 
     '8a7d5f80-1234-4444-a222-222222222222', now(), now()),
    ('6b5c3d60-cccc-cccc-c223-222222222222', 'Sprint Board', 'https://jira.company.com/sprint-board', 
     '8a7d5f80-1234-4444-a222-222222222222', now(), now()),

    -- Health & Fitness Project Pages
    ('6b5c3d60-cccc-cccc-c441-444444444444', 'Workout Tracker', 'https://fitness-app.com/tracker', 
     '8a7d5f80-1234-4444-a444-444444444444', now(), now()),
    ('6b5c3d60-cccc-cccc-c442-444444444444', 'Meal Planning Guide', 'https://nutrition.com/meal-plans', 
     '8a7d5f80-1234-4444-a444-444444444444', now(), now()),
    ('6b5c3d60-cccc-cccc-c443-444444444444', 'Running Routes', 'https://maps.com/running-routes', 
     '8a7d5f80-1234-4444-a444-444444444444', now(), now());

-- Insert Checklist Items
INSERT INTO checklist_items (id, task_id, title, status, created_at, updated_at)
VALUES 
    -- For "Complete Project Presentation" task
    ('7d6e4f70-bbbb-bbbb-b111-111111111111', 
     '7c6d4e70-aaaa-aaaa-a222-222222222222',
     'Create intro slides', 
     'done', 
     now(), 
     now()),
    
    ('7d6e4f70-bbbb-bbbb-b222-222222222222', 
     '7c6d4e70-aaaa-aaaa-a222-222222222222',
     'Add project timeline', 
     'todo', 
     now(), 
     now()),
     
    ('7d6e4f70-bbbb-bbbb-b333-333333333333', 
     '7c6d4e70-aaaa-aaaa-a222-222222222222',
     'Prepare demo', 
     'todo', 
     now(), 
     now()),

    -- For "Organize Home Office" task
    ('7d6e4f70-bbbb-bbbb-b444-444444444444', 
     '7c6d4e70-aaaa-aaaa-a333-333333333333',
     'Sort documents', 
     'todo', 
     now(), 
     now()),
     
    ('7d6e4f70-bbbb-bbbb-b555-555555555555', 
     '7c6d4e70-aaaa-aaaa-a333-333333333333',
     'Organize cables', 
     'done', 
     now(), 
     now());