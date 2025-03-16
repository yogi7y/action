import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/checklist.dart';
import '../../domain/use_case/checklist_use_case.dart';
import '../../domain/use_case/task_use_case.dart';
import 'new_checklist_provider.dart';

final checklistProvider =
    AsyncNotifierProviderFamily<ChecklistNotifier, Checklists, TaskId>(ChecklistNotifier.new);

class ChecklistNotifier extends FamilyAsyncNotifier<Checklists, TaskId> {
  late final ChecklistUseCase _useCase = ref.read(checklistUseCaseProvider);

  @override
  Future<List<ChecklistEntity>> build(TaskId arg) async => _fetchChecklists(arg);

  Future<Checklists> _fetchChecklists(TaskId taskId) async {
    final result = await _useCase.getChecklistsByTaskId(taskId);
    return result.fold(
      onSuccess: (checklists) => checklists,
      onFailure: (error) => throw error,
    );
  }

  Future<void> addChecklist(String checklistTitle) async {
    final previousState = state;
    final createdAt = DateTime.now();
    final updatedAt = createdAt;

    final tempChecklist = ChecklistEntity(
      id: '', // Empty ID for temp item, just like tasks
      taskId: arg,
      title: checklistTitle,
      status: ChecklistStatus.todo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    // Update state and animate
    state = AsyncData([tempChecklist, ...state.valueOrNull ?? []]);
    ref.read(checklistAnimatedListKeyProvider).currentState?.insertItem(0);
    ref.read(newChecklistProvider.notifier).clear();

    try {
      final result = await _useCase.createChecklist(
        ChecklistEntity(
          taskId: arg,
          title: checklistTitle,
          status: ChecklistStatus.todo,
        ),
      );

      await result.fold(
        onSuccess: (checklist) async {
          final currentChecklists = state.valueOrNull ?? [];
          final updatedChecklists = currentChecklists
              .map((item) => item.title == tempChecklist.title ? checklist : item)
              .toList();
          state = AsyncData(updatedChecklists);
        },
        onFailure: (error) async {
          state = previousState;
          throw error;
        },
      );
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> updateChecklist(ChecklistEntity checklist) async {
    final previousState = state;

    state = AsyncData(
      state.valueOrNull?.map((item) {
            return item.id == checklist.id ? checklist : item;
          }).toList() ??
          [],
    );

    try {
      final result = await _useCase.updateChecklist(checklist);

      await result.fold(
        onSuccess: (updatedChecklist) async {
          final currentChecklists = state.valueOrNull ?? [];
          final updatedChecklists = currentChecklists
              .map((item) => item.id == checklist.id ? updatedChecklist : item)
              .toList();

          state = AsyncData(updatedChecklists);
        },
        onFailure: (error) async {
          state = previousState;
          throw error;
        },
      );
    } catch (e) {
      state = previousState;
      rethrow;
    }
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
