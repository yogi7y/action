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
    super.id,
    super.projectId,
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

  group('upsert', () {
    late ProviderContainer container;

    /// Currently active task view. The task view where user is on.
    late TaskView taskView;

    // Animated list view keys for each view.
    late GlobalKey<AnimatedListState> unorganizedTaskViewKey;
    late GlobalKey<AnimatedListState> allTaskViewKey;
    late GlobalKey<AnimatedListState> inProgressTaskViewKey;
    late GlobalKey<AnimatedListState> todoTaskViewKey;
    late GlobalKey<AnimatedListState> doneTaskViewKey;

    setUp(() async {
      // stub the api call
      when(() => mockTaskUseCase.fetchTasks(any()))
          .thenAnswer((_) async => const Success(PaginatedResponse(results: [], total: 0)));
      when(() => mockTaskUseCase.upsertTask(any()))
          .thenAnswer((_) async => Success(MockTaskEntity(id: '1')));

      // load views in memory. We're kind of mimicking the behavior when user will visit these tabs individually and then it'll be in the loaded view provider.

      // create the container
      container = createContainer(overrides: [
        taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        loadedTaskViewsProvider.overrideWith((_) => {
              taskView,
              allTaskView,
              inProgressTaskView,
              todoTaskView,
              doneTaskView,
            }),
      ]);

      taskView = unorganizedTaskView;

      // create animated list view keys
      unorganizedTaskViewKey = MockGlobalKey();
      allTaskViewKey = MockGlobalKey();
      inProgressTaskViewKey = MockGlobalKey();
      todoTaskViewKey = MockGlobalKey();
      doneTaskViewKey = MockGlobalKey();

      // set animated list view keys
      container
          .read(tasksNotifierProvider(unorganizedTaskView).notifier)
          .setAnimatedListKey(unorganizedTaskViewKey);
      container
          .read(tasksNotifierProvider(allTaskView).notifier)
          .setAnimatedListKey(allTaskViewKey);
      container
          .read(tasksNotifierProvider(inProgressTaskView).notifier)
          .setAnimatedListKey(inProgressTaskViewKey);
      container
          .read(tasksNotifierProvider(todoTaskView).notifier)
          .setAnimatedListKey(todoTaskViewKey);
      container
          .read(tasksNotifierProvider(doneTaskView).notifier)
          .setAnimatedListKey(doneTaskViewKey);

      await _buildAllProviders(container);
    });

    test(
      'should perform optimistic update and then call the api.',
      () async {
        final taskView = unorganizedTaskView;
        final task = MockTaskEntity(name: 'Task 1');
        final expectedTask = task.copyWith(id: '1');

        // stub the api call
        when(() => mockTaskUseCase.upsertTask(any()))
            .thenAnswer((_) async => Success(expectedTask));

        final notifier = container.read(tasksNotifierProvider(taskView).notifier);

        // call the upsert method to create/update the task.
        final result = notifier.upsertTask(task);

        // verify the task was optimistically added to the list.
        final tasks = container.read(tasksNotifierProvider(taskView)).requireValue;
        expect(tasks.length, 1);
        expect(tasks.first, expectedTask.mark(idAsNull: true));
        expect(tasks.first.id, null); // task does not have an id yet as it's created on backend.

        // verify the api call was called with the correct task.
        verify(() => mockTaskUseCase.upsertTask(task)).called(1);

        // await the api call to complete.
        await result;

        // verify the task was updated in the list.
        final updatedTasks = container.read(tasksNotifierProvider(taskView)).requireValue;
        expect(updatedTasks.length, 1);
        expect(updatedTasks.first, expectedTask);
        expect(updatedTasks.first.id, '1');
      },
    );

    test(
      'should revert the optimistic update if the api call fails.',
      () async {
        // stub api to fail
        when(() => mockTaskUseCase.upsertTask(any())).thenAnswer((_) async => Failure(AppException(
              exception: Exception('Failed to upsert task'),
              stackTrace: StackTrace.current,
            )));

        final task = MockTaskEntity(name: 'Task 1');

        // get access to notifier
        final notifier = container.read(tasksNotifierProvider(taskView).notifier);

        // call the upsert method to create/update the task.
        final result = notifier.upsertTask(task);

        // verify the task was optimistically added to the list.
        final tasks = container.read(tasksNotifierProvider(taskView)).requireValue;
        expect(tasks.length, 1);
        expect(tasks.first, task.mark(idAsNull: true));
        expect(tasks.first.id, null); // task does not have an id yet as it's created on backend.

        // verify the api call was called with the correct task.
        verify(() => mockTaskUseCase.upsertTask(task)).called(1);

        // await the api call to complete.
        await result;

        // verify that we fallback to the previous state as API returns a failure.
        final updatedTasks = container.read(tasksNotifierProvider(taskView)).requireValue;
        expect(updatedTasks.length, 0);
      },
    );

    test('should keep the keyboard open after a task is added', () {});

    test('should clear the textfield after a task is added if the task is added successfully',
        () async {
      // prefill textfield with text to mock the real-world behavior.
      container.read(newTaskProvider.notifier).controller.text = 'Task 1';

      final task = MockTaskEntity(name: 'Task 1');

      // get notifier
      final notifier = container.read(tasksNotifierProvider(taskView).notifier);

      // call the upsert method to create/update the task.
      await notifier.upsertTask(task);

      // verify the textfield is cleared
      expect(container.read(newTaskProvider.notifier).controller.text, '');
    });

    test(
        'should not clear the textfield after a task is added if the task is not added successfully',
        () async {
      // prefill textfield with text to mock the real-world behavior.
      container.read(newTaskProvider.notifier).controller.text = 'Task 1';

      final task = MockTaskEntity(name: 'Task 1');

      // stub the api call to fail
      when(() => mockTaskUseCase.upsertTask(any())).thenAnswer((_) async => Failure(AppException(
            exception: Exception('Failed to upsert task'),
            stackTrace: StackTrace.current,
          )));

      // get notifier
      final notifier = container.read(tasksNotifierProvider(taskView).notifier);

      // call the upsert method to create/update the task.
      await notifier.upsertTask(task);

      // verify the textfield is not cleared
      expect(container.read(newTaskProvider.notifier).controller.text, 'Task 1');
    });

    group('with multiple tasks', () {
      const projectId = 'project_id';
      final organizedInProgressTask = MockTaskEntity(
        id: '1',
        name: 'Organized In Progress Task',
        status: TaskStatus.inProgress,
        projectId: projectId,
      );

      final organizedInProgressTaskTwo = MockTaskEntity(
        id: '2',
        name: 'Organized In Progress Task Two',
        status: TaskStatus.inProgress,
        projectId: projectId,
      );

      final organizedInProgressTaskThree = MockTaskEntity(
        id: '3',
        name: 'Organized In Progress Task Three',
        status: TaskStatus.inProgress,
        projectId: projectId,
      );

      final organizedTodoTask = MockTaskEntity(
        id: '4',
        name: 'Organized Todo Task',
        projectId: projectId,
      );

      final organizedTodoTaskTwo = MockTaskEntity(
        id: '5',
        name: 'Organized Todo Task Two',
        projectId: projectId,
      );

      final organizedTodoTaskThree = MockTaskEntity(
        id: '6',
        name: 'Organized Todo Task Three',
        projectId: projectId,
      );

      final organizedDoneTask = MockTaskEntity(
        id: '7',
        name: 'Organized Done Task',
        status: TaskStatus.done,
        projectId: projectId,
      );

      final organizedDoneTaskTwo = MockTaskEntity(
        id: '8',
        name: 'Organized Done Task Two',
        status: TaskStatus.done,
        projectId: projectId,
      );

      final organizedDoneTaskThree = MockTaskEntity(
        id: '9',
        name: 'Organized Done Task Three',
        status: TaskStatus.done,
        projectId: projectId,
      );

      final unorganizedTask = MockTaskEntity(
        id: '10',
        name: 'Unorganized Task',
      );

      final unorganizedTaskTwo = MockTaskEntity(
        id: '11',
        name: 'Unorganized Task Two',
      );

      final unorganizedTaskThree = MockTaskEntity(
        id: '12',
        name: 'Unorganized Task Three',
      );

      final unorganizedTaskFour = MockTaskEntity(
        id: '13',
        name: 'Unorganized Task Four',
      );

      setUp(() async {
        // return all task for allTaskView
        when(() => mockTaskUseCase.fetchTasks(allTaskView.operations.filter)).thenAnswer(
          (_) async => Success(
            PaginatedResponse(
              results: [
                organizedInProgressTask,
                organizedInProgressTaskTwo,
                organizedInProgressTaskThree,
                organizedTodoTask,
                organizedTodoTaskTwo,
                organizedTodoTaskThree,
                organizedDoneTask,
                organizedDoneTaskTwo,
                organizedDoneTaskThree,
                unorganizedTask,
                unorganizedTaskTwo,
                unorganizedTaskThree,
                unorganizedTaskFour,
              ],
              total: 13,
            ),
          ),
        );

        // return organized in progress task for inProgressTaskView
        when(() => mockTaskUseCase.fetchTasks(inProgressTaskView.operations.filter)).thenAnswer(
          (_) async => Success(
            PaginatedResponse(
              results: [
                organizedInProgressTask,
                organizedInProgressTaskTwo,
                organizedInProgressTaskThree,
              ],
              total: 3,
            ),
          ),
        );

        // return organized todo task for todoTaskView
        when(() => mockTaskUseCase.fetchTasks(todoTaskView.operations.filter)).thenAnswer(
          (_) async => Success(
            PaginatedResponse(
              results: [
                organizedTodoTask,
                organizedTodoTaskTwo,
                organizedTodoTaskThree,
              ],
              total: 3,
            ),
          ),
        );

        // return organized done task for doneTaskView
        when(() => mockTaskUseCase.fetchTasks(doneTaskView.operations.filter)).thenAnswer(
          (_) async => Success(
            PaginatedResponse(
              results: [
                organizedDoneTask,
                organizedDoneTaskTwo,
                organizedDoneTaskThree,
              ],
              total: 3,
            ),
          ),
        );

        // return unorganized task for unorganizedTaskView
        when(() => mockTaskUseCase.fetchTasks(unorganizedTaskView.operations.filter)).thenAnswer(
          (_) async => Success(
            PaginatedResponse(
              results: [
                unorganizedTask,
                unorganizedTaskTwo,
                unorganizedTaskThree,
                unorganizedTaskFour,
              ],
              total: 4,
            ),
          ),
        );

        // invalidate state
        _invalidateAllTaskNotifier(container);

        await _buildAllProviders(container);
      });

      test('verify all the task belong to their specific views', () {
        // All task view will hold all the tasks
        final allTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(allTasks.length, 13);
        expect(allTasks.any((task) => task.id == organizedInProgressTask.id), isTrue);
        expect(allTasks.any((task) => task.id == organizedInProgressTaskTwo.id), isTrue);
        expect(allTasks.any((task) => task.id == organizedInProgressTaskThree.id), isTrue);
        expect(allTasks.any((task) => task.id == organizedTodoTask.id), isTrue);
        expect(allTasks.any((task) => task.id == organizedTodoTaskTwo.id), isTrue);
        expect(allTasks.any((task) => task.id == organizedTodoTaskThree.id), isTrue);
        expect(allTasks.any((task) => task.id == organizedDoneTask.id), isTrue);
        expect(allTasks.any((task) => task.id == organizedDoneTaskTwo.id), isTrue);
        expect(allTasks.any((task) => task.id == organizedDoneTaskThree.id), isTrue);
        expect(allTasks.any((task) => task.id == unorganizedTask.id), isTrue);
        expect(allTasks.any((task) => task.id == unorganizedTaskTwo.id), isTrue);
        expect(allTasks.any((task) => task.id == unorganizedTaskThree.id), isTrue);
        expect(allTasks.any((task) => task.id == unorganizedTaskFour.id), isTrue);

        // In progress task view will only hold the in progress tasks
        final inProgressTasks =
            container.read(tasksNotifierProvider(inProgressTaskView)).requireValue;
        expect(inProgressTasks.length, 3);
        expect(inProgressTasks.contains(organizedInProgressTask), isTrue);
        expect(inProgressTasks.contains(organizedInProgressTaskTwo), isTrue);
        expect(inProgressTasks.contains(organizedInProgressTaskThree), isTrue);

        // task view will only hold the todo tasks
        final todoTasks = container.read(tasksNotifierProvider(todoTaskView)).requireValue;
        expect(todoTasks.length, 3);
        expect(todoTasks.contains(organizedTodoTask), isTrue);
        expect(todoTasks.contains(organizedTodoTaskTwo), isTrue);
        expect(todoTasks.contains(organizedTodoTaskThree), isTrue);

        // Done task view will only hold the done tasks
        final doneTasks = container.read(tasksNotifierProvider(doneTaskView)).requireValue;
        expect(doneTasks.length, 3);
        expect(doneTasks.contains(organizedDoneTask), isTrue);
        expect(doneTasks.contains(organizedDoneTaskTwo), isTrue);
        expect(doneTasks.contains(organizedDoneTaskThree), isTrue);

        // Unorganized task view will only hold the unorganized tasks
        final unorganizedTasks =
            container.read(tasksNotifierProvider(unorganizedTaskView)).requireValue;
        expect(unorganizedTasks.length, 4);
        expect(unorganizedTasks.contains(unorganizedTask), isTrue);
        expect(unorganizedTasks.contains(unorganizedTaskTwo), isTrue);
        expect(unorganizedTasks.contains(unorganizedTaskThree), isTrue);
        expect(unorganizedTasks.contains(unorganizedTaskFour), isTrue);
      });

      test('updating status should also reflect in other views', () async {
        // update status of unorganized task from todo to done.
        final updatedState = unorganizedTask.copyWith(status: TaskStatus.inProgress);

        // update the status of the task
        final notifier = container.read(tasksNotifierProvider(unorganizedTaskView).notifier);
        await notifier.upsertTask(updatedState);

        // it should show as in progress in unorganized task view.
        final unorganizedTasks =
            container.read(tasksNotifierProvider(unorganizedTaskView)).requireValue;
        expect(unorganizedTasks.length, 4);
        // get the updated task
        final updatedTask = unorganizedTasks.firstWhere((task) => task.id == updatedState.id);
        expect(updatedTask.status, TaskStatus.inProgress);

        // it should also update in all task view.
        final allTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(allTasks.length, 13);
        expect(allTasks.any((task) => task.id == updatedState.id), isTrue);
        final updatedAllTask = allTasks.firstWhere((task) => task.id == updatedState.id);
        expect(updatedAllTask.status, TaskStatus.inProgress);

        // it should not update in in progress task view it's not organized hence cannot be in in progress task view.
        final inProgressTasks =
            container.read(tasksNotifierProvider(inProgressTaskView)).requireValue;
        expect(inProgressTasks.length, 3);
        expect(inProgressTasks.any((task) => task.id == updatedState.id), isFalse);

        // should not update in todo and done view as well.
        final todoTasks = container.read(tasksNotifierProvider(todoTaskView)).requireValue;
        expect(todoTasks.length, 3);
        expect(todoTasks.any((task) => task.id == updatedState.id), isFalse);

        final doneTasks = container.read(tasksNotifierProvider(doneTaskView)).requireValue;
        expect(doneTasks.length, 3);
        expect(doneTasks.any((task) => task.id == updatedState.id), isFalse);
      });

      test('task should move between views based on the new state.', () async {
        // update unorganized task from todo to done.
        final updatedState = unorganizedTask.copyWith(status: TaskStatus.done);

        // update the status of the task
        final notifier = container.read(tasksNotifierProvider(unorganizedTaskView).notifier);
        await notifier.upsertTask(updatedState);

        // it should be removed from unorganized task view as it's organized now.
        final unorganizedTasks =
            container.read(tasksNotifierProvider(unorganizedTaskView)).requireValue;
        expect(unorganizedTasks.length, 3);
        expect(unorganizedTasks.any((task) => task.id == updatedState.id), isFalse);

        // should update its state in all task view.
        final allTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
        expect(allTasks.length, 13);
        expect(allTasks.any((task) => task.id == updatedState.id), isTrue);
        final updatedAllTask = allTasks.firstWhere((task) => task.id == updatedState.id);
        expect(updatedAllTask.status, TaskStatus.done);

        // should be added to done task view.
        final doneTasks = container.read(tasksNotifierProvider(doneTaskView)).requireValue;
        expect(doneTasks.length, 4);
        expect(doneTasks.any((task) => task.id == updatedState.id), isTrue);

        // nothing should happen to todo and in progress views.
        final todoTasks = container.read(tasksNotifierProvider(todoTaskView)).requireValue;
        expect(todoTasks.length, 3);
        expect(todoTasks.any((task) => task.id == updatedState.id), isFalse);

        final inProgressTasks =
            container.read(tasksNotifierProvider(inProgressTaskView)).requireValue;
        expect(inProgressTasks.length, 3);
        expect(inProgressTasks.any((task) => task.id == updatedState.id), isFalse);
      });

      test(
        'task is moved from organized to unorganized view',
        () async {
          // remove project id from a task which is in todo to make it unorganized.
          final updatedState = organizedTodoTask.mark(projectIdAsNull: true);

          // update the status of the task
          final notifier = container.read(tasksNotifierProvider(todoTaskView).notifier);
          await notifier.upsertTask(updatedState);

          // it should be removed from todo task view as it's no longer organized.
          final todoTasks = container.read(tasksNotifierProvider(todoTaskView)).requireValue;
          expect(todoTasks.length, 2);
          expect(todoTasks.any((task) => task.id == updatedState.id), isFalse);

          // it should be added to unorganized task view.
          final unorganizedTasks =
              container.read(tasksNotifierProvider(unorganizedTaskView)).requireValue;
          expect(unorganizedTasks.length, 5);
          expect(unorganizedTasks.any((task) => task.id == updatedState.id), isTrue);

          // should update its state in all task view.
          final allTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
          expect(allTasks.length, 13);
          expect(allTasks.any((task) => task.id == updatedState.id), isTrue);
          final updatedAllTask = allTasks.firstWhere((task) => task.id == updatedState.id);
          expect(updatedAllTask.status, TaskStatus.todo);

          // should not update in in progress and done task view as it's not organized.
          final inProgressTasks =
              container.read(tasksNotifierProvider(inProgressTaskView)).requireValue;
          expect(inProgressTasks.length, 3);
          expect(inProgressTasks.any((task) => task.id == updatedState.id), isFalse);

          final doneTasks = container.read(tasksNotifierProvider(doneTaskView)).requireValue;
          expect(doneTasks.length, 3);
          expect(doneTasks.any((task) => task.id == updatedState.id), isFalse);
        },
      );
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
        final taskWithSameName = MockTaskEntity(name: 'Task One');

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
        id: '1',
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

void _invalidateAllTaskNotifier(ProviderContainer container) {
  container
    ..invalidate(tasksNotifierProvider(allTaskView))
    ..invalidate(tasksNotifierProvider(inProgressTaskView))
    ..invalidate(tasksNotifierProvider(todoTaskView))
    ..invalidate(tasksNotifierProvider(doneTaskView))
    ..invalidate(tasksNotifierProvider(unorganizedTaskView));
}

Future<void> _buildAllProviders(ProviderContainer container) async {
  await Future.wait([
    container.read(tasksNotifierProvider(allTaskView).future),
    container.read(tasksNotifierProvider(inProgressTaskView).future),
    container.read(tasksNotifierProvider(todoTaskView).future),
    container.read(tasksNotifierProvider(doneTaskView).future),
    container.read(tasksNotifierProvider(unorganizedTaskView).future),
  ]);
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
