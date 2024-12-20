# Tasks

Things which require some action.

### As a user, I should be able to:

- quickly capture a task to let it out of my head.
- view task based on their status like in progress, todo etc.
- have a system which notifies me of tasks that are overdue, cold etc.
- have a system which can highlight upcoming tasks for x days in the future so I can start planning accordingly.

## Skeleton structure

- List screen to show all the tasks
  - Chips at the top to have filters like todo, in progress, do next, overdue, done etc.
  - Search icon to search through the currently list tasks.
  - When search is focused, show “search in all” tasks kind of option somewhere.
  - Sort options
    - Sort by Date, Name
- Create/Edit
  - A bottom sheet which opens up when user creates a new task by or by opening an existing task for edit.
  - Should have smart text field which should detect time, projects, context.
  - Chips below to show the selected projects, context, time.
  - Ability to remove the selected data.
  - The chip should also have an option to select the data if clicked directly. It should probably open a searchable menu item list.
- When clicking on any data like Project, Context etc. it should take the user to that specific details screen.

---

# Pages

Notes that you capture for future reference.

### As a user, I should be able to:

- quickly book mark a resource which I could consume later.
- ability to filter resources based on their consumption type. broadly read, watch, listen. so based on my mood, environment I could easily pick something I’d like to consume.
- resurface notes that I’ve captured in the future to enhance my learning using spaced repetition. `Good to have`
- capture my thought on that page. `Not mandatory for MVP`

## Skeleton Structure

- A list of pages as default screen.
  - Each page item to have some metadata like source, author, resource.
  - Chips at the top to have filters like Read, Watch, Listen, In Progress, Up Next, Done.
  - Search icon to search through the active filter pages. When search in focused, show search in all pages option.
  - Sort option to sort by date and name.
- Create/Edit
  - Similar to tasks, a bottom sheet to create and edit pages.
  - Smart text file to let users select the resources, and chips below similar to tasks.
- Detail view
  - `super_editor` for rich text, if supported. `Not mandatory for MVP`
  - 💡 Think more on the layout here. Maybe a table view or something?

---

# Projects & Context

**Projects:** A box to group all the related tasks, pages at one place.

**Context:** Metadata for tasks so we can batch tasks and do all at once.

### As a user, I should be able to:

- Use projects so I’ve all the task and page related to a project that I’m working on at a single place.
- Use context to batch common tasks like running errands, thing I can do on my phone etc.
- should have ongoing projects like Someday/Maybe where I could capture tasks, ideas etc.
- one-off projects for day to day tasks which doesn’t require any project.
- add existing tasks to a give project/context from within it.

## Skeleton Structure

- Projects and Context to be in a single bottom nav tab.
- When clicked, it should switch to the screen which will have 2 equal weighted chips at the top called “Projects” and “Context”. Or instead of chips, maybe have a top level tab bars at title level.
- Show projects in a card (maybe grid?) view with fields like Name, status,

---

# Areas & Resources

Area: Long term themes happening in your life. eg. Programming, Health & Fitness, Finance etc.

Resources: Collection of pages for a top so everything is at a single place when needed.

### As a user, I should be able to:

- create an Area for an on-going theme in my life and should see things like resources, projects for it at a single place
- it should give me a dedicated place for a specific theme of my life.
- resources should be able to provide me all the pages for a specific resource at a single place.

---

# Home

---

# Common components experience

## Header

---

## Search bar

The search icon will be at the right most side of the screen wherever applicable. When clicked, it should animate and fill the title bar. Other elements should go away so the search bar can fill all the available space.

By default it’ll perform query with the currently selected filter. For example, If I’m in “Overdue” view in tasks screen, it should only search for tasks inside overview. The search bar when in focused view will have a search icon at the start, followed by a text field where use can query and should have a toggleable button towards the right most side. The togglable button should let the user filter either with the current selected view or all the tasks based on which view is selected. From UI side it can probably be a text followed by a up and down arrow vertically aligned to tell it’s togglable.

The results will be replaced in place in the bottom body. There will be no separate screen to see the search results.
