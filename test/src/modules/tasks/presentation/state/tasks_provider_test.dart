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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskUseCase extends Mock implements TaskUseCase {}

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

class MockTaskEntity extends TaskEntity {
  const MockTaskEntity({super.name = 'Fake Task', super.status = TaskStatus.todo});
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
            .handleInMemoryTask(const MockTaskEntity());

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
            .handleInMemoryTask(const MockTaskEntity());

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
            .handleInMemoryTask(const MockTaskEntity());

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
            .handleInMemoryTask(const MockTaskEntity());

        // Verify canContainTask was only called on the loaded task view
        verify(() => mockTodoTaskView.canContainTask(any())).called(1);

        // Verify no interactions with other task views
        verifyZeroInteractions(mockUnorganizedTaskView);
        verifyZeroInteractions(mockAllTasksView);
        verifyZeroInteractions(mockInProgressTaskView);
        verifyZeroInteractions(mockDoneTaskView);
      },
    );
  });

  group('insert task', () {});

  group('upsertTask', () {
    setUp(() async {
      // Setup the mock to return a successful result
      when(() => mockTaskUseCase.upsertTask(any()))
          .thenAnswer((_) async => const Success(MockTaskEntity()));
    });

    test('should clear the textfield after the task is added', () {
      // Create a container with overridden providers
      final container = createContainer(
        overrides: [
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ],
      );

      final tasksNotifier = container.read(tasksNotifierProvider(testTaskView).notifier);

      unawaited(tasksNotifier.upsertTask(const MockTaskEntity()));

      expect(container.read(newTaskProvider.notifier).controller.text, '');
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
