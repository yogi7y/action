import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:riverpod/src/notifier.dart';

import '../../domain/entity/task_entity.dart';
import '../../domain/use_case/task_use_case.dart';

/// Base mixin containing common task operation logic
mixin BaseTaskOperationsMixin<State extends Object> {
  TaskUseCase get useCase;
  State get currentState;
  void updateState(State newState);
  // TaskView get currentTaskView;

  @protected
  Future<void> updateTask({
    required TaskEntity task,
    required int index,

    /// If true, only the optimistic update will be performed and no network call will be made.
    bool onlyOptimisticUpdate = false,
  }) async {
    final previousState = currentState;

    updateState(handleOptimisticUpdate(task, index));

    if (onlyOptimisticUpdate) return;

    try {
      final result = await useCase.upsertTask(task);

      await result.fold(
        onSuccess: (updatedTask) async {
          updateState(await handleSuccessfulUpdate(updatedTask));
        },
        onFailure: (error) async {
          updateState(previousState);
          throw error;
        },
      );
    } catch (e) {
      updateState(previousState);
      rethrow;
    }
  }

  State handleOptimisticUpdate(TaskEntity task, int index);
  FutureOr<State> handleSuccessfulUpdate(TaskEntity updatedTask);
}

/// Mixin for AsyncNotifier classes
mixin AsyncTaskOperationsMixin<T extends Object> on AsyncNotifier<T>
    implements BaseTaskOperationsMixin<T> {
  @override
  T get currentState => state.valueOrNull!;

  @override
  void updateState(T newState) => state = AsyncData(newState);
}

/// Mixin for regular Notifier classes
// ignore: invalid_use_of_internal_member
mixin NotifierTaskOperationsMixin<T extends Object> on NotifierBase<T>
    implements BaseTaskOperationsMixin<T> {
  @override
  T get currentState => state;

  @override
  void updateState(T newState) => state = newState;
}

// /// Mixin for FamilyAsyncNotifier classes
mixin FamilyAsyncTaskOperationsMixin<T extends Object, Arg> on FamilyAsyncNotifier<T, Arg>
    implements BaseTaskOperationsMixin<T> {
  @override
  T get currentState => state.valueOrNull!;

  @override
  void updateState(T newState) => state = AsyncData(newState);
}
