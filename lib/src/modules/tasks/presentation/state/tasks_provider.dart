import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';
import '../models/task_view.dart';

final tasksNotifierProvider =
    AsyncNotifierProviderFamily<TasksNotifier, List<TaskEntity>, TaskView>(TasksNotifier.new);

/// [TasksNotifier] is a notifier that contains the list of tasks.
///
/// It should be overridden wherever the tasks are needed.
/// It is responsible to handle listing, pagination, updating state etc for a list of tasks.
/// It acts like a common module for all the task views through the app.
class TasksNotifier extends FamilyAsyncNotifier<List<TaskEntity>, TaskView> {
  late final useCase = ref.read(taskUseCaseProvider);

  @override
  Future<List<TaskEntity>> build(TaskView arg) async {
    return _fetchTasks();
  }

  Future<List<TaskEntity>> _fetchTasks() async {
    final result = await useCase.fetchTasks(arg.operations.filter);

    return result.fold(
      onSuccess: (tasksResult) => tasksResult.results,
      onFailure: (failure) => <TaskEntity>[],
    );
  }

  Future<void> upsertTask(TaskPropertiesEntity task) async {
    final previousState = state.valueOrNull;
    const id = '';
    final now = DateTime.now();

    final tempOptimisticTask = TaskEntity.fromTaskProperties(
      task: task,
      createdAt: now,
      updatedAt: now,
      id: id,
    );

    /// Optimistically update the state.
    state = AsyncData([tempOptimisticTask, ...state.valueOrNull ?? []]);

    final result = await useCase.upsertTask(task: task);

    result.fold(
      onSuccess: (taskResult) {
        // TODO: [Performance] maybe rather than iterating over the entire list, we can do some
        // optimization as mostly the task will be at the top of the list.

        /// The temp optimistic task which we saved in the previous step.
        bool isOptimisticTask(TaskEntity task) =>
            task.id.isEmpty && task.name == tempOptimisticTask.name;

        state = AsyncData(
          state.valueOrNull?.map((e) => isOptimisticTask(e) ? taskResult : e).toList() ?? [],
        );
      },
      onFailure: (failure) {
        state = AsyncData(previousState ?? []);
      },
    );
  }

  @visibleForTesting
  void updateState(List<TaskEntity> newState) => state = AsyncData(newState);
}
