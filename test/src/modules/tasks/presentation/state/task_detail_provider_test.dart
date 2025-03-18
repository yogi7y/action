// ignore_for_file: avoid_implementing_value_types

import 'dart:async';

import 'package:action/src/core/network/paginated_response.dart';
import 'package:action/src/modules/filter/domain/entity/filter.dart';
import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/entity/task_status.dart';
import 'package:action/src/modules/tasks/domain/use_case/task_use_case.dart';
import 'package:action/src/modules/tasks/presentation/state/task_detail_provider.dart';
import 'package:action/src/modules/tasks/presentation/state/task_view_provider.dart';
import 'package:action/src/modules/tasks/presentation/state/tasks_provider.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../utils/provider_container.dart';
import 'tasks_provider_test.dart';

class MockTaskUseCase extends Mock implements TaskUseCase {}

class FakeTaskEntity extends Fake implements TaskEntity {}

class FakeFilter extends Fake implements Filter {}

class MockGlobalKey extends Mock implements GlobalKey<AnimatedListState> {}

void main() {
  late MockTaskUseCase mockTaskUseCase;

  setUpAll(() {
    registerFallbackValue(FakeTaskEntity());
    registerFallbackValue(FakeFilter());
  });

  setUp(() async {
    mockTaskUseCase = MockTaskUseCase();

    // Set up the mock to return a successful result with a default task
    when(() => mockTaskUseCase.upsertTask(any()))
        .thenAnswer((_) async => const Success(TaskEntity(name: 'Default task')));
  });

  group(
    'TaskDetailNotifier (Detail screen updates)',
    () {
      test('initial state is the overridden state', () {
        const task = TaskEntity(name: 'Foo task');
        final container = createContainer(overrides: [
          taskDetailNotifierProvider.overrideWith(() => TaskDetailNotifier(task)),
        ]);

        // read the initial state
        final state = container.read(taskDetailNotifierProvider);
        expect(state, task);
      });

      test('do optimistic update', () async {
        const task = TaskEntity(name: 'Foo task', id: '123');
        final updatedTask = task.copyWith(name: 'Bar task');

        // Setup the mock to return the updated task
        when(() => mockTaskUseCase.upsertTask(updatedTask))
            .thenAnswer((_) async => Success(updatedTask));

        final container = createContainer(overrides: [
          taskDetailNotifierProvider.overrideWith(() => TaskDetailNotifier(task)),
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ]);

        final notifier = container.read(taskDetailNotifierProvider.notifier);
        final result = notifier.updateTask((_) => updatedTask);

        // verify optimistic update
        final state = container.read(taskDetailNotifierProvider);
        expect(state, updatedTask);

        // await the result
        await result;

        // verify that the state is updated
        final stateAfterResult = container.read(taskDetailNotifierProvider);
        expect(stateAfterResult, updatedTask);

        // verify api call was made with the correct task
        verify(() => mockTaskUseCase.upsertTask(updatedTask)).called(1);
      });

      test('should revert to original state when API call fails', () async {
        const task = TaskEntity(name: 'Original task', id: '123');
        final updatedTask = task.copyWith(name: 'Updated task');

        // Setup the mock to return a failure
        final exception = AppException(
          exception: Exception('Failed to update task'),
          stackTrace: StackTrace.current,
        );
        when(() => mockTaskUseCase.upsertTask(updatedTask))
            .thenAnswer((_) async => Failure(exception));

        final container = createContainer(overrides: [
          taskDetailNotifierProvider.overrideWith(() => TaskDetailNotifier(task)),
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ]);

        final notifier = container.read(taskDetailNotifierProvider.notifier);
        final result = notifier.updateTask((_) => updatedTask);

        // verify optimistic update happened
        final stateAfterOptimisticUpdate = container.read(taskDetailNotifierProvider);
        expect(stateAfterOptimisticUpdate, updatedTask);

        // await the result
        await result;

        // verify that the state is reverted to original after API failure
        final stateAfterResult = container.read(taskDetailNotifierProvider);
        expect(stateAfterResult, task);

        // verify api call was made with the correct task
        verify(() => mockTaskUseCase.upsertTask(updatedTask)).called(1);
      });

      test('should handle multiple sequential updates correctly', () async {
        const initialTask = TaskEntity(name: 'Initial task');
        final firstUpdate = initialTask.copyWith(name: 'First update');
        final secondUpdate = firstUpdate.copyWith(name: 'Second update');

        // Setup the mock to return success for both updates
        when(() => mockTaskUseCase.upsertTask(firstUpdate))
            .thenAnswer((_) async => Success(firstUpdate));
        when(() => mockTaskUseCase.upsertTask(secondUpdate))
            .thenAnswer((_) async => Success(secondUpdate));

        final container = createContainer(overrides: [
          taskDetailNotifierProvider.overrideWith(() => TaskDetailNotifier(initialTask)),
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ]);

        final notifier = container.read(taskDetailNotifierProvider.notifier);

        // First update
        final firstResult = notifier.updateTask((_) => firstUpdate);

        // Verify first optimistic update
        expect(container.read(taskDetailNotifierProvider), firstUpdate);

        // Second update before first completes
        final secondResult = notifier.updateTask((_) => secondUpdate);

        // Verify second optimistic update
        expect(container.read(taskDetailNotifierProvider), secondUpdate);

        // Wait for both updates to complete
        await Future.wait([firstResult, secondResult]);

        // Verify final state
        expect(container.read(taskDetailNotifierProvider), secondUpdate);

        // Verify both API calls were made
        verify(() => mockTaskUseCase.upsertTask(firstUpdate)).called(1);
        verify(() => mockTaskUseCase.upsertTask(secondUpdate)).called(1);
      });

      test('updateTask should use the callback to transform the current state', () async {
        const task = TaskEntity(name: 'Original task', id: '123');
        final expectedUpdatedTask = task.copyWith(name: 'Updated via callback');

        // Setup the mock to return the updated task
        when(() => mockTaskUseCase.upsertTask(expectedUpdatedTask))
            .thenAnswer((_) async => Success(expectedUpdatedTask));

        final container = createContainer(overrides: [
          taskDetailNotifierProvider.overrideWith(() => TaskDetailNotifier(task)),
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ]);

        final notifier = container.read(taskDetailNotifierProvider.notifier);

        // Update using the callback that actually uses the current state
        final result = notifier
            .updateTask((currentTask) => currentTask.copyWith(name: 'Updated via callback'));

        // Verify optimistic update
        final stateAfterOptimisticUpdate = container.read(taskDetailNotifierProvider);
        expect(stateAfterOptimisticUpdate, expectedUpdatedTask);

        // Await the result
        await result;

        // Verify final state
        final stateAfterResult = container.read(taskDetailNotifierProvider);
        expect(stateAfterResult, expectedUpdatedTask);

        // Verify API call was made with the correct task
        verify(() => mockTaskUseCase.upsertTask(expectedUpdatedTask)).called(1);
      });
    },
  );

  group('TaskDetailNotifier (List screen updates)', () {
    late ProviderContainer container;

    late GlobalKey<AnimatedListState> unorganizedTaskViewKey;
    late GlobalKey<AnimatedListState> allTaskViewKey;
    late GlobalKey<AnimatedListState> doneTaskViewKey;

    const unorganizedTask1 = TaskEntity(name: 'Unorganized task 1', id: '1');
    const unorganizedTask2 = TaskEntity(name: 'Unorganized task 2', id: '2');
    const unorganizedTask3 = TaskEntity(name: 'Unorganized task 3', id: '3');
    const unorganizedTask4 = TaskEntity(name: 'Unorganized task 4', id: '4');
    const unorganizedTask5 = TaskEntity(name: 'Unorganized task 5', id: '5');

    setUp(() async {
      // return all unorganized tasks
      when(() => mockTaskUseCase.fetchTasks(unorganizedTaskView.operations.filter)).thenAnswer(
        (_) async => const Success(
          PaginatedResponse(
            results: [
              unorganizedTask1,
              unorganizedTask2,
              unorganizedTask3,
              unorganizedTask4,
              unorganizedTask5
            ],
            total: 5,
          ),
        ),
      );

      // return all 'all view' tasks
      when(() => mockTaskUseCase.fetchTasks(allTaskView.operations.filter)).thenAnswer(
        (_) async => const Success(
          PaginatedResponse(
            results: [
              unorganizedTask1,
              unorganizedTask2,
              unorganizedTask3,
              unorganizedTask4,
              unorganizedTask5,
            ],
            total: 5,
          ),
        ),
      );

      // return all 'done view' tasks
      when(() => mockTaskUseCase.fetchTasks(doneTaskView.operations.filter)).thenAnswer(
        (_) async => const Success(
          PaginatedResponse(
            results: [],
            total: 0,
          ),
        ),
      );

      unorganizedTaskViewKey = MockGlobalKey();
      allTaskViewKey = MockGlobalKey();
      doneTaskViewKey = MockGlobalKey();

      container = createContainer(overrides: [
        taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        loadedTaskViewsProvider.overrideWith((_) => {
              unorganizedTaskView,
              allTaskView,
              doneTaskView,
            }),
        taskDetailNotifierProvider.overrideWith(() => TaskDetailNotifier(unorganizedTask3)),
      ]);

      // select the unorganized task view
      container.read(selectedTaskViewProvider.notifier).selectByIndex(4);

      _setAnimatedListKeys(container, unorganizedTaskViewKey, allTaskViewKey, doneTaskViewKey);

      // build the providers
      await _buildAllProviders(container);
    });

    test(
      'should update the list view as well',
      () async {
        // update the task state to done.
        unawaited(
          container
              .read(taskDetailNotifierProvider.notifier)
              .updateTask((state) => state.copyWith(status: TaskStatus.done)),
        );

        // verify that the task was removed from the unorganized task view as it's not longer unorganized.
        _verifyOptimisticUpdate(container, unorganizedTask3);
      },
    );

    test('should revert the changes if the api call fails', () async {
      // stub failure
      when(() => mockTaskUseCase.upsertTask(unorganizedTask3))
          .thenAnswer((_) async => Failure(AppException(
                exception: Exception('Failed to update task'),
                stackTrace: StackTrace.current,
              )));

      final result = container
          .read(taskDetailNotifierProvider.notifier)
          .updateTask((state) => state.copyWith(status: TaskStatus.done));

      _verifyOptimisticUpdate(container, unorganizedTask3);

      // await the result
      await result;

      // verify unorganized state is reverted back
      final unorganizedTasks =
          container.read(tasksNotifierProvider(unorganizedTaskView)).requireValue;
      expect(unorganizedTasks.length, 5);
      expect(unorganizedTasks.any((task) => task.id == unorganizedTask3.id), isTrue);

      // verify all state is reverted back
      final allTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
      expect(allTasks.length, 5);
      expect(allTasks.any((task) => task.id == unorganizedTask3.id), isTrue);
      final updatedTask = allTasks.firstWhere((task) => task.id == unorganizedTask3.id);
      expect(updatedTask.status, TaskStatus.todo);

      // verify done state is reverted back
      final doneTasks = container.read(tasksNotifierProvider(doneTaskView)).requireValue;
      expect(doneTasks.length, 0);
    }, skip: 'brainstorm on how to handle the revert state for all the list views.');
  });
}

void _verifyOptimisticUpdate(ProviderContainer container, TaskEntity unorganizedTask3) {
  // verify that the task was removed from the unorganized task view as it's not longer unorganized.
  final unorganizedTasks = container.read(tasksNotifierProvider(unorganizedTaskView)).requireValue;
  expect(unorganizedTasks.length, 4);
  expect(unorganizedTasks.any((task) => task.id == unorganizedTask3.id), isFalse);

  // verify that the task state was updated in all task view.
  final allTasks = container.read(tasksNotifierProvider(allTaskView)).requireValue;
  expect(allTasks.length, 5);
  expect(allTasks.any((task) => task.id == unorganizedTask3.id), isTrue);
  final updatedTask = allTasks.firstWhere((task) => task.id == unorganizedTask3.id);
  expect(updatedTask.status, TaskStatus.done);

  // verify that the task was added in done task view.
  final doneTasks = container.read(tasksNotifierProvider(doneTaskView)).requireValue;
  expect(doneTasks.length, 1);
  expect(doneTasks.any((task) => task.id == unorganizedTask3.id), isTrue);
  final doneTask = doneTasks.firstWhere((task) => task.id == unorganizedTask3.id);
  expect(doneTask.status, TaskStatus.done);
}

/// Builds all providers for the given container.
Future<void> _buildAllProviders(ProviderContainer container) async {
  await Future.wait([
    container.read(tasksNotifierProvider(unorganizedTaskView).future),
    container.read(tasksNotifierProvider(allTaskView).future),
    container.read(tasksNotifierProvider(doneTaskView).future),
  ]);
}

/// Sets the animated list keys for the given task views.
void _setAnimatedListKeys(
    ProviderContainer container,
    GlobalKey<AnimatedListState> unorganizedTaskViewKey,
    GlobalKey<AnimatedListState> allTaskViewKey,
    GlobalKey<AnimatedListState> doneTaskViewKey) {
  container
      .read(tasksNotifierProvider(unorganizedTaskView).notifier)
      .setAnimatedListKey(unorganizedTaskViewKey);
  container.read(tasksNotifierProvider(allTaskView).notifier).setAnimatedListKey(allTaskViewKey);
  container.read(tasksNotifierProvider(doneTaskView).notifier).setAnimatedListKey(doneTaskViewKey);
}
