-- Set up authentication context before inserting data
SELECT set_authenticated_context();

-- Create sample projects with different statuses
INSERT INTO projects (id, name, status, due_date, created_at, updated_at)
VALUES
  -- Not Started projects
  ('fd0bec32-d47e-4c62-aef2-637415eb3221', 'Personal Development', 'not_started', CURRENT_DATE + INTERVAL '30 days 10 hours', now() - INTERVAL '15 days 5 hours 23 minutes', now() - INTERVAL '2 days 1 hour 15 minutes'),
  
  -- In Progress projects
  ('35a8eb06-c0bd-4aa4-83a8-8e08d40d8b83', 'Home Improvement', 'in_progress', CURRENT_DATE + INTERVAL '60 days 14 hours 30 minutes', now() - INTERVAL '30 days 8 hours 42 minutes', now() - INTERVAL '6 hours 12 minutes'),
  ('98b82cca-26ab-4732-8ea8-11fe87b2c9b7', 'Work Projects', 'in_progress', CURRENT_DATE + INTERVAL '21 days 9 hours', now() - INTERVAL '45 days 2 hours 10 minutes', now() - INTERVAL '1 day 3 hours 8 minutes'),
  
  -- Do Next projects
  ('6724d21d-5666-4b85-9a66-a2a737ba38f9', 'Summer Vacation Plans', 'do_next', CURRENT_DATE + INTERVAL '90 days 12 hours 15 minutes', now() - INTERVAL '7 days 14 hours 55 minutes', now() - INTERVAL '7 days 14 hours 55 minutes'),
  
  -- On Hold projects
  ('f5f96b68-a5d5-46e4-88e4-0e25b5ba5957', 'Learning Spanish', 'on_hold', CURRENT_DATE + INTERVAL '180 days 8 hours 45 minutes', now() - INTERVAL '60 days 11 hours 31 minutes', now() - INTERVAL '10 days 4 hours 17 minutes'),
  
  -- Done projects
  ('df94cee7-c236-4189-a776-d383510299a5', 'Portfolio Website', 'done', CURRENT_DATE - INTERVAL '10 days 5 hours', now() - INTERVAL '90 days 9 hours 12 minutes', now() - INTERVAL '15 days 2 hours 45 minutes'),
  
  -- Archive projects
  ('bd9a0526-7eed-478a-85e5-fcc904d8c4c7', 'Archived Project', 'archive', NULL, now() - INTERVAL '180 days 3 hours 27 minutes', now() - INTERVAL '90 days 6 hours 14 minutes');

-- Create sample contexts
INSERT INTO contexts (id, name, created_at, updated_at)
VALUES
  ('c9d0a645-9df4-4cf0-bbb5-27f5b5431887', 'Home', now() - INTERVAL '100 days 7 hours 22 minutes', now() - INTERVAL '100 days 7 hours 22 minutes'),
  ('21b8b850-f875-4d95-a700-b4a7ddcf0712', 'Office', now() - INTERVAL '100 days 7 hours 25 minutes', now() - INTERVAL '20 days 5 hours 48 minutes'),
  ('d86fbb1a-8b67-4269-a539-8e2451fc91e7', 'Errands', now() - INTERVAL '95 days 14 hours 30 minutes', now() - INTERVAL '95 days 14 hours 30 minutes'),
  ('9b3afc45-5149-4e2d-ba5c-acdb88b40c36', 'Phone Calls', now() - INTERVAL '87 days 11 hours 54 minutes', now() - INTERVAL '15 days 9 hours 33 minutes'),
  ('71a85203-5cca-45aa-a4d7-1c2f227f41d8', 'Online', now() - INTERVAL '85 days 10 hours 17 minutes', now() - INTERVAL '12 days 5 hours 19 minutes');

-- Create sample tasks with different statuses and properties - now linked to projects and contexts
INSERT INTO tasks (id, name, status, due_date, project_id, context_id, created_at, updated_at)
VALUES
  -- Todo tasks
  ('bf517491-6a44-4b19-b5d4-1c611bafc463', 'Complete Flutter tutorial', 'todo', CURRENT_DATE + INTERVAL '3 days 16 hours 45 minutes', 'fd0bec32-d47e-4c62-aef2-637415eb3221', '71a85203-5cca-45aa-a4d7-1c2f227f41d8', now() - INTERVAL '10 days 3 hours 12 minutes', now() - INTERVAL '2 days 1 hour 7 minutes'),
  ('a17d0909-0d64-4140-9d35-bc4e9cc29275', 'Buy groceries', 'todo', CURRENT_DATE + INTERVAL '1 day 10 hours 30 minutes', NULL, 'd86fbb1a-8b67-4269-a539-8e2451fc91e7', now() - INTERVAL '1 day 8 hours 42 minutes', now() - INTERVAL '1 day 8 hours 42 minutes'),
  ('b5e54ce7-5a73-4c8c-b189-b2ed37a40762', 'Fix kitchen sink', 'todo', CURRENT_DATE + INTERVAL '5 days 14 hours', '35a8eb06-c0bd-4aa4-83a8-8e08d40d8b83', 'c9d0a645-9df4-4cf0-bbb5-27f5b5431887', now() - INTERVAL '5 days 7 hours 18 minutes', now() - INTERVAL '2 days 11 hours 39 minutes'),
  
  -- Do Next tasks
  ('d8fc9b79-9836-417e-98ca-4c1e4fa8b4f1', 'Research destinations', 'do_next', CURRENT_DATE + INTERVAL '2 days 9 hours 15 minutes', '6724d21d-5666-4b85-9a66-a2a737ba38f9', 'c9d0a645-9df4-4cf0-bbb5-27f5b5431887', now() - INTERVAL '7 days 4 hours 55 minutes', now() - INTERVAL '3 days 9 hours 27 minutes'),
  ('5d25d1f5-8955-43d4-8d7c-4c78ff2c79e9', 'Call plumber for quote', 'do_next', CURRENT_DATE + INTERVAL '1 day 13 hours 45 minutes', '35a8eb06-c0bd-4aa4-83a8-8e08d40d8b83', '9b3afc45-5149-4e2d-ba5c-acdb88b40c36', now() - INTERVAL '3 days 14 hours 22 minutes', now() - INTERVAL '3 days 14 hours 22 minutes'),
  
  -- In Progress tasks
  ('f2c11e9d-8f00-4b13-b487-5fadfc44b0e2', 'Remodel bathroom', 'in_progress', CURRENT_DATE + INTERVAL '14 days 11 hours 30 minutes', '35a8eb06-c0bd-4aa4-83a8-8e08d40d8b83', 'c9d0a645-9df4-4cf0-bbb5-27f5b5431887', now() - INTERVAL '20 days 6 hours 52 minutes', now() - INTERVAL '3 hours 27 minutes'),
  ('37b0e053-4008-4733-88e7-fb1e11f28f87', 'Quarterly report', 'in_progress', CURRENT_DATE + INTERVAL '7 days 17 hours', '98b82cca-26ab-4732-8ea8-11fe87b2c9b7', '21b8b850-f875-4d95-a700-b4a7ddcf0712', now() - INTERVAL '15 days 15 hours 38 minutes', now() - INTERVAL '6 hours 14 minutes'),
  
  -- Done tasks  
  ('32c5b5fa-e87a-49a0-a52c-73d787a0968d', 'Setup development environment', 'done', CURRENT_DATE - INTERVAL '2 days 6 hours 20 minutes', 'fd0bec32-d47e-4c62-aef2-637415eb3221', '21b8b850-f875-4d95-a700-b4a7ddcf0712', now() - INTERVAL '12 days 11 hours 6 minutes', now() - INTERVAL '1 day 12 hours 33 minutes'),
  ('9c09be0f-a30a-4c36-aa39-c5a1a0810cf0', 'Update resume', 'done', CURRENT_DATE - INTERVAL '5 days 15 hours 10 minutes', 'df94cee7-c236-4189-a776-d383510299a5', '71a85203-5cca-45aa-a4d7-1c2f227f41d8', now() - INTERVAL '30 days 5 hours 47 minutes', now() - INTERVAL '10 days 8 hours 12 minutes'),
  
  -- Discard tasks
  ('14e4e7a8-582b-474e-b34e-3a11ee039b2f', 'Research old technology', 'discard', CURRENT_DATE - INTERVAL '10 days 8 hours 45 minutes', '98b82cca-26ab-4732-8ea8-11fe87b2c9b7', '21b8b850-f875-4d95-a700-b4a7ddcf0712', now() - INTERVAL '35 days 3 hours 42 minutes', now() - INTERVAL '15 days 9 hours 55 minutes'),
  ('a5f89a47-6e22-4d23-a0fc-2a8d6c4c8585', 'Call old vendor', 'discard', NULL, 'bd9a0526-7eed-478a-85e5-fcc904d8c4c7', NULL, now() - INTERVAL '100 days 13 hours 7 minutes', now() - INTERVAL '90 days 4 hours 31 minutes'),
  
  -- Additional tasks for projects
  ('de7a910f-728c-45ed-8b13-21ba8d7d7e74', 'Learn React basics', 'todo', CURRENT_DATE + INTERVAL '10 days 13 hours 30 minutes', 'fd0bec32-d47e-4c62-aef2-637415eb3221', '71a85203-5cca-45aa-a4d7-1c2f227f41d8', now() - INTERVAL '8 days 9 hours 39 minutes', now() - INTERVAL '8 days 9 hours 39 minutes'),
  ('79e0a7f8-9e2a-4958-b409-91ca9b39d3dc', 'Paint living room', 'in_progress', CURRENT_DATE + INTERVAL '4 days 9 hours 45 minutes', '35a8eb06-c0bd-4aa4-83a8-8e08d40d8b83', 'c9d0a645-9df4-4cf0-bbb5-27f5b5431887', now() - INTERVAL '15 days 7 hours 25 minutes', now() - INTERVAL '4 hours 55 minutes'),
  ('1a9b30f5-5a43-4f87-9a7a-8142f33f8d60', 'Book flights', 'todo', CURRENT_DATE + INTERVAL '7 days 8 hours 15 minutes', '6724d21d-5666-4b85-9a66-a2a737ba38f9', '71a85203-5cca-45aa-a4d7-1c2f227f41d8', now() - INTERVAL '6 days 10 hours 13 minutes', now() - INTERVAL '6 days 10 hours 13 minutes'),
  ('c8e3a9fc-c67d-4a1b-a554-58ff4bcd994d', 'Complete Spanish lesson 1', 'done', CURRENT_DATE - INTERVAL '15 days 11 hours 30 minutes', 'f5f96b68-a5d5-46e4-88e4-0e25b5ba5957', '71a85203-5cca-45aa-a4d7-1c2f227f41d8', now() - INTERVAL '30 days 12 hours 44 minutes', now() - INTERVAL '20 days 1 hour 15 minutes');

-- Create checklist items for some tasks
INSERT INTO checklist_items (task_id, title, status, created_at, updated_at)
VALUES
  -- Checklist for "Remodel bathroom"
  ('f2c11e9d-8f00-4b13-b487-5fadfc44b0e2', 'Buy new tiles', 'todo', now() - INTERVAL '20 days 5 hours 15 minutes', now() - INTERVAL '20 days 5 hours 15 minutes'),
  ('f2c11e9d-8f00-4b13-b487-5fadfc44b0e2', 'Remove old fixtures', 'done', now() - INTERVAL '20 days 5 hours 15 minutes', now() - INTERVAL '10 days 7 hours 38 minutes'),
  ('f2c11e9d-8f00-4b13-b487-5fadfc44b0e2', 'Install new shower', 'todo', now() - INTERVAL '20 days 5 hours 16 minutes', now() - INTERVAL '20 days 5 hours 16 minutes'),
  
  -- Checklist for "Quarterly report"
  ('37b0e053-4008-4733-88e7-fb1e11f28f87', 'Gather Q3 metrics', 'done', now() - INTERVAL '15 days 14 hours 55 minutes', now() - INTERVAL '10 days 11 hours 42 minutes'),
  ('37b0e053-4008-4733-88e7-fb1e11f28f87', 'Create executive summary', 'todo', now() - INTERVAL '15 days 14 hours 55 minutes', now() - INTERVAL '15 days 14 hours 55 minutes'),
  ('37b0e053-4008-4733-88e7-fb1e11f28f87', 'Prepare slide deck', 'todo', now() - INTERVAL '15 days 14 hours 56 minutes', now() - INTERVAL '15 days 14 hours 56 minutes'),
  
  -- Checklist for "Complete Flutter tutorial"
  ('bf517491-6a44-4b19-b5d4-1c611bafc463', 'Set up Flutter environment', 'done', now() - INTERVAL '10 days 3 hours 12 minutes', now() - INTERVAL '9 days 5 hours 47 minutes'),
  ('bf517491-6a44-4b19-b5d4-1c611bafc463', 'Complete basic UI section', 'todo', now() - INTERVAL '10 days 3 hours 12 minutes', now() - INTERVAL '10 days 3 hours 12 minutes'),
  ('bf517491-6a44-4b19-b5d4-1c611bafc463', 'Learn state management', 'todo', now() - INTERVAL '10 days 3 hours 13 minutes', now() - INTERVAL '10 days 3 hours 13 minutes'),
  
  -- Checklist for "Book flights"
  ('1a9b30f5-5a43-4f87-9a7a-8142f33f8d60', 'Compare prices', 'todo', now() - INTERVAL '6 days 10 hours 13 minutes', now() - INTERVAL '6 days 10 hours 13 minutes'),
  ('1a9b30f5-5a43-4f87-9a7a-8142f33f8d60', 'Check baggage allowance', 'todo', now() - INTERVAL '6 days 10 hours 14 minutes', now() - INTERVAL '6 days 10 hours 14 minutes'),
  ('1a9b30f5-5a43-4f87-9a7a-8142f33f8d60', 'Look for travel insurance', 'todo', now() - INTERVAL '6 days 10 hours 14 minutes', now() - INTERVAL '6 days 10 hours 14 minutes'),
  
  -- Checklist for "Paint living room"
  ('79e0a7f8-9e2a-4958-b409-91ca9b39d3dc', 'Choose color scheme', 'done', now() - INTERVAL '15 days 7 hours 25 minutes', now() - INTERVAL '14 days 2 hours 10 minutes'),
  ('79e0a7f8-9e2a-4958-b409-91ca9b39d3dc', 'Buy paint supplies', 'done', now() - INTERVAL '15 days 7 hours 26 minutes', now() - INTERVAL '8 days 9 hours 34 minutes'),
  ('79e0a7f8-9e2a-4958-b409-91ca9b39d3dc', 'Prep walls', 'todo', now() - INTERVAL '15 days 7 hours 27 minutes', now() - INTERVAL '15 days 7 hours 27 minutes'),
  ('79e0a7f8-9e2a-4958-b409-91ca9b39d3dc', 'Apply primer', 'todo', now() - INTERVAL '15 days 7 hours 28 minutes', now() - INTERVAL '15 days 7 hours 28 minutes');
