-- Set up authentication context before inserting data
SELECT set_authenticated_context();

-- Create sample tasks with different statuses and properties
INSERT INTO tasks (id, name, status, due_date, project_id, context_id)
VALUES
  -- Todo tasks
  ('bf517491-6a44-4b19-b5d4-1c611bafc463', 'Complete Flutter tutorial', 'todo', CURRENT_DATE + INTERVAL '3 days', NULL, NULL),
  ('a17d0909-0d64-4140-9d35-bc4e9cc29275', 'Buy groceries', 'todo', CURRENT_DATE + INTERVAL '1 day', NULL, NULL),
  ('b5e54ce7-5a73-4c8c-b189-b2ed37a40762', 'Fix kitchen sink', 'todo', CURRENT_DATE + INTERVAL '5 days', NULL, NULL),
  
  -- Do Next tasks
  ('d8fc9b79-9836-417e-98ca-4c1e4fa8b4f1', 'Plan weekend trip', 'do_next', CURRENT_DATE + INTERVAL '2 days', NULL, NULL),
  ('5d25d1f5-8955-43d4-8d7c-4c78ff2c79e9', 'Call plumber for quote', 'do_next', CURRENT_DATE + INTERVAL '1 day', NULL, NULL),
  
  -- In Progress tasks
  ('f2c11e9d-8f00-4b13-b487-5fadfc44b0e2', 'Remodel bathroom', 'in_progress', CURRENT_DATE + INTERVAL '14 days', NULL, NULL),
  ('37b0e053-4008-4733-88e7-fb1e11f28f87', 'Quarterly report', 'in_progress', CURRENT_DATE + INTERVAL '7 days', NULL, NULL),
  
  -- Done tasks  
  ('32c5b5fa-e87a-49a0-a52c-73d787a0968d', 'Setup development environment', 'done', CURRENT_DATE - INTERVAL '2 days', NULL, NULL),
  ('9c09be0f-a30a-4c36-aa39-c5a1a0810cf0', 'Update resume', 'done', CURRENT_DATE - INTERVAL '5 days', NULL, NULL),
  
  -- Discard tasks
  ('14e4e7a8-582b-474e-b34e-3a11ee039b2f', 'Research old technology', 'discard', CURRENT_DATE - INTERVAL '10 days', NULL, NULL),
  ('a5f89a47-6e22-4d23-a0fc-2a8d6c4c8585', 'Call old vendor', 'discard', NULL, NULL, NULL);

-- Create checklist items for some tasks
INSERT INTO checklist_items (task_id, title, status)
VALUES
  -- Checklist for "Remodel bathroom"
  ('f2c11e9d-8f00-4b13-b487-5fadfc44b0e2', 'Buy new tiles', 'todo'),
  ('f2c11e9d-8f00-4b13-b487-5fadfc44b0e2', 'Remove old fixtures', 'done'),
  ('f2c11e9d-8f00-4b13-b487-5fadfc44b0e2', 'Install new shower', 'todo'),
  
  -- Checklist for "Quarterly report"
  ('37b0e053-4008-4733-88e7-fb1e11f28f87', 'Gather Q3 metrics', 'done'),
  ('37b0e053-4008-4733-88e7-fb1e11f28f87', 'Create executive summary', 'todo'),
  ('37b0e053-4008-4733-88e7-fb1e11f28f87', 'Prepare slide deck', 'todo'),
  
  -- Checklist for "Complete Flutter tutorial"
  ('bf517491-6a44-4b19-b5d4-1c611bafc463', 'Set up Flutter environment', 'done'),
  ('bf517491-6a44-4b19-b5d4-1c611bafc463', 'Complete basic UI section', 'todo'),
  ('bf517491-6a44-4b19-b5d4-1c611bafc463', 'Learn state management', 'todo');
