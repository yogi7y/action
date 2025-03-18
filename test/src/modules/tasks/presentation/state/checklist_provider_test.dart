// ignore_for_file: avoid_implementing_value_types

import 'package:action/src/modules/tasks/domain/entity/checklist.dart';
import 'package:action/src/modules/tasks/domain/use_case/checklist_use_case.dart';
import 'package:action/src/modules/tasks/presentation/state/checklist_provider.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../utils/provider_container.dart';

class MockChecklistUseCase extends Mock implements ChecklistUseCase {}

class FakeChecklistEntity extends Fake implements ChecklistEntity {}

void main() {
  late MockChecklistUseCase mockChecklistUseCase;

  setUpAll(() {
    registerFallbackValue(FakeChecklistEntity());
  });

  setUp(() async {
    mockChecklistUseCase = MockChecklistUseCase();

    // stub when get is called return empty list
    when(() => mockChecklistUseCase.getChecklistsByTaskId(any()))
        .thenAnswer((_) async => const Success([]));
  });

  group('initial state', () {
    test('should fetch checklists from use case for initial state ', () async {
      const taskId = 'task-id-1';
      const checklistItem1 = ChecklistEntity(
        taskId: taskId,
        title: 'Checklist Item 1',
      );

      const checklistItem2 = ChecklistEntity(
        taskId: taskId,
        title: 'Checklist Item 2',
      );

      // stub use case to return success with checklists
      when(() => mockChecklistUseCase.getChecklistsByTaskId(any()))
          .thenAnswer((_) async => const Success([checklistItem1, checklistItem2]));

      final container = createContainer(overrides: [
        checklistUseCaseProvider.overrideWithValue(mockChecklistUseCase),
      ]);

      // build the checklist notifier provider
      await container.read(checklistProvider(taskId).future);

      final state = container.read(checklistProvider(taskId));

      expect(state, isA<AsyncData<Checklists>>());
      expect(state.value, [checklistItem1, checklistItem2]);
    });

    test('handle some error state', () {}, skip: 'TODO: implement');
  });

  group('addChecklist', () {
    test(
      'should optimistically add a checklist at the top and update it again with server response.',
      () async {
        const taskId = 'task-id-1';
        final createdAt = DateTime.now();

        final checklistItem = ChecklistEntity(
          taskId: taskId,
          title: 'Checklist 1',
          createdAt: createdAt,
          updatedAt: createdAt,
        );

        final expectedChecklist = checklistItem.copyWith(id: 'checklist-id-1');

        // stub the upsert method to return success with checklist
        when(() => mockChecklistUseCase.upsertChecklist(any()))
            .thenAnswer((_) async => Success(checklistItem.copyWith(id: 'checklist-id-1')));

        final container = createContainer(overrides: [
          checklistUseCaseProvider.overrideWithValue(mockChecklistUseCase),
        ]);

        // loading provider state.
        await container.read(checklistProvider(taskId).future);

        final result = container.read(checklistProvider(taskId).notifier).upsertChecklist(
              ChecklistEntity.newChecklist(checklistItem.title).copyWith(createdAt: createdAt),
            );

        // verify optimistic update and id is not present
        expect(container.read(checklistProvider(taskId)).requireValue, [checklistItem]);
        expect(container.read(checklistProvider(taskId)).value?.first.id, isNull);

        // verify use case is called
        verify(() => mockChecklistUseCase.upsertChecklist(any())).called(1);

        // await the result
        await result;

        // compare result and check id exists.
        expect(container.read(checklistProvider(taskId)).requireValue, [expectedChecklist]);
        expect(container.read(checklistProvider(taskId)).value?.first.id, 'checklist-id-1');
      },
    );

    test('should add checklist at top in case of existing data', () async {
      const taskId = 'task-id-1';
      final createdAt = DateTime.now();

      // stub api to return multiple checklists
      final checklists = [
        ChecklistEntity(
          taskId: taskId,
          title: 'Checklist 1',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
        ChecklistEntity(
          taskId: taskId,
          title: 'Checklist 2',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
        ChecklistEntity(
          taskId: taskId,
          title: 'Checklist 3',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
      ];

      when(() => mockChecklistUseCase.getChecklistsByTaskId(any()))
          .thenAnswer((_) async => Success(checklists));

      when(() => mockChecklistUseCase.upsertChecklist(any()))
          .thenAnswer((_) async => Success(checklists.first.copyWith(
                id: 'checklist-id-4',
                title: 'Checklist 4',
              )));

      final container = createContainer(overrides: [
        checklistUseCaseProvider.overrideWithValue(mockChecklistUseCase),
      ]);

      // loading provider state.
      await container.read(checklistProvider(taskId).future);

      final result = container.read(checklistProvider(taskId).notifier).upsertChecklist(
            ChecklistEntity.newChecklist('Checklist 4').copyWith(createdAt: createdAt),
          );

      // verify optimistic update
      expect(container.read(checklistProvider(taskId)).requireValue.length, 4);
      expect(container.read(checklistProvider(taskId)).requireValue.first.title, 'Checklist 4');

      // verify use case is called
      verify(() => mockChecklistUseCase.upsertChecklist(any())).called(1);

      // await the result
      await result;

      // verify state is updated
      expect(container.read(checklistProvider(taskId)).requireValue.length, 4);
      expect(container.read(checklistProvider(taskId)).requireValue.first.title, 'Checklist 4');
      expect(container.read(checklistProvider(taskId)).requireValue.first.id, 'checklist-id-4');
    });

    test('should revert the optimistic update if api fails', () async {
      const taskId = 'task-id-1';
      // stub api failure.
      when(() => mockChecklistUseCase.upsertChecklist(any())).thenAnswer((_) async => const Failure(
          AppException(exception: 'Failed to upsert checklist', stackTrace: StackTrace.empty)));

      final container = createContainer(overrides: [
        checklistUseCaseProvider.overrideWithValue(mockChecklistUseCase),
      ]);

      // loading provider state.
      await container.read(checklistProvider(taskId).future);

      final now = DateTime.now();

      final result = container.read(checklistProvider(taskId).notifier).upsertChecklist(
            ChecklistEntity.newChecklist('Checklist 1').copyWith(createdAt: now),
          );

      final optimisticChecklistItem = ChecklistEntity(
        taskId: taskId,
        title: 'Checklist 1',
        createdAt: now,
        updatedAt: now,
      );

      // verify optimistic update
      expect(container.read(checklistProvider(taskId)).requireValue, [optimisticChecklistItem]);
      expect(container.read(checklistProvider(taskId)).value?.first.id, isNull);

      // verify use case is called
      verify(() => mockChecklistUseCase.upsertChecklist(any())).called(1);

      // await the result
      await result;

      // verify state is reverted
      expect(container.read(checklistProvider(taskId)).requireValue, isEmpty);
    });
  });

  group(
    'updateChecklist',
    () {
      const taskId = 'task-id-1';
      final createdAt = DateTime.now();

      // add default 4 checklists and stub.
      final checklists = [
        ChecklistEntity(
          id: 'checklist-id-1',
          taskId: taskId,
          title: 'Checklist 1',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
        ChecklistEntity(
          id: 'checklist-id-2',
          taskId: taskId,
          title: 'Checklist 2',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
        ChecklistEntity(
          id: 'checklist-id-3',
          taskId: taskId,
          title: 'Checklist 3',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
        ChecklistEntity(
          id: 'checklist-id-4',
          taskId: taskId,
          title: 'Checklist 4',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
      ];

      setUp(() async {
        when(() => mockChecklistUseCase.getChecklistsByTaskId(any()))
            .thenAnswer((_) async => Success(checklists));
      });

      test('should update checklist at given index', () async {
        final container = createContainer(overrides: [
          checklistUseCaseProvider.overrideWithValue(mockChecklistUseCase),
        ]);

        final updatedChecklist = checklists[2].copyWith(title: 'Updated Checklist');

        when(() => mockChecklistUseCase.upsertChecklist(any()))
            .thenAnswer((_) async => Success(updatedChecklist));

        // loading provider state.
        await container.read(checklistProvider(taskId).future);

        final result = container.read(checklistProvider(taskId).notifier).upsertChecklist(
              updatedChecklist,
              indexProp: 2,
            );

        // verify optimistic update
        expect(container.read(checklistProvider(taskId)).requireValue, [
          checklists[0],
          checklists[1],
          updatedChecklist,
          checklists[3],
        ]);

        // verify use case is called
        verify(() => mockChecklistUseCase.upsertChecklist(any())).called(1);

        // await the result
        await result;

        // verify state is updated
        expect(container.read(checklistProvider(taskId)).requireValue, [
          checklists[0],
          checklists[1],
          updatedChecklist,
          checklists[3],
        ]);
      });

      test('should revert update if api fails', () async {
        final container = createContainer(overrides: [
          checklistUseCaseProvider.overrideWithValue(mockChecklistUseCase),
        ]);

        final updatedChecklist = checklists[2].copyWith(title: 'Updated Checklist');

        when(() => mockChecklistUseCase.upsertChecklist(any())).thenAnswer(
          (_) async => const Failure(
              AppException(exception: 'Failed to upsert checklist', stackTrace: StackTrace.empty)),
        );

        // loading provider state.
        await container.read(checklistProvider(taskId).future);

        final result = container.read(checklistProvider(taskId).notifier).upsertChecklist(
              updatedChecklist,
              indexProp: 2,
            );

        // verify optimistic update
        expect(container.read(checklistProvider(taskId)).requireValue, [
          checklists[0],
          checklists[1],
          updatedChecklist,
          checklists[3],
        ]);

        // verify use case is called
        verify(() => mockChecklistUseCase.upsertChecklist(any())).called(1);

        // await the result
        await result;

        // verify state is reverted
        expect(container.read(checklistProvider(taskId)).requireValue, [
          checklists[0],
          checklists[1],
          checklists[2],
          checklists[3],
        ]);
      });

      test('should update when index is not provided but the item is present', () async {
        final container = createContainer(overrides: [
          checklistUseCaseProvider.overrideWithValue(mockChecklistUseCase),
        ]);

        final updatedChecklist = checklists[2].copyWith(title: 'Updated Checklist');

        when(() => mockChecklistUseCase.upsertChecklist(any()))
            .thenAnswer((_) async => Success(updatedChecklist));

        // loading provider state.
        await container.read(checklistProvider(taskId).future);

        final result =
            container.read(checklistProvider(taskId).notifier).upsertChecklist(updatedChecklist);

        // verify optimistic update
        expect(container.read(checklistProvider(taskId)).requireValue, [
          checklists[0],
          checklists[1],
          updatedChecklist,
          checklists[3],
        ]);

        // verify use case is called
        verify(() => mockChecklistUseCase.upsertChecklist(any())).called(1);

        // await the result
        await result;

        // verify state is updated
        expect(container.read(checklistProvider(taskId)).requireValue, [
          checklists[0],
          checklists[1],
          updatedChecklist,
          checklists[3],
        ]);
      });
    },
  );
}
