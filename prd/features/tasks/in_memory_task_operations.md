# In-Memory Task Operations - PRD

## 1. Problem Statement

When a user updates a task in the application, the update affects multiple views that may be currently loaded in memory. The current implementation in `tasksProvider` handles this logic but is doing too many things, making it difficult to maintain and test. Making API calls for every task update operation is inefficient and can lead to poor performance, especially since task updates are frequent operations.

## 2. Solution Overview

We need to extract the in-memory task filtering logic into a separate, focused component that can efficiently determine which views a task should appear in after an update, without requiring API calls for each view. This component will use the existing `InMemoryTaskFilterOperations` to filter tasks locally based on each view's filter criteria.

## 3. Technical Requirements

### 3.1 Functional Requirements

- Given an updated task and a set of loaded views, determine which views the task should be added to, removed from, or updated in
- Perform these operations in memory without making API calls
- Maintain the sorted order of tasks within each view
- Support animation of task insertion and removal where appropriate

### 3.2 Non-Functional Requirements

- Performance optimization for frequent task updates
- Clear separation of concerns from the existing `tasksProvider`
- Easily testable component with minimal dependencies
- Maintain compatibility with the existing filter system

## 4. Technical Solution Design

### 4.1 Implementation Approach

After analysing the existing code, I recommend implementing a **mixin** over a separate class for the following reasons:

1. **Integration with Riverpod**: A mixin can easily integrate with Riverpod providers/notifiers without introducing additional dependencies
2. **Code Reuse**: The functionality can be reused across different providers that need to manage task views
3. **Testability**: A mixin with well-defined methods is easier to test by creating a simple test class that includes the mixin
4. **Separation of Concerns**: The mixin focuses solely on in-memory task operations, leaving other concerns to the including class

### 4.2 Proposed Implementation

```dart
mixin InMemoryTaskOperations {
  /// Handles in-memory task updates across multiple loaded views.
  ///
  /// Takes an updated task and determines which views it should be added to,
  /// removed from, or updated in based on each view's filter criteria.
  ///
  /// Parameters:
  /// - [task]: The updated task entity
  /// - [loadedViews]: The set of TaskListViewData currently loaded in memory
  /// - [ref]: WidgetRef to access providers for different views
  /// - [index]: Optional index of the task in the current view for optimization
  /// - [animateChanges]: Whether to animate the task changes in the UI
  void handleInMemoryTaskOperations(
    TaskEntity task,
    Set<TaskListViewData> loadedViews,
    WidgetRef ref, {
    int? index,
    bool animateChanges = true,
  }) {
    for (final view in loadedViews) {
      if (view.canContainTask(task)) {
        _addOrUpdateTaskInView(task, view, ref, index: index, animate: animateChanges);
      } else {
        _removeTaskFromViewIfExists(task, view, ref, index: index, animate: animateChanges);
      }
    }
  }

  // Private implementation methods
  void _addOrUpdateTaskInView(TaskEntity task, TaskListViewData view, WidgetRef ref,
      {int? index, bool animate = true}) {
    // Implementation details
  }

  void _removeTaskFromViewIfExists(TaskEntity task, TaskListViewData view, WidgetRef ref,
      {int? index, bool animate = true}) {
    // Implementation details
  }

  // Additional helper methods
  // ...
}
```

### 4.3 Integration with Existing Code

The mixin would be used in the `TasksNotifier` as follows:

```dart
class TasksNotifier extends FamilyAsyncNotifier<List<TaskEntity>, TaskListViewData>
    with InMemoryTaskOperations {

  // Existing code...

  Future<void> upsertTask(TaskEntity task) async {
    final previousState = state.valueOrNull;
    final loadedViews = ref.read(loadedTaskListViewDataProvider);

    // Use the mixin method
    handleInMemoryTaskOperations(task, loadedViews, ref);

    final result = await useCase.upsertTask(task);

    // Handle API response...
  }
}
```

## 5. Testing Considerations

### 5.1 Testability Analysis

Using a `ref` parameter in the mixin methods does introduce some complexity for testing, but it's manageable with proper mocking:

1. **Pros of using ref**:

   - Direct access to providers without manual dependency passing
   - Consistent with existing Riverpod patterns

2. **Cons of using ref**:

   - Makes the mixin tightly coupled to Riverpod
   - Requires more complex mocking in tests

3. **Testing strategy**:
   - Create a mock/stub WidgetRef for testing
   - Use a test class that implements the mixin
   - Create mock providers that return predefined values
   - Assert on the changes made to the state after method calls

## 6. Performance Considerations

- The implementation should avoid unnecessary list copies
- Binary search should be used for finding insertion points to maintain proper sorting
- The mixin should be designed to fail gracefully if certain providers are not available
- Animations should be optional and easily disabled for bulk operations

## 7. Next Steps

1. Implement the `InMemoryTaskOperations` mixin with the core functionality
2. Update the `TasksNotifier` to use the mixin
3. Write comprehensive unit tests for the mixin
4. Measure performance improvements after the refactoring
5. Document the usage patterns for other developers

## 8. Conclusion

Extracting the in-memory task operations into a focused mixin will improve code maintainability, testability, and performance. By reusing the existing `InMemoryTaskFilterOperations` and `TaskListViewData` capabilities, we can efficiently determine which views should contain a task without making additional API calls.

The proposed solution maintains compatibility with the current architecture while providing a cleaner separation of concerns, making it easier to understand and modify the in-memory task filtering logic in the future.
