import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';

/// A mixin that provides common task operations like update and delete
/// to be shared between different task-related notifiers.
mixin TaskOperationsMixin<T> {
  // Abstract getters that implementing classes must provide
  TaskUseCase get useCase;
  AsyncValue<T> get getState;
  set getState(AsyncValue<T> value);

  /// Updates a task and handles optimistic UI updates with error rollback
  Future<void> updateTask(TaskEntity task) async {
    final previousState = getState;

    getState = await handleOptimisticUpdate(task);

    try {
      final result = await useCase.updateTask(task);

      await result.fold(
        onSuccess: (updatedTask) async {
          getState = await handleSuccessfulUpdate(updatedTask);
        },
        onFailure: (error) async {
          // Rollback on error
          getState = previousState;
          throw error;
        },
      );
    } catch (e) {
      getState = previousState;
      rethrow;
    }
  }

  /// Deletes a task and handles optimistic UI updates with error rollback
  Future<void> deleteTask(TaskId id) async {
    // final previousState = state;

    // // Let implementing classes handle UI updates
    // state = await handleOptimisticDelete(id);

    // try {
    //   final result = await useCase.deleteTask(id);

    //   await result.fold(
    //     onSuccess: (_) async {
    //       // Let implementing classes handle successful deletion
    //       state = await handleSuccessfulDelete(id);
    //     },
    //     onFailure: (error) async {
    //       // Rollback on error
    //       state = previousState;
    //       throw error;
    //     },
    //   );
    // } catch (e) {
    //   state = previousState;
    //   rethrow;
    // }
  }

  // Template methods to be implemented by classes using this mixin
  Future<AsyncValue<T>> handleOptimisticUpdate(TaskEntity task);
  Future<AsyncValue<T>> handleSuccessfulUpdate(TaskEntity updatedTask);
  Future<AsyncValue<T>> handleOptimisticDelete(TaskId id);
  Future<AsyncValue<T>> handleSuccessfulDelete(TaskId id);
}
