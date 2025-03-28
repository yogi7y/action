Let me design a detailed auto-advance organization experience that makes inbox processing fluid and efficient.

### Auto-Advance Organization Experience

1. **Entry Point**

```
+----------------------------------+
| Inbox (15)         [Organize All] |
+----------------------------------+
| • Buy groceries                  |
| • Call dentist                   |
| • Review PR                      |
+----------------------------------+
```

2. **Organization Mode UI**

```
+----------------------------------+
| Organizing Inbox (3/15)          |
| ESC to exit • SPACE to skip      |
+----------------------------------+
|                                  |
|     "Buy groceries"              |
|                                  |
+----------------------------------+
| Project                          |
| [Shopping]  [Home]  [+ New]      |
+----------------------------------+
| Context                          |
| [Errands]  [Store]  [+ New]      |
+----------------------------------+
| Due Date                         |
| [Today] [Tomorrow] [This Week]   |
+----------------------------------+
| [← Previous] [Skip] [Next →]     |
+----------------------------------+
```

### Key Features

1. **Progress Indicator**

```
+----------------------------------+
| Progress: ██████░░░░ (6/10)      |
| Estimated time: 2 mins left      |
+----------------------------------+
```

2. **Smart Quick Actions**

```
+----------------------------------+
| Suggested:                       |
| 🎯 Shopping + Errands + Today    |
| 🎯 Home + Weekend                |
+----------------------------------+
```

3. **Keyboard Shortcuts Panel**

```
+----------------------------------+
| ⌘P - Project    ⌘D - Due Date   |
| ⌘C - Context    ⌘S - Skip       |
| ⌘→ - Next       ⌘← - Previous   |
+----------------------------------+
```

### Flow Mechanics

1. **Auto-Advance Triggers**

- After selecting a project
- After selecting a context
- After setting a due date
- After clicking "Next" button
- After using keyboard shortcut

2. **Skip Logic**

```
+----------------------------------+
| Skipped Tasks (2)                |
| Will appear at the end           |
+----------------------------------+
```

3. **Completion States**

```
+----------------------------------+
|           🎉                     |
| All caught up! Inbox is clean.   |
|                                  |
| 12 tasks organized              |
| 2 tasks skipped                 |
| Time taken: 3m 24s              |
|                                  |
| [Review Skipped] [Done]         |
+----------------------------------+
```

### Interaction Details

1. **Task Entry Animation**

```
+----------------------------------+
|     ↓ Next Task Sliding In       |
| "Buy groceries"                  |
|     ↑ Previous Task Sliding Out  |
+----------------------------------+
```

2. **Quick Input Mode**

```
+----------------------------------+
| Type to filter:                  |
| > sh                            |
| • Shopping                      |
| • Shared                        |
| • Ship                          |
+----------------------------------+
```

3. **Context Preservation**

```
+----------------------------------+
| Recently Used:                   |
| 📁 Shopping                      |
| 🏷️ Errands                       |
| 📅 This Weekend                  |
+----------------------------------+
```

### Smart Features

1. **Pattern Detection**

```
+----------------------------------+
| Similar tasks detected!          |
| 3 shopping-related tasks ahead   |
| Apply same project & context?    |
|                                  |
| [Yes, Auto-apply] [No, Skip]    |
+----------------------------------+
```

2. **Quick Templates**

```
+----------------------------------+
| Save as Template?                |
| Shopping + Errands + Weekend     |
|                                  |
| [Save for Later] [No Thanks]     |
+----------------------------------+
```

3. **Focus Mode**

```
+----------------------------------+
| Focus Mode Active                |
| Organize without distractions    |
| 🎧 Ambient sounds on             |
+----------------------------------+
```

### Implementation Notes

1. **Animations**

- Smooth transitions between tasks
- Subtle loading indicators
- Progress bar animations
- Satisfying completion animations

2. **Performance**

- Preload next few tasks
- Cache recent selections
- Optimistic updates

3. **Error Handling**

```
+----------------------------------+
| Couldn't save changes            |
| Don't worry, we'll retry!        |
| Continue organizing...           |
+----------------------------------+
```

4. **Data Persistence**

- Save progress periodically
- Allow session resume
- Keep track of patterns

This design focuses on making the organization process as fluid as possible while providing enough context and tools to make quick decisions. The auto-advance feature removes friction between tasks while still allowing for careful consideration when needed.

Would you like me to elaborate on any particular aspect of this design or provide more specific implementation details?
