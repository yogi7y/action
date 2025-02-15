// ignore_for_file: avoid_implementing_value_types

import 'package:action/src/modules/tasks/domain/entity/task.dart';
import 'package:action/src/modules/tasks/domain/entity/task_status.dart';
import 'package:action/src/modules/tasks/domain/use_case/task_use_case.dart';
import 'package:action/src/modules/tasks/presentation/models/task_view.dart';
import 'package:action/src/modules/tasks/presentation/state/new_task_provider.dart';
import 'package:action/src/modules/tasks/presentation/state/tasks_provider.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskUseCase extends Mock implements TaskUseCase {}

class FakeTaskView extends Fake implements TaskView {}

class FakeDateTime extends Fake implements DateTime {}

class FakeTaskPropertiesEntity extends Fake implements TaskPropertiesEntity {}

void main() {
  late MockTaskUseCase mockTaskUseCase;
  late FakeDateTime fakeDateTime;
  late FakeTaskView fakeTaskView;

  setUpAll(
    () {
      registerFallbackValue(FakeTaskView());
      registerFallbackValue(FakeDateTime());
      registerFallbackValue(FakeTaskPropertiesEntity());
    },
  );

  setUp(() {
    mockTaskUseCase = MockTaskUseCase();
    fakeDateTime = FakeDateTime();
    fakeTaskView = FakeTaskView();
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

          final container = createContainer(
            overrides: [
              taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
              isTaskTextInputFieldVisibleProvider.overrideWith((previous) => true),
            ],
          );

          final tasksNotifier = container.read(tasksNotifierProvider(fakeTaskView).notifier);

          const taskProperties = TaskPropertiesEntity(
            name: 'Test',
            status: TaskStatus.todo,
          );

          final addTaskResult = tasksNotifier.upsertTask(taskProperties);

          final state =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

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

          const taskProperties = TaskPropertiesEntity(
            name: 'Test',
            status: TaskStatus.todo,
          );

          final previousState =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

          final addTaskResult = tasksNotifier.upsertTask(taskProperties);

          final state =
              container.read(tasksNotifierProvider(fakeTaskView).select((value) => value.value));

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
