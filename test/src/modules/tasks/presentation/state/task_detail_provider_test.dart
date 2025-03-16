// ignore_for_file: avoid_implementing_value_types

import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/use_case/task_use_case.dart';
import 'package:action/src/modules/tasks/presentation/state/task_detail_provider.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../utils/provider_container.dart';

class MockTaskUseCase extends Mock implements TaskUseCase {}

class FakeTaskEntity extends Fake implements TaskEntity {}

void main() {
  late MockTaskUseCase mockTaskUseCase;

  setUpAll(() {
    registerFallbackValue(FakeTaskEntity());
  });

  setUp(() async {
    mockTaskUseCase = MockTaskUseCase();

    // Set up the mock to return a successful result with a default task
    when(() => mockTaskUseCase.upsertTask(any()))
        .thenAnswer((_) async => const Success(TaskEntity(name: 'Default task')));
  });

  group(
    'TaskDetailNotifierProvider',
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
}
