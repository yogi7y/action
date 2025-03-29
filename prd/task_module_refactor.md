Have a composable task module that can be easily plugged into to different views.
Some views example:

- A full screen task list.
- A full screen task list with filter chips and horizontal swipeable pages.
- A normal list within a sub view of a screen. (A small section in a screen)

We're just providing composable widgets and the client will have to compose all of them to make the UI work.
For eg, we've provided `TaskListView` which lists a single list of tasks, and the client will be responsible of either using it standalone, wrap it inside a TabBarView, PageView etc. based on the use case.

### Real Use cases:

- A single non-paginated list view to show inbox tasks.
- A single paginated list view to show unorganised tasks.

Functionalities:

- CRUD operations on task.
- Navigate to task detail.
- Fetch tasks based on the passed in filter.
- Update throughout in memory. (Update the task locally in all the loaded views)
- Don't make network calls if the tasks for a given view are already loaded, even though if that was on a different screen.

# Task List

## Usage

- Client should be able to call `TaskListView` and render a list.
- Client should be able to tell if it's a paginated list or not.

## Dependencies

- TaskFilter - will contain the query to fetch the tasks.
- PaginationStrategy - Pass in NoPagination if pagination is not required and all the items should be returned.

## Fetch tasks

Fetch task from the passed in filter.

## Add task

- Have a separate provider to maintain the state for add task.
- All the providers will take in the same arg as family parameter so that they are in sync with the tasksNotifier provider.
- Will have a stateProvider to control the visibility.
- A notifier provider to maintain the state of passed in values. Probably state to be a type of TaskEntity.
- The task field should be inside the list view.
- Should probably be auto disposed.

### Update task and all the in memory states.

Class responsible for holding all the task state within the app. It'll take in filter as a family parameter. After any change it should go through all the loaded task views and then update the state if required.

**Animated ListView Keys**
1-1 mapping between a task view and its notifier(family)
So the family should have a property to hold the animated list view key.

# Pagination

An abstract Pagination class which will have different implementation like OffsetPagination, CursorPagination, NoPagination etc.

# Filter

- State can be a list of String. Don't really think we need the List<Filter> implementation here.
- Expose an onChanged callback to tell the client the current index.
