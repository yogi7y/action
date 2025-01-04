import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';
import '../mixin/tasks_operations_mixin.dart';
import 'task_filter_provider.dart';
import 'tasks_provider.dart';

typedef TaskDataOrId = ({String? id, TaskEntity? data});
typedef UpdateTaskCallback = TaskEntity Function(TaskEntity task);

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
    with BaseTaskOperationsMixin<TaskEntity>, NotifierTaskOperationsMixin<TaskEntity> {
  TaskDetailNotifier(this.task);

  final TaskEntity task;

  @override
  TaskEntity build() {
    listenSelf(_onChanged);
    return task;
  }

  Future<void> _onChanged(TaskEntity? previous, TaskEntity? current) async {
    if (current == null) return;

    final _currentFilter = ref.read(selectedTaskFilterProvider);

    await ref.read(tasksProvider(_currentFilter).notifier).updateTask(
          task: current,
          index: 0,
          onlyOptimisticUpdate: true,
        );
  }

  @override
  TaskEntity handleOptimisticUpdate(TaskEntity task, int index) => task;

  @override
  FutureOr<TaskEntity> handleSuccessfulUpdate(TaskEntity updatedTask) => updatedTask;

  Future<void> updateTaskWithCallback(UpdateTaskCallback update) async {
    final _task = update(task);

    await super.updateTask(task: _task, index: 0);
  }

  @override
  TaskUseCase get useCase => ref.read(taskUseCaseProvider);
}

final taskDetailNotifierProvider = NotifierProvider.autoDispose<TaskDetailNotifier, TaskEntity>(
  () => throw UnimplementedError(),
);
