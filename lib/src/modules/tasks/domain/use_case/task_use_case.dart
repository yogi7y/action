import 'package:core_y/core_y.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../filter/domain/entity/filter.dart';
import '../../data/repository/supabase_task_repository.dart';
import '../entity/task_entity.dart';
import '../repository/task_repository.dart';

final taskUseCaseProvider =
    Provider<TaskUseCase>((ref) => TaskUseCase(ref.watch(taskRepositoryProvider)));

/// List of tasks wrapped within [PaginatedResponse] and [Result] to get tasks + total count
typedef AsyncTaskPaginatedResult = Future<Result<PaginatedResponse<TaskEntity>, AppException>>;

/// Single [TaskEntity] wrapped within [Result]
typedef AsyncTaskResult = Future<Result<TaskEntity, AppException>>;

/// TaskId is the id of the task.
typedef TaskId = String;

class TaskUseCase {
  const TaskUseCase(this.repository);

  final TaskRepository repository;

  Future<Result<TaskEntity, AppException>> createTask(TaskEntity task) {
    task.validate();
    return repository.createTask(task);
  }

  AsyncTaskPaginatedResult fetchTasks(Filter filter) async {
    final fetchTaskResult = await repository.fetchTasks(filter: filter);

    if (fetchTaskResult is Failure) return fetchTaskResult;

    final tasks = fetchTaskResult.valueOrNull?.results ?? [];

    final sortedTasksResult = sortByCreatedAt(tasks);

    if (sortedTasksResult is Failure) return fetchTaskResult;

    final sortedTasks = sortedTasksResult.valueOrNull ?? [];

    final result = fetchTaskResult.valueOrNull?.copyWith(results: sortedTasks);

    return Success(result!);
  }

  /// Returns the index at which a new task should be inserted to maintain
  /// descending order by createdAt (newest tasks at the top).
  int getInsertIndexForTask(List<TaskEntity> tasks, TaskEntity task) {
    var left = 0;
    var right = tasks.length;

    while (left < right) {
      final mid = left + (right - left) ~/ 2;

      // For descending order: if the task at mid is newer than or equal to the new task,
      // search in the right half, otherwise search in the left half
      if (tasks[mid].createdAt!.isAfter(task.createdAt!) ||
          tasks[mid].createdAt!.isAtSameMomentAs(task.createdAt!)) {
        left = mid + 1;
      } else {
        right = mid;
      }
    }

    return left;
  }

  /// Sorts the entire passed in array of tasks by the createdAt field.
  Result<List<TaskEntity>, AppException> sortByCreatedAt(List<TaskEntity> tasks) {
    try {
      final sortedTasks = tasks..sort((a, b) => a.compareTo(b));

      return Success(sortedTasks);
    } catch (e, stackTrace) {
      return Failure(AppException(exception: e, stackTrace: stackTrace));
    }
  }

  Future<Result<TaskEntity, AppException>> upsertTask(TaskEntity task) {
    task.validate();
    return repository.upsertTask(task);
  }
}
