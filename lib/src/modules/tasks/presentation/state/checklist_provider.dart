import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/checklist.dart';
import '../../domain/use_case/checklist_use_case.dart';
import '../../domain/use_case/task_use_case.dart';
import 'new_checklist_provider.dart';

final checklistProvider =
    AsyncNotifierProviderFamily<ChecklistNotifier, Checklists, TaskId>(ChecklistNotifier.new);

class ChecklistNotifier extends FamilyAsyncNotifier<Checklists, TaskId> {
  late final _useCase = ref.read(checklistUseCaseProvider);

  @override
  Future<List<ChecklistEntity>> build(TaskId arg) async => _fetchChecklists(arg);

  Future<Checklists> _fetchChecklists(TaskId taskId) async {
    final result = await _useCase.getChecklistsByTaskId(taskId);
    return result.fold(
      onSuccess: (checklists) => checklists,
      onFailure: (error) => throw error,
    );
  }

  Future<void> upsertChecklist(
    ChecklistEntity checklist, {
    /// pass in when updating an existing checklist
    int? indexProp,
  }) async {
    final previousState = state;

    /// storing the value in case we wanna revert it back.
    final storeTextFieldValue = ref.read(newChecklistProvider.notifier).controller.text;

    final now = checklist.createdAt ?? DateTime.now();

    final isNewChecklist = checklist.id == null;

    final tempOptimisticChecklist = checklist.copyWith(
      taskId: checklist.taskId.isEmpty ? arg : checklist.taskId,
      createdAt: checklist.createdAt ?? now,
      updatedAt: checklist.updatedAt ?? now,
    );

    // do optimistic update
    if (isNewChecklist) {
      state = AsyncData([tempOptimisticChecklist, ...(state.valueOrNull ?? [])]);
      ref.read(checklistAnimatedListKeyProvider).currentState?.insertItem(0);
    } else {
      // find the index of the checklist
      final index =
          indexProp ?? state.valueOrNull?.indexWhere((element) => element.id == checklist.id);

      if (index != null) {
        state.valueOrNull?[index] = tempOptimisticChecklist;
        state = AsyncData(state.valueOrNull ?? []);
      }
    }

    // clear the text field.
    ref.read(newChecklistProvider.notifier).controller.clear();

    // make api call
    final result = await _useCase.upsertChecklist(tempOptimisticChecklist);

    result.fold(
      onSuccess: (checklist) {
        // update the temp state with server response
        // remove the temp optimistic checklist item and replace it with the server response
        // since it might mostly be the topmost item, we could probably use index to check. If it's not the
        // top most item for some reason, we will iterate and verify.
        final topMostItem = state.requireValue.first;

        // mostly will be true if we're creating a new checklist
        if (topMostItem.id == null && topMostItem.title == checklist.title) {
          state.requireValue.removeAt(0);
          state = AsyncData([checklist, ...state.requireValue]);
        } else {
          // if it's not the topmost item, we will iterate and verify
          for (var i = 0; i < state.requireValue.length; i++) {
            if (state.requireValue[i].id == checklist.id) {
              state.requireValue.removeAt(i);
              state.requireValue.insert(i, checklist);
              ref.notifyListeners();
            }
          }
        }
      },
      onFailure: (error) {
        // revert to previous state
        state = previousState;

        // revert the text field value.
        ref.read(newChecklistProvider.notifier).controller.text = storeTextFieldValue;
      },
    );
  }
}

// Global key for AnimatedList
final checklistAnimatedListKeyProvider = Provider<GlobalKey<SliverAnimatedListState>>(
  (ref) => GlobalKey<SliverAnimatedListState>(debugLabel: 'Checklist Animated List Key'),
);

// Provider for currently editing checklist
final scopedChecklistProvider = Provider<ChecklistEntity>(
  (ref) => throw UnimplementedError('Ensure to override scopedChecklistProvider'),
);
