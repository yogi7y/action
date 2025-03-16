import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task_entity.dart';
import '../../domain/use_case/task_use_case.dart';

typedef TaskDataOrId = ({String? id, TaskEntity? data});
typedef UpdateTaskCallback = TaskEntity Function(TaskEntity task);

/// Provider to render the task detail screen.
/// Internally it checks if data is provided, it returns that.
/// If not, it checks for id to get data from server.
/// If both are not provided, it throws an error.
final taskDetailProvider =
    FutureProvider.autoDispose.family<TaskEntity, TaskDataOrId>((ref, dataOrId) async {
  if (dataOrId.data != null) return dataOrId.data!;

  // Otherwise fetch using ID
  if (dataOrId.id != null) {
    throw UnimplementedError('Fetching task by id is not implemented');
  }

  throw Exception('Either id or data must be provided');
});

class TaskDetailNotifier extends AutoDisposeNotifier<TaskEntity> {
  TaskDetailNotifier(this.task);

  final TaskEntity task;

  @override
  TaskEntity build() => task;

  /// Updates the task using a callback function that receives the current state
  /// and returns a new state.
  ///
  /// Example usage:
  /// ```dart
  /// notifier.updateTask((task) => task.copyWith(name: 'New name'));
  /// ```
  ///
  /// This method performs an optimistic update, immediately updating the UI
  /// with the new task data, then makes the API call to persist the changes.
  /// If the API call fails, it reverts to the original state.
  ///
  /// Returns a Future that completes when the API call is done.
  Future<void> updateTask(UpdateTaskCallback callback) async {
    // Store the original state for potential rollback
    final originalTask = state;

    // Apply the callback to get the updated task
    final updatedTask = callback(state);

    // Optimistically update the state
    state = updatedTask;

    // Get the task use case
    final useCase = ref.read(taskUseCaseProvider);

    // Make the API call
    final result = await useCase.upsertTask(updatedTask);

    // Handle the result
    result.fold(
      onSuccess: (taskResult) {
        // Update with the result from the server if needed
        state = taskResult;
      },
      onFailure: (_) {
        // Revert to the original state on failure
        state = originalTask;
      },
    );
  }
}

/// This provider is meant to be overridden with a specific task instance.
/// It should not be used directly without an override.
final taskDetailNotifierProvider = NotifierProvider.autoDispose<TaskDetailNotifier, TaskEntity>(
  () => throw UnimplementedError('This provider must be overridden with a specific task'),
);
