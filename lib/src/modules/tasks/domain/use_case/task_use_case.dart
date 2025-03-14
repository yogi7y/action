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
