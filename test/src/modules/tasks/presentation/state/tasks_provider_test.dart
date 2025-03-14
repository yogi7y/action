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
import 'package:action/src/modules/tasks/presentation/state/task_view_provider.dart';
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
  late MockStatusTaskView mockInProgressTaskView;
  late MockStatusTaskView mockTodoTaskView;
  late MockStatusTaskView mockDoneTaskView;
  late MockAllTasksView mockAllTasksView;
  late MockUnorganizedTaskView mockUnorganizedTaskView;

  setUpAll(() {
    registerFallbackValue(FakeTask());
    registerFallbackValue(FakeDuration());
  });

  setUp(() {
    // initializing task views.
    mockInProgressTaskView = MockStatusTaskView(id: 'in_progress_task_view');
    mockTodoTaskView = MockStatusTaskView(id: 'todo_task_view');
    mockDoneTaskView = MockStatusTaskView(id: 'done_task_view');
    mockAllTasksView = MockAllTasksView();
    mockUnorganizedTaskView = MockUnorganizedTaskView();

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

  group('handleInMemoryTask', () {
    test(
      'should only call canContainTask on loaded task views',
      () {
        when(() => mockUnorganizedTaskView.canContainTask(any())).thenReturn(true);
        when(() => mockAllTasksView.canContainTask(any())).thenReturn(true);

        final loadedTaskViews = <TaskView>{
          mockAllTasksView,
          mockUnorganizedTaskView,
        };

        final container = createContainer(overrides: [
          loadedTaskViewsProvider.overrideWith((_) => loadedTaskViews),
        ]);

        container
            .read(tasksNotifierProvider(mockUnorganizedTaskView).notifier)
            .handleInMemoryTask(MockTaskEntity());

        verify(() => mockUnorganizedTaskView.canContainTask(any())).called(1);
        verify(() => mockAllTasksView.canContainTask(any())).called(1);
        verifyZeroInteractions(mockInProgressTaskView);
        verifyZeroInteractions(mockTodoTaskView);
        verifyZeroInteractions(mockDoneTaskView);
      },
    );

    test(
      'should call canContainTask on all task views when all are loaded',
      () {
        // Setup mocks to return different values
        when(() => mockUnorganizedTaskView.canContainTask(any())).thenReturn(true);
        when(() => mockAllTasksView.canContainTask(any())).thenReturn(true);
        when(() => mockInProgressTaskView.canContainTask(any())).thenReturn(false);
        when(() => mockTodoTaskView.canContainTask(any())).thenReturn(false);
        when(() => mockDoneTaskView.canContainTask(any())).thenReturn(false);

        // Create a set with all task views loaded
        final loadedTaskViews = <TaskView>{
          mockAllTasksView,
          mockUnorganizedTaskView,
          mockInProgressTaskView,
          mockTodoTaskView,
          mockDoneTaskView,
        };

        final container = createContainer(overrides: [
          loadedTaskViewsProvider.overrideWith((_) => loadedTaskViews),
        ]);

        // Call the method under test
        container
            .read(tasksNotifierProvider(mockUnorganizedTaskView).notifier)
            .handleInMemoryTask(MockTaskEntity());

        // Verify canContainTask was called on all task views
        verify(() => mockUnorganizedTaskView.canContainTask(any())).called(1);
        verify(() => mockAllTasksView.canContainTask(any())).called(1);
        verify(() => mockInProgressTaskView.canContainTask(any())).called(1);
        verify(() => mockTodoTaskView.canContainTask(any())).called(1);
        verify(() => mockDoneTaskView.canContainTask(any())).called(1);
      },
    );

    test(
      'should not call canContainTask on any task view when none are loaded',
      () {
        // Create an empty set of loaded task views
        final loadedTaskViews = <TaskView>{};

        final container = createContainer(overrides: [
          loadedTaskViewsProvider.overrideWith((_) => loadedTaskViews),
        ]);

        // Call the method under test
        container
            .read(tasksNotifierProvider(mockUnorganizedTaskView).notifier)
            .handleInMemoryTask(MockTaskEntity());

        // Verify canContainTask was not called on any task view
        verifyZeroInteractions(mockUnorganizedTaskView);
        verifyZeroInteractions(mockAllTasksView);
        verifyZeroInteractions(mockInProgressTaskView);
        verifyZeroInteractions(mockTodoTaskView);
        verifyZeroInteractions(mockDoneTaskView);
      },
    );

    test(
      'should only call canContainTask on the single loaded task view',
      () {
        // Setup mock to return a value
        when(() => mockTodoTaskView.canContainTask(any())).thenReturn(true);

        // Create a set with only one task view loaded
        final loadedTaskViews = <TaskView>{
          mockTodoTaskView,
        };

        final container = createContainer(overrides: [
          loadedTaskViewsProvider.overrideWith((_) => loadedTaskViews),
        ]);

        // Call the method under test
        container
            .read(tasksNotifierProvider(mockTodoTaskView).notifier)
            .handleInMemoryTask(MockTaskEntity());

        // Verify canContainTask was only called on the loaded task view
        verify(() => mockTodoTaskView.canContainTask(any())).called(1);

        // Verify no interactions with other task views
        verifyZeroInteractions(mockUnorganizedTaskView);
        verifyZeroInteractions(mockAllTasksView);
        verifyZeroInteractions(mockInProgressTaskView);
        verifyZeroInteractions(mockDoneTaskView);
      },
    );

    test(
      'add new task to respective loaded view',
      () async {
        when(() => mockTaskUseCase.fetchTasks(any()))
            .thenAnswer((_) async => const Success(PaginatedResponse(results: [], total: 0)));

        final container = createContainer(overrides: [
          loadedTaskViewsProvider.overrideWith((_) => {
                unorganizedTaskView,
                allTaskView,
              }),
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ]);

        // Read the provider to trigger the build method
        await container.read(tasksNotifierProvider(unorganizedTaskView).future);

        final task = MockTaskEntity();

        container
            .read(tasksNotifierProvider(unorganizedTaskView).notifier)
            .handleInMemoryTask(task);

        final result = container.read(tasksNotifierProvider(unorganizedTaskView)).requireValue;

        expect(result.length, 1);
        expect(result.first, task);
        expect(container.read(tasksNotifierProvider(allTaskView)).requireValue.first, task);
      },
    );

    test(
      'add new task to an existing list of items',
      () async {
        final now = DateTime.now();
        final taskOne = MockTaskEntity(createdAt: now.subtract(const Duration(days: 2)));
        final taskTwo = MockTaskEntity(id: '2', createdAt: now.subtract(const Duration(days: 1)));
        final taskThree = MockTaskEntity(id: '3', createdAt: now);

        when(() => mockTaskUseCase.fetchTasks(any())).thenAnswer(
          (_) async => Success(
            PaginatedResponse(
              results: [taskTwo, taskOne],
              total: 2,
            ),
          ),
        );

        final container = createContainer(overrides: [
          loadedTaskViewsProvider.overrideWith((_) => {
                unorganizedTaskView,
                allTaskView,
              }),
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ]);

        /// Mimicking the behavior of the view being loaded by the user so the state is updated.
        await container.read(tasksNotifierProvider(unorganizedTaskView).future);
        await container.read(tasksNotifierProvider(allTaskView).future);

        container
            .read(tasksNotifierProvider(unorganizedTaskView).notifier)
            .handleInMemoryTask(taskThree);

        final result = container.read(tasksNotifierProvider(unorganizedTaskView)).requireValue;

        expect(
          result,
          <TaskEntity>[
            taskThree,
            taskTwo,
            taskOne,
          ],
        );

        expect(
          container.read(tasksNotifierProvider(allTaskView)).requireValue,
          <TaskEntity>[
            taskThree,
            taskTwo,
            taskOne,
          ],
        );
      },
    );

    test(
      'should remove task from unorganized view and update in all tasks view when status changes from todo to done',
      () async {
        // Use a fixed reference time instead of DateTime.now()
        final referenceTime = DateTime(2024, 5, 1, 12); // 2024-05-01 12:00:00

        final taskOne = MockTaskEntity(
          createdAt: referenceTime.subtract(const Duration(days: 3)),
        );

        final taskTwo = MockTaskEntity(
          id: '2',
          createdAt: referenceTime.subtract(const Duration(days: 2)),
        );

        final taskThree = MockTaskEntity(
          id: '3',
          createdAt: referenceTime.subtract(const Duration(days: 1)),
        );

        final taskFour = MockTaskEntity(id: '4', createdAt: referenceTime);

        // Initial tasks are all in todo status (default for MockTaskEntity)
        when(() => mockTaskUseCase.fetchTasks(any())).thenAnswer(
          (_) async => Success(
            PaginatedResponse(
              results: [taskFour, taskThree, taskTwo, taskOne],
              total: 4,
            ),
          ),
        );

        final container = createContainer(overrides: [
          loadedTaskViewsProvider.overrideWith((_) => {
                unorganizedTaskView,
                allTaskView,
              }),
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ]);

        // Load the initial state for both views
        await container.read(tasksNotifierProvider(unorganizedTaskView).future);
        await container.read(tasksNotifierProvider(allTaskView).future);

        // Verify initial state
        final initialUnorganizedTasks =
            container.read(tasksNotifierProvider(unorganizedTaskView)).requireValue;
        final initialAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;

        expect(initialUnorganizedTasks.length, 4);
        expect(initialAllTasks.length, 4);

        // Create an updated version of taskThree with done status
        final updatedTaskThree = taskThree.copyWith(status: TaskStatus.done);

        // Handle the updated task
        container
            .read(tasksNotifierProvider(unorganizedTaskView).notifier)
            .handleInMemoryTask(updatedTaskThree);

        // Get the updated state for both views
        final updatedUnorganizedTasks =
            container.read(tasksNotifierProvider(unorganizedTaskView)).requireValue;
        final updatedAllTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;

        // Verify that the task was removed from unorganized view as it's status is done so it's organized.
        expect(updatedUnorganizedTasks.length, 3);
        expect(updatedUnorganizedTasks.any((task) => task.id == '3'), isFalse);

        // Verify that the task was updated in all tasks view
        expect(updatedAllTasks.length, 4);
        final updatedTaskInAllView = updatedAllTasks.firstWhere((task) => task.id == '3');
        expect(updatedTaskInAllView.status, TaskStatus.done);
      },
    );
  });

  group('insert task', () {});

  group('removeTaskIfExists', () {
    late TasksNotifier notifier;
    late ProviderContainer container;
    late MockGlobalKey key;
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
      key = MockGlobalKey();
      notifier.setAnimatedListKey(key);

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
        verify(() => key.currentState?.removeItem(2, (_, __) => Container(), duration: any()))
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
        verify(() => key.currentState?.removeItem(2, (_, __) => Container(), duration: any()))
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
        verifyNever(() => key.currentState?.removeItem(any(), any(), duration: any()));
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
        verify(() => key.currentState?.removeItem(0, any(), duration: any())).called(1);
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
        verify(() => key.currentState?.removeItem(0, any(), duration: Duration.zero)).called(1);
      },
    );
  });

  group('addOrUpdateTask', () {
    late TasksNotifier notifier;
    late ProviderContainer container;
    late MockGlobalKey key;
    late TaskEntity taskOne;
    late TaskEntity taskTwo;

    setUp(() async {
      // Create mock task entities with fixed timestamps for predictable sorting
      final now = DateTime(2024, 5, 1, 12); // 2024-05-01 12:00:00
      taskOne = MockTaskEntity(
        name: 'Task One',
        createdAt: now.subtract(const Duration(days: 2)),
      );
      taskTwo = MockTaskEntity(
        id: '2',
        name: 'Task Two',
        createdAt: now.subtract(const Duration(days: 1)),
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
      key = MockGlobalKey();
      notifier.setAnimatedListKey(key);

      // Load the initial state
      await container.read(tasksNotifierProvider(allTaskView).future);
    });

    test(
      'should add a new task at the correct position',
      () {
        // Create a new task that should be inserted at the beginning (newest)
        final now = DateTime(2024, 5, 1, 12);
        final newTask = MockTaskEntity(
          id: '3',
          name: 'New Task',
          createdAt: now,
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
        verify(() => key.currentState?.insertItem(0, duration: any())).called(1);
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
        verifyNever(() => key.currentState?.insertItem(any(), duration: any()));
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
        verify(() => key.currentState?.insertItem(any(), duration: Duration.zero)).called(1);
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
        verifyNever(() => key.currentState?.insertItem(any(), duration: any()));
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
