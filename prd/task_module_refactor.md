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
- Some class for sorting as well.

It'll probably be a good idea to club all of the above in a single data class which will be passed in to the notifier as a family parameter. `TaskListViewArgs`

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

# Tech Approach.

Suppose we have 4 views in loaded (in progress, todo, done, all) and we update a task from todo to done, then we'll need to firstly remove the task from the todo view and then go to other loaded tasks to check if it's supported in that view based on the filter set and if so, we either add/update it. So the algorithm will be something like:

1. TaskListViewData has the filter logic for a specific view.
2. Have a set of loaded TaskListViewData. An item a part of this if user have visited this in the curren app session.
3. User updates the status for a task from the todo view. Previous status was that the task is in todo state, and now user has updated it to done state.
4. Since we're at the todo view already, we'll update the state by taking in the current index to directly access the item.
5. Once the current view state is updated, we'll iterate through all the loaded task view states and check if the current view should add/update/remove this task based on the individual filters they have.

## Sample Data

**Tasks**

```dart
final tasks = <TaskEntity>[
    TaskEntity(id: '1', title: 'Task 1', status: 'todo', isOrganised: true),
    TaskEntity(id: '2', title: 'Task 2', status: 'in_progress', isOrganised: true),
    TaskEntity(id: '3', title: 'Task 3', status: 'done', isOrganised: true),
    TaskEntity(id: '4', title: 'Task 4', status: 'todo', isOrganised: false),
    TaskEntity(id: '5', title: 'Task 5', status: 'in_progress', isOrganised: false),
    TaskEntity(id: '6', title: 'Task 6', status: 'done', isOrganised: false),
    TaskEntity(id: '7', title: 'Task 7', status: 'todo', isOrganised: false),
    TaskEntity(id: '8', title: 'Task 8', status: 'in_progress', isOrganised: false),
    TaskEntity(id: '9', title: 'Task 9', status: 'done', isOrganised: false),
];
```

**Filters**
We've Todo, In Progress, Done, Unorganised filters.

Todo - tasks which are organised and in todo state.
will contain tasks = [1]. Not 4 and 7 because they are unorganised.

In Progress - tasks which are organised and in in progress state.
will contain tasks = [2]. Not 5 and 8 because they are unorganised.

Done - tasks which are organised and in done state.
will contain tasks = [3]. Not 6 and 9 because they are unorganised.

Unorganised - all tasks which are not organised.
will contain tasks = [4, 5, 6, 7, 8, 9].

All - all tasks irrespective of anything.
will contain tasks = [1, 2, 3, 4, 5, 6, 7, 8, 9].

Algorithm:

1. Check updated task state in current view based on the filter.
2. If it's supported, then call the addAndUpdate method which will internally decide whether to add or update the task.
3. Now iterate through all the loaded views.
4. For each view, check if the task is supported, if yes, call the addAndUpdate method.
5. If the task is not supported, then check if the task already exists in the view, if yes, then remove it.

Now that we've the sample data, let's suppose user is in the unorganised view and from there user makes task 6 as organised. Now it should move from unorganised to done as it's organised now and it's status is also done. So it'll be removed from unorganised, it'll be added to done, it'll also update it's state in the all view as it's already present there.

Now how this operations takes place is (assuming all the views are loaded):

1. We check the updated task state in the current view based on the filters. Since the current view is unorganised and the filter says only unorganised tasks should be present, so it'll be removed from unorganised.
2. Now we iterate through all the loaded views.
3. We first iterate over the todo view, check based on the filter if it's supported. In case of task 6, it's not supported because the status is not todo, but done, so we'll not add/update it.
4. Since it says not supported, we need to check if the task already exists in the view, if yes, then remove it. If it doesn't exist, then we don't need to do anything.
