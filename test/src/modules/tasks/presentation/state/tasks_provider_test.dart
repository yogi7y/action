// ignore_for_file: avoid_implementing_value_types

import 'dart:async';

import 'package:action/src/core/network/paginated_response.dart';
import 'package:action/src/modules/filter/domain/entity/filter.dart';
import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/entity/task_status.dart';
import 'package:action/src/modules/tasks/domain/use_case/task_use_case.dart';
import 'package:action/src/modules/tasks/presentation/models/task_view.dart';
import 'package:action/src/modules/tasks/presentation/models/task_view_variants.dart';
import 'package:action/src/modules/tasks/presentation/state/new_task_provider.dart';
import 'package:action/src/modules/tasks/presentation/state/tasks_provider.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskUseCase extends Mock implements TaskUseCase {}

class FakeDuration extends Fake implements Duration {}

class MockFilter extends Mock implements Filter {}

class MockStatusTaskView extends Mock implements StatusTaskView {
  MockStatusTaskView({required this.id});

  @override
  final String id;
}

class MockAllTasksView extends Mock implements AllTasksView {}

class MockUnorganizedTaskView extends Mock implements UnorganizedTaskView {}

class MockTaskViewOperations extends Mock implements TaskViewOperations {
  MockTaskViewOperations(this.filter);

  @override
  final Filter filter;
}

class FakeTask extends Fake implements TaskEntity {}

class MockGlobalKey extends Mock implements GlobalKey<AnimatedListState> {}

class MockTaskEntity extends TaskEntity {
  MockTaskEntity({
    super.name = 'Fake task',
    DateTime? createdAt,
    super.status = TaskStatus.todo,
    super.id = '1',
  }) : super(
          createdAt: createdAt ?? DateTime.now(),
        );
}

void main() {
  late MockTaskUseCase mockTaskUseCase;
  late TaskView testTaskView;
  late MockFilter mockFilter;

  setUpAll(() {
    registerFallbackValue(FakeTask());
    registerFallbackValue(FakeDuration());
  });

  setUp(() {
    // initializing task views.
    mockTaskUseCase = MockTaskUseCase();
    mockFilter = MockFilter();

    // Create a test TaskView with mock operations
    testTaskView = TaskView(
      operations: MockTaskViewOperations(mockFilter),
      ui: const TaskViewUI(label: 'Test View'),
      id: 'test_view',
    );

    // Register the fallback values
    registerFallbackValue(MockFilter());
  });

  group('TasksNotifier', () {
    test('should call fetchTasks with correct filter when provider is read', () async {
      // Setup mock response
      final mockTasks = [
        TaskEntity(
          id: '1',
          name: 'Test Task',
          status: TaskStatus.todo,
          createdAt: DateTime.now(),
        ),
      ];

      final mockPaginatedResponse = PaginatedResponse<TaskEntity>(
        results: mockTasks,
        total: 1,
      );

      // Setup the mock to return a successful result
      when(() => mockTaskUseCase.fetchTasks(any()))
          .thenAnswer((_) async => Success(mockPaginatedResponse));

      // Create a container with overridden providers
      final container = createContainer(
        overrides: [
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ],
      );

      // Read the provider to trigger the build method
      final asyncValue = await container.read(tasksNotifierProvider(testTaskView).future);

      // Verify that fetchTasks was called with the correct filter
      verify(() => mockTaskUseCase.fetchTasks(mockFilter)).called(1);

      // Verify the result matches expected data
      expect(asyncValue, equals(mockTasks));
    });

    test('should handle failure when fetching tasks', () async {
      // Setup mock response for failure
      final exception = AppException(
        exception: Exception('Failed to fetch tasks'),
        stackTrace: StackTrace.current,
      );

      // Setup the mock to return a failure result
      when(() => mockTaskUseCase.fetchTasks(any())).thenAnswer((_) async => Failure(exception));

      // Create a container with overridden providers
      final container = createContainer(
        overrides: [
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ],
      );

      // Read the provider to trigger the build method
      final asyncValue = await container.read(tasksNotifierProvider(testTaskView).future);

      // Verify that fetchTasks was called with the correct filter
      verify(() => mockTaskUseCase.fetchTasks(mockFilter)).called(1);

      // Verify the result is an empty list on failure
      expect(asyncValue, equals([]));
    });
  });

  group('removeTaskIfExists', () {
    late TasksNotifier notifier;
    late ProviderContainer container;
    late MockGlobalKey allTasksKey;
    late TaskEntity taskOne;
    late TaskEntity taskTwo;
    late TaskEntity taskThree;
    late TaskEntity taskFour;

    setUp(() async {
      // Create mock task entities
      taskOne = MockTaskEntity(name: 'Task One');
      taskTwo = MockTaskEntity(id: '2', name: 'Task Two', status: TaskStatus.inProgress);
      taskThree = MockTaskEntity(id: '3', name: 'Task Three', status: TaskStatus.done);
      taskFour = MockTaskEntity(id: '4', name: 'Task Four');

      // Setup mock response
      when(() => mockTaskUseCase.fetchTasks(any())).thenAnswer((_) async => Success(
            PaginatedResponse(
              results: [
                taskOne,
                taskTwo,
                taskThree,
                taskFour,
              ],
              total: 4,
            ),
          ));

      // Create container with overrides
      container = createContainer(overrides: [
        taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
      ]);

      // Setup notifier and animated list key
      notifier = container.read(tasksNotifierProvider(allTaskView).notifier);
      allTasksKey = MockGlobalKey();
      notifier.setAnimatedListKey(allTasksKey);

      // Load the initial state
      await container.read(tasksNotifierProvider(allTaskView).future);
    });

    test(
      'given an index remove the task if it exists and update the state',
      () {
        // verify initial state
        final initialAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(initialAllTasks.length, 4);

        // remove the task at index 2
        notifier.removeIfTaskExists(
          taskThree,
          taskView: allTaskView,
          index: 2,
        );

        // verify the state is updated
        final updatedAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(updatedAllTasks.length, 3);
        expect(updatedAllTasks.any((task) => task.id == '3'), isFalse);
        verify(() =>
                allTasksKey.currentState?.removeItem(2, (_, __) => Container(), duration: any()))
            .called(1);
      },
    );

    test(
      'should find and remove task when index is not provided',
      () {
        // verify initial state
        final initialAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(initialAllTasks.length, 4);

        // remove the task without providing an index
        notifier.removeIfTaskExists(
          taskThree,
          taskView: allTaskView,
        );

        // verify the state is updated
        final updatedAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(updatedAllTasks.length, 3);
        expect(updatedAllTasks.any((task) => task.id == '3'), isFalse);
        verify(() =>
                allTasksKey.currentState?.removeItem(2, (_, __) => Container(), duration: any()))
            .called(1);
      },
    );

    test(
      'should do nothing when task does not exist in the list',
      () {
        // Create a non-existent task
        final nonExistentTask = MockTaskEntity(id: '999', name: 'Non-existent Task');

        // verify initial state
        final initialAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(initialAllTasks.length, 4);

        // attempt to remove a non-existent task
        notifier.removeIfTaskExists(
          nonExistentTask,
          taskView: allTaskView,
        );

        // verify the state remains unchanged
        final updatedAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(updatedAllTasks.length, 4);
        verifyNever(() => allTasksKey.currentState?.removeItem(any(), any(), duration: any()));
      },
    );

    test(
      'should find task by name when id is null',
      () {
        // Create a task with the same name as taskOne but with null ID
        final taskWithSameName = MockTaskEntity(id: null, name: 'Task One');

        // verify initial state
        final initialAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(initialAllTasks.length, 4);

        // Remove task by name
        notifier.removeIfTaskExists(
          taskWithSameName,
          taskView: allTaskView,
        );

        // verify the state is updated
        final updatedAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(updatedAllTasks.length, 3);
        expect(updatedAllTasks.any((task) => task.name == 'Task One'), isFalse);
        verify(() => allTasksKey.currentState?.removeItem(0, any(), duration: any())).called(1);
      },
    );

    test(
      'should not animate removal when animate is set to false',
      () {
        // verify initial state
        final initialAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(initialAllTasks.length, 4);

        // Remove task without animation
        notifier.removeIfTaskExists(
          taskOne,
          taskView: allTaskView,
          animate: false,
        );

        // Verify the animation duration is zero
        verify(() => allTasksKey.currentState?.removeItem(0, any(), duration: Duration.zero))
            .called(1);
      },
    );
  });

  group('addOrUpdateTask', () {
    late TasksNotifier notifier;
    late ProviderContainer container;
    late MockGlobalKey allTasksKey;
    late TaskEntity taskOne;
    late TaskEntity taskTwo;

    setUp(() async {
      // Create mock task entities with fixed timestamps for predictable sorting
      taskOne = MockTaskEntity(
        name: 'Task One',
        createdAt: DateTime(2024, 4, 29, 12), // 2024-04-29 12:00:00
      );
      taskTwo = MockTaskEntity(
        id: '2',
        name: 'Task Two',
        createdAt: DateTime(2024, 4, 30, 12), // 2024-04-30 12:00:00
      );

      // Setup mock response
      when(() => mockTaskUseCase.fetchTasks(any())).thenAnswer(
        (_) async => Success(
          PaginatedResponse(
            results: [taskTwo, taskOne],
            total: 2,
          ),
        ),
      );

      // Create container with overrides
      container = createContainer(overrides: [
        taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
      ]);

      // Setup notifier and animated list key
      notifier = container.read(tasksNotifierProvider(allTaskView).notifier);
      allTasksKey = MockGlobalKey();
      notifier.setAnimatedListKey(allTasksKey);

      // Load the initial state
      await container.read(tasksNotifierProvider(allTaskView).future);
    });

    test(
      'should add a new task at the correct position',
      () {
        // Create a new task that should be inserted at the beginning (newest)
        final newTask = MockTaskEntity(
          id: '3',
          name: 'New Task',
          createdAt: DateTime(2024, 5, 1, 12), // 2024-05-01 12:00:00
        );

        // Verify initial state
        final initialTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(initialTasks.length, 2);

        // Add the new task
        notifier.addOrUpdateTask(newTask, taskView: allTaskView);

        // Verify the state is updated correctly
        final updatedTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(updatedTasks.length, 3);
        expect(updatedTasks[0], newTask);
        verify(() => allTasksKey.currentState?.insertItem(0, duration: any())).called(1);
      },
    );

    test(
      'should update an existing task',
      () {
        // Create an updated version of taskOne
        final updatedTask = taskOne.copyWith(name: 'Updated Task One');

        // Verify initial state
        final initialTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(initialTasks.length, 2);
        expect(initialTasks[1].name, 'Task One');

        // Update the task
        notifier.addOrUpdateTask(updatedTask, taskView: allTaskView);

        // Verify the state is updated correctly
        final updatedTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(updatedTasks.length, 2);
        expect(updatedTasks[1].name, 'Updated Task One');

        // Verify no animation was triggered for an update
        verifyNever(() => allTasksKey.currentState?.insertItem(any(), duration: any()));
      },
    );

    test(
      'should not animate when animate is set to false',
      () {
        // Create a new task
        final now = DateTime(2024, 5, 1, 12);
        final newTask = MockTaskEntity(
          id: '3',
          name: 'New Task',
          createdAt: now.subtract(const Duration(hours: 1)),
        );

        // Add the new task without animation
        notifier.addOrUpdateTask(newTask, taskView: allTaskView, animate: false);

        // Verify the animation duration is zero
        verify(() => allTasksKey.currentState?.insertItem(any(), duration: Duration.zero))
            .called(1);
      },
    );

    test(
      'should find task by name when id is null',
      () {
        // Create a task with the same name as taskOne but with null ID
        final taskWithSameName = MockTaskEntity(
          id: null,
          name: 'Task One',
          createdAt: taskOne.createdAt,
        );

        // Update the task
        notifier.addOrUpdateTask(taskWithSameName, taskView: allTaskView);

        // Verify the state is updated correctly
        final updatedTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(updatedTasks.length, 2);
        expect(updatedTasks[1].name, 'Task One');
        expect(updatedTasks[1].id, null);

        // Verify no animation was triggered for an update
        verifyNever(() => allTasksKey.currentState?.insertItem(any(), duration: any()));
      },
    );
  });

  group('upsertTask', () {
    setUp(() async {
      // Setup the mock to return a successful result
      when(() => mockTaskUseCase.upsertTask(any()))
          .thenAnswer((_) async => Success(MockTaskEntity()));
    });

    test('should clear the textfield after the task is added', () {
      // Create a container with overridden providers
      final container = createContainer(
        overrides: [
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ],
      );

      final tasksNotifier = container.read(tasksNotifierProvider(testTaskView).notifier);

      unawaited(tasksNotifier.upsertTask(MockTaskEntity()));

      expect(container.read(newTaskProvider.notifier).controller.text, '');
    });
  });

  group('getInsertIndexForTask', () {
    late TasksNotifier tasksNotifier;

    setUp(() {
      final container = createContainer(
        overrides: [
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ],
      );
      tasksNotifier = container.read(tasksNotifierProvider(testTaskView).notifier);
    });

    test('should return correct index for task that should go at the beginning (newest task)', () {
      final tasks = [
        TaskEntity(
          createdAt: DateTime(2024, 3, 1, 14),
          name: 'Task 1',
          status: TaskStatus.todo,
        ), // 2:00 PM
        TaskEntity(
          createdAt: DateTime(2024, 3, 1, 13),
          name: 'Task 2',
          status: TaskStatus.todo,
        ), // 1:00 PM
      ];

      final newTask = TaskEntity(
        createdAt: DateTime(2024, 3, 1, 15),
        name: 'New Task',
        status: TaskStatus.todo,
      ); // 3:00 PM (newest)

      final result = tasksNotifier.getInsertIndexForTask(tasks, newTask);
      expect(result, 0);
    });

    test('should return correct index for task that should go at the end (oldest task)', () {
      final tasks = [
        TaskEntity(
          createdAt: DateTime(2024, 3, 1, 15),
          name: 'Task 1',
          status: TaskStatus.todo,
        ), // 3:00 PM
        TaskEntity(
          createdAt: DateTime(2024, 3, 1, 14),
          name: 'Task 2',
          status: TaskStatus.todo,
        ), // 2:00 PM
      ];

      final newTask = TaskEntity(
        createdAt: DateTime(2024, 3, 1, 13),
        name: 'New Task',
        status: TaskStatus.todo,
      ); // 1:00 PM (oldest)

      final result = tasksNotifier.getInsertIndexForTask(tasks, newTask);
      expect(result, 2);
    });

    test('should return correct index for task that should go in the middle', () {
      final tasks = [
        TaskEntity(
          createdAt: DateTime(2024, 3, 1, 15),
          name: 'Task 1',
          status: TaskStatus.todo,
        ), // 3:00 PM
        TaskEntity(
          createdAt: DateTime(2024, 3, 1, 13),
          name: 'Task 2',
          status: TaskStatus.todo,
        ), // 1:00 PM
      ];

      final newTask = TaskEntity(
        createdAt: DateTime(2024, 3, 1, 14),
        name: 'New Task',
        status: TaskStatus.todo,
      ); // 2:00 PM (middle)

      final result = tasksNotifier.getInsertIndexForTask(tasks, newTask);
      expect(result, 1);
    });

    test('should return correct index for task with same timestamp (should be placed after)', () {
      final tasks = [
        TaskEntity(
          createdAt: DateTime(2024, 3, 1, 15),
          name: 'Task 1',
          status: TaskStatus.todo,
        ), // 3:00 PM
        TaskEntity(
          createdAt: DateTime(2024, 3, 1, 14),
          name: 'Task 2',
          status: TaskStatus.todo,
        ), // 2:00 PM
        TaskEntity(
          createdAt: DateTime(2024, 3, 1, 13),
          name: 'Task 3',
          status: TaskStatus.todo,
        ), // 1:00 PM
      ];

      final newTask = TaskEntity(
        createdAt: DateTime(2024, 3, 1, 14),
        name: 'New Task',
        status: TaskStatus.todo,
      ); // 2:00 PM (same as one task)

      final result = tasksNotifier.getInsertIndexForTask(tasks, newTask);
      expect(result, 2); // Should be placed after the existing task with same timestamp
    });

    test('should handle empty list', () {
      final tasks = <TaskEntity>[];
      final newTask = TaskEntity(
          createdAt: DateTime(2024, 3, 1, 14), name: 'New Task', status: TaskStatus.todo);

      final result = tasksNotifier.getInsertIndexForTask(tasks, newTask);
      expect(result, 0);
    });

    test('should handle list with single item', () {
      final tasks = [
        TaskEntity(
            createdAt: DateTime(2024, 3, 1, 14),
            name: 'Task 1',
            status: TaskStatus.todo), // 2:00 PM
      ];

      final newTask = TaskEntity(
          createdAt: DateTime(2024, 3, 1, 15),
          name: 'New Task',
          status: TaskStatus.todo); // 3:00 PM (newer)

      final result = tasksNotifier.getInsertIndexForTask(tasks, newTask);
      expect(result, 0); // Should go at the beginning since it's newer
    });

    test('should maintain order with multiple tasks having same timestamp', () {
      final tasks = [
        TaskEntity(
            createdAt: DateTime(2024, 3, 1, 14),
            name: 'Task 1',
            status: TaskStatus.todo), // 2:00 PM
        TaskEntity(
            createdAt: DateTime(2024, 3, 1, 14),
            name: 'Task 2',
            status: TaskStatus.todo), // 2:00 PM
        TaskEntity(
            createdAt: DateTime(2024, 3, 1, 14),
            name: 'Task 3',
            status: TaskStatus.todo), // 2:00 PM
      ];

      final newTask = TaskEntity(
          createdAt: DateTime(2024, 3, 1, 14),
          name: 'New Task',
          status: TaskStatus.todo); // 2:00 PM (same timestamp)

      final result = tasksNotifier.getInsertIndexForTask(tasks, newTask);
      expect(result, 3); // Should be placed after all tasks with the same timestamp
    });
  });
}

final inProgressTaskView = StatusTaskView(
  status: TaskStatus.inProgress,
  ui: const TaskViewUI(label: 'In Progress'),
  id: TaskView.generateId(
    screenName: 'tasks_screen',
    viewName: 'in_progress_tasks_view',
  ),
);

final todoTaskView = StatusTaskView(
  status: TaskStatus.todo,
  ui: const TaskViewUI(label: 'Todo'),
  id: TaskView.generateId(
    screenName: 'tasks_screen',
    viewName: 'todo_tasks_view',
  ),
);

final doneTaskView = StatusTaskView(
  status: TaskStatus.done,
  ui: const TaskViewUI(label: 'Done'),
  id: TaskView.generateId(
    screenName: 'tasks_screen',
    viewName: 'done_tasks_view',
  ),
);

final allTaskView = AllTasksView(
  ui: const TaskViewUI(label: 'All'),
  id: TaskView.generateId(
    screenName: 'tasks_screen',
    viewName: 'all_tasks_view',
  ),
);

final unorganizedTaskView = UnorganizedTaskView(
  ui: const TaskViewUI(label: 'Unorganized'),
  id: TaskView.generateId(
    screenName: 'tasks_screen',
    viewName: 'unorganized_tasks_view',
  ),
);

ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

class AddOrUpdateTaskCall {
  final TaskEntity task;
  final TaskView taskView;
  final bool animate;

  AddOrUpdateTaskCall({
    required this.task,
    required this.taskView,
    this.animate = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddOrUpdateTaskCall &&
          runtimeType == other.runtimeType &&
          task.id == other.task.id &&
          taskView == other.taskView;

  @override
  int get hashCode => Object.hash(task.id, taskView);
}

class RemoveIfTaskExistsCall {
  final TaskEntity task;
  final TaskView taskView;
  final int? index;
  final bool animate;

  RemoveIfTaskExistsCall({
    required this.task,
    required this.taskView,
    this.index,
    this.animate = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemoveIfTaskExistsCall &&
          runtimeType == other.runtimeType &&
          task.id == other.task.id &&
          taskView == other.taskView &&
          index == other.index;

  @override
  int get hashCode => Object.hash(task.id, taskView, index);
}

class SpyTasksNotifier extends TasksNotifier {
  final List<AddOrUpdateTaskCall> addOrUpdateTaskCalls = [];
  final List<RemoveIfTaskExistsCall> removeIfTaskExistsCalls = [];
  Set<TaskView>? _loadedTaskViews;
  late GlobalKey<AnimatedListState> _animatedListKey;

  void setLoadedTaskViews(Set<TaskView> views) {
    _loadedTaskViews = views;
  }

  @override
  void setAnimatedListKey(GlobalKey<AnimatedListState> key) {
    _animatedListKey = key;
  }

  @override
  GlobalKey<AnimatedListState>? get animatedListKey => _animatedListKey;

  @override
  void addOrUpdateTask(
    TaskEntity task, {
    required TaskView taskView,
    bool animate = true,
  }) {
    addOrUpdateTaskCalls.add(AddOrUpdateTaskCall(
      task: task,
      taskView: taskView,
      animate: animate,
    ));
  }

  @override
  void removeIfTaskExists(
    TaskEntity task, {
    required TaskView taskView,
    int? index,
    bool animate = true,
  }) {
    removeIfTaskExistsCalls.add(RemoveIfTaskExistsCall(
      task: task,
      taskView: taskView,
      index: index,
      animate: animate,
    ));
  }

  @override
  Future<List<TaskEntity>> build(TaskView arg) async {
    return [];
  }

  @override
  void handleInMemoryTask(TaskEntity task, {int? index}) {
    final loadedTaskViews = _loadedTaskViews ?? <TaskView>{};

    for (final view in loadedTaskViews) {
      if (view.canContainTask(task)) {
        addOrUpdateTask(task, taskView: view);
      } else {
        removeIfTaskExists(task, taskView: view, index: index);
      }
    }
  }
}
