import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logger/logger.dart';
import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';
import '../mixin/tasks_operations_mixin.dart';

typedef TaskDataOrId = ({String? id, TaskEntity? data});

final taskDetailProvider =
    FutureProvider.autoDispose.family<TaskEntity, TaskDataOrId>((ref, dataOrId) async {
  // If we have data, return it directly
  if (dataOrId.data != null) return dataOrId.data!;

  // Otherwise fetch using ID
  if (dataOrId.id != null) {
    final useCase = ref.watch(taskUseCaseProvider);
    final result = await useCase.getTaskById(dataOrId.id!);

    return result.fold(
      onSuccess: (task) => task,
      onFailure: (error) => throw error,
    );
  }

  throw Exception('Either id or data must be provided');
});

class TaskDetailNotifier extends AutoDisposeNotifier<TaskEntity>
    with TaskOperationsMixin<TaskEntity> {
  TaskDetailNotifier(this.task);

  final TaskEntity task;

  @override
  TaskEntity build() => task;

  @override
  Future<AsyncValue<TaskEntity>> handleOptimisticUpdate(TaskEntity task) async {
    return AsyncData(task);
  }

  @override
  Future<AsyncValue<TaskEntity>> handleSuccessfulUpdate(TaskEntity updatedTask) async {
    return AsyncData(updatedTask);
  }

  @override
  Future<AsyncValue<TaskEntity>> handleOptimisticDelete(TaskId id) async {
    throw UnimplementedError('Delete not supported in detail view');
  }

  @override
  Future<AsyncValue<TaskEntity>> handleSuccessfulDelete(TaskId id) async {
    throw UnimplementedError('Delete not supported in detail view');
  }

  @override
  TaskUseCase get useCase => throw UnimplementedError();
}

final taskDetailNotifierProvider = NotifierProvider.autoDispose<TaskDetailNotifier, TaskEntity>(
  () => throw UnimplementedError(),
);
