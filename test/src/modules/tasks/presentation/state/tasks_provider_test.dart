// ignore_for_file: avoid_implementing_value_types

import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/entity/task_status.dart';
import 'package:action/src/modules/tasks/domain/use_case/task_use_case.dart';
import 'package:action/src/modules/tasks/presentation/models/task_view.dart';
import 'package:action/src/modules/tasks/presentation/state/new_task_provider.dart';
import 'package:action/src/modules/tasks/presentation/state/tasks_provider.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskUseCase extends Mock implements TaskUseCase {}

class MockGlobalKey extends Mock implements GlobalKey<AnimatedListState> {}

class FakeTaskView extends Fake implements TaskView {
  @override
  String get id => 'fake-task-view-id';
}

class FakeDateTime extends Fake implements DateTime {}

class FakeTaskEntity extends Fake implements TaskEntity {}

void main() {
  late MockTaskUseCase mockTaskUseCase;
  late FakeDateTime fakeDateTime;
  late FakeTaskView fakeTaskView;
  late MockGlobalKey mockGlobalKey;

  setUpAll(
    () {
      registerFallbackValue(FakeTaskView());
      registerFallbackValue(FakeDateTime());
      registerFallbackValue(FakeTaskEntity());
    },
  );

  setUp(() {
    mockTaskUseCase = MockTaskUseCase();
    fakeDateTime = FakeDateTime();
    fakeTaskView = FakeTaskView();
    mockGlobalKey = MockGlobalKey();
  });

  group(
    'addTask',
    () {
      test(
        'should optimistically update then state and then replace the temp task with the one sent as response from the use case.',
        () async {
          final taskToReturn = TaskEntity(
            createdAt: fakeDateTime,
            updatedAt: fakeDateTime,
            id: 'task-id-0',
            name: 'Test',
            status: TaskStatus.todo,
          );

          when(() => mockTaskUseCase.upsertTask(any())).thenAnswer(
            (_) async => Success(taskToReturn),
          );

          when(() => mockGlobalKey.currentState?.insertItem(any())).thenReturn(null);

          final container = createContainer(
            overrides: [
              taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
              isTaskTextInputFieldVisibleProvider.overrideWith((previous) => true),
            ],
          );

          final tasksNotifier = container.read(tasksNotifierProvider(fakeTaskView).notifier)
            ..setAnimatedListKey(mockGlobalKey);

          const taskProperties = TaskEntity(
            name: 'Test',
            status: TaskStatus.todo,
          );

          final addTaskResult = tasksNotifier.upsertTask(
            taskProperties,
            addToTop: true,
          );

          final state =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

          expect(state?.first.id, isEmpty);
          expect(state?.first.name, 'Test');
          expect(state?.first.status, TaskStatus.todo);

          // Ensure that the task is inserted at the top of the list.
          verify(() => mockGlobalKey.currentState?.insertItem(0)).called(1);

          /// hide text field after the task is successfully added.
          final textFieldVisibility = container.read(isTaskTextInputFieldVisibleProvider);
          expect(textFieldVisibility, isFalse);

          verify(() => mockTaskUseCase.upsertTask(taskProperties)).called(1);

          await addTaskResult;

          final stateAfterUpdate =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

          expect(stateAfterUpdate?.first.id, 'task-id-0');
          expect(stateAfterUpdate?.first.name, 'Test');
          expect(stateAfterUpdate?.first.status, TaskStatus.todo);
        },
      );

      test(
        'should revert to previous state and remove the optimistic update in case API fails',
        () async {
          when(() => mockTaskUseCase.upsertTask(any())).thenAnswer(
            (_) async => const Failure(AppException(exception: '', stackTrace: StackTrace.empty)),
          );

          final initialState = [
            TaskEntity(
              createdAt: fakeDateTime,
              updatedAt: fakeDateTime,
              id: 'initial-task-id',
              name: 'Initial Task',
              status: TaskStatus.done,
            ),
          ];

          final container = createContainer(
            overrides: [
              taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
              isTaskTextInputFieldVisibleProvider.overrideWith((previous) => true),
            ],
          );

          final tasksNotifier = container.read(tasksNotifierProvider(fakeTaskView).notifier)
            ..updateState(initialState);

          const taskProperties = TaskEntity(
            name: 'Test',
            status: TaskStatus.todo,
          );

          final previousState =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

          final addTaskResult = tasksNotifier.upsertTask(
            taskProperties,
            addToTop: true,
          );

          final state = container.read(tasksNotifierProvider(fakeTaskView)).valueOrNull;

          expect(state?.first.id, isEmpty);
          expect(state?.first.name, 'Test');
          expect(state?.first.status, TaskStatus.todo);

          /// hide text field after the task is successfully added.
          final textFieldVisibility = container.read(isTaskTextInputFieldVisibleProvider);
          expect(textFieldVisibility, isFalse);

          verify(() => mockTaskUseCase.upsertTask(taskProperties)).called(1);

          await addTaskResult;

          final stateAfterUpdate =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

          expect(stateAfterUpdate, previousState);
        },
        skip: 'TODO: fix this test',
      );

      test(
        'should call insertItem when addToTop is true',
        () async {
          final taskToReturn = TaskEntity(
            createdAt: fakeDateTime,
            updatedAt: fakeDateTime,
            id: 'task-id-0',
            name: 'Test',
            status: TaskStatus.todo,
          );

          when(() => mockTaskUseCase.upsertTask(any())).thenAnswer(
            (_) async => Success(taskToReturn),
          );

          when(() => mockGlobalKey.currentState?.insertItem(any())).thenReturn(null);

          final container = createContainer(
            overrides: [
              taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
            ],
          );

          final tasksNotifier = container.read(tasksNotifierProvider(fakeTaskView).notifier)
            ..setAnimatedListKey(mockGlobalKey);

          const taskProperties = TaskEntity(
            name: 'Test',
            status: TaskStatus.todo,
          );

          await tasksNotifier.upsertTask(taskProperties, addToTop: true);

          verify(() => mockGlobalKey.currentState?.insertItem(0)).called(1);
        },
      );

      test(
        'should not call insertItem when addToTop is false',
        () async {
          final taskToReturn = TaskEntity(
            createdAt: fakeDateTime,
            updatedAt: fakeDateTime,
            id: 'task-id-0',
            name: 'Test',
            status: TaskStatus.todo,
          );

          when(() => mockTaskUseCase.upsertTask(any())).thenAnswer(
            (_) async => Success(taskToReturn),
          );

          when(() => mockGlobalKey.currentState?.insertItem(any())).thenReturn(null);

          final container = createContainer(
            overrides: [
              taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
            ],
          );

          final tasksNotifier = container.read(tasksNotifierProvider(fakeTaskView).notifier)
            ..setAnimatedListKey(mockGlobalKey);

          const taskProperties = TaskEntity(
            name: 'Test',
            status: TaskStatus.todo,
          );

          await tasksNotifier.upsertTask(taskProperties);

          verifyNever(() => mockGlobalKey.currentState?.insertItem(any()));
        },
      );
    },
  );

  group(
    'toggleCheckbox',
    () {
      late List<TaskEntity> initialTasks;

      setUp(() {
        initialTasks = [
          TaskEntity(
            createdAt: fakeDateTime,
            updatedAt: fakeDateTime,
            id: 'task-id-1',
            name: 'Task 1',
            status: TaskStatus.todo,
          ),
          TaskEntity(
            createdAt: fakeDateTime,
            updatedAt: fakeDateTime,
            id: 'task-id-2',
            name: 'Task 2',
            status: TaskStatus.todo,
          ),
          TaskEntity(
            createdAt: fakeDateTime,
            updatedAt: fakeDateTime,
            id: 'task-id-3',
            name: 'Task 3',
            status: TaskStatus.todo,
          ),
        ];
      });

      test(
        'should optimistically update state and keep the update after API success',
        () async {
          final updatedTask = initialTasks[1].copyWith(status: TaskStatus.done);

          when(() => mockTaskUseCase.upsertTask(any())).thenAnswer(
            (_) async => Success(updatedTask),
          );

          when(() => mockGlobalKey.currentState?.insertItem(any())).thenReturn(null);

          final container = createContainer(
            overrides: [
              taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
            ],
          );

          final tasksNotifier = container.read(tasksNotifierProvider(fakeTaskView).notifier)
            ..setAnimatedListKey(mockGlobalKey)
            ..updateState(initialTasks);

          final toggleResult = tasksNotifier.toggleCheckbox(1, TaskStatus.done);

          // Verify optimistic update
          final stateAfterOptimisticUpdate =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

          expect(stateAfterOptimisticUpdate?[1].status, TaskStatus.done);
          expect(stateAfterOptimisticUpdate?[1].id, 'task-id-2');
          expect(stateAfterOptimisticUpdate?[0].status, TaskStatus.todo);
          expect(stateAfterOptimisticUpdate?[2].status, TaskStatus.todo);

          // Verify API call
          verify(() => mockTaskUseCase.upsertTask(any())).called(1);

          // Verify insertItem is not called since addToTop is false by default
          verifyNever(() => mockGlobalKey.currentState?.insertItem(any()));

          await toggleResult;

          // Verify final state
          final finalState =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

          expect(finalState?[1].status, TaskStatus.done);
          expect(finalState?[1].id, 'task-id-2');
          expect(finalState?[0].status, TaskStatus.todo);
          expect(finalState?[2].status, TaskStatus.todo);
        },
      );

      test(
        'should revert to previous state when API fails',
        () async {
          when(() => mockTaskUseCase.upsertTask(any())).thenAnswer(
            (_) async => const Failure(AppException(exception: '', stackTrace: StackTrace.empty)),
          );

          when(() => mockGlobalKey.currentState?.insertItem(any())).thenReturn(null);

          final container = createContainer(
            overrides: [
              taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
            ],
          );

          final tasksNotifier = container.read(tasksNotifierProvider(fakeTaskView).notifier)
            ..setAnimatedListKey(mockGlobalKey)
            ..updateState(initialTasks);

          final toggleResult = tasksNotifier.toggleCheckbox(1, TaskStatus.done);

          // Verify optimistic update
          final stateAfterOptimisticUpdate =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

          expect(stateAfterOptimisticUpdate?[1].status, TaskStatus.done);
          expect(stateAfterOptimisticUpdate?[1].id, 'task-id-2');
          expect(stateAfterOptimisticUpdate?[0].status, TaskStatus.todo);
          expect(stateAfterOptimisticUpdate?[2].status, TaskStatus.todo);

          // Verify API call
          verify(() => mockTaskUseCase.upsertTask(any())).called(1);

          // Verify insertItem is not called since addToTop is false by default
          verifyNever(() => mockGlobalKey.currentState?.insertItem(any()));

          await toggleResult;

          // Verify state is reverted back
          final finalState =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

          expect(finalState?[1].status, TaskStatus.todo);
          expect(finalState?[1].id, 'task-id-2');
          expect(finalState?[0].status, TaskStatus.todo);
          expect(finalState?[2].status, TaskStatus.todo);
        },
      );
    },
  );
}

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
