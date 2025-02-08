# Filter support.

## Requirements

- [ ] Introducing new filters on the fly should be easy by just composing existing filters.
- [ ] At later stages, we should be able to give user the ability to create their own filters.

## Thinking

- We can probably have a base class `Filter` and then some combination operator like `AndFilter` and `OrFilter`
  and we should be able to keep composing those to create complex filter conditions.

## Filter examples

- Return all tasks that are organized and in progress.
  Tasks = Organized + In Progress

- Return all tasks.
  Tasks = All
- Return all tasks that are not organized.
  Tasks = Not(Organized)

- Return all tasks that are in inbox (not organized and created in last 24 hours).
  Tasks = Not(Organized) + CreatedAt > Now - 24 hours

- Return all tasks that are due today.
  Tasks = DueDate is Today

- Return all tasks which are cold.
  Tasks = Status is Cold

- Return all tasks for a given project/context and are of specific status.
  Tasks = ProjectId is X + Status is Y
