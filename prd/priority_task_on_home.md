# Priority Tasks on Home Screen (Action Center)

A compact, tabbed interface on the home screen to help users focus on their most important tasks. This feature enables users to quickly access tasks that require immediate attention, encouraging task completion and effective prioritization.

## Approach & Requirements

### Overview

- Implement a compact tabs UI pattern to display three key priority views: In Progress, Do Next, and Due Soon
- Each tab should display its respective tasks in a clean, scannable list
- Tabs should use minimal vertical space while providing clear visual separation between task categories
- The component should be positioned prominently on the home screen

### UI Components

- Horizontal tab bar with three fixed tabs
- Active tab should be visually distinct (e.g., underlined)
- Task count badge for each tab (e.g., "In Progress (3)")
- Default selected tab should be "In Progress" on initial load
- Tabs should remain accessible when scrolling through longer task lists (sticky header)

### Task Views

- Show 5 tasks by default.

1. **In Progress**

   - Shows all tasks with TaskStatus.inProgress
   - Sort order: Most recently updated first
   - Tooltip: "Finish what you've started before taking on new work"
   - Display up to 5 tasks, with a "See All" option if more exist

2. **Do Next**

   - Shows all tasks with TaskStatus.doNext
   - Sort order: Manual priority if available, otherwise most recently created
   - Tooltip: "Your high-priority tasks to tackle after current work"
   - Display up to 5 tasks, with a "See All" option if more exist

3. **Due Soon**
   - Shows tasks due within the next 3 days. Ignore done/discarded tasks.
   - Sort order: Due date (ascending)
   - Tooltip: "Don't miss these approaching deadlines"
   - Should display relative time (Today, Tomorrow, In 2 days)
   - Display up to 5 tasks, with a "See All" option if more exist

### Interaction Behavior

- Tapping a tab should show its associated task list
- Swiping horizontally between tabs should be supported (optional)
- Tapping on a task should navigate to the task detail view
- Long-pressing a task should show quick actions (mark complete, change status)
- "See All" option should navigate to a filtered view of all tasks in that category

### Empty States

- Each tab should have a meaningful empty state
- In Progress: "Nothing in progress. Start working on a task!"
- Do Next: "Set your priorities by marking tasks as 'Do Next'"
- Due Soon: "No upcoming deadlines. Well done!"

## Technical Considerations

- Leverage existing TaskView and TaskViewVariants architecture
- Create appropriate filters for each tab (especially for Due Soon, which will need a date-based filter)
- Ensure optimistic UI updates when changing task status
- Consider caching strategy to ensure quick loading on home screen
- Monitor performance impact of multiple task queries on home screen load
