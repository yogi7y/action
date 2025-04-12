Problem:
We can have multiple loaded views on mobile in memory. A loaded view is basically any view that the user has opened in the current session. Whenever a user updates a task, there can be several things, for eg, a task can be removed from the current view, or it can be added, or it can be updated. We'll need to check this for all the views.
One way is to refresh the state by making an API call, but this feels expensive as updating a task is a very frequent operation and calling the API for every operation is not scalable.

Solution:
We'll need to mimic all the filters locally and then update the state locally rather than making API calls. Local filters are already implemented InMemoryTaskFilterOperations.

We've already implemented and solved this in the tasksProvider but current it's doing a lot of things hence we want to extract this out to it's separate module.
