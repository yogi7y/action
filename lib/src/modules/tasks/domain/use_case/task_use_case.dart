import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../filter/domain/entity/filter.dart';
import '../../data/repository/supabase_task_repository.dart';
import '../entity/task.dart';
import '../repository/task_repository.dart';

/// TaskId is the id of the task.
typedef TaskId = String;

/// Single [TaskEntity] wrapped within [Result]
typedef AsyncTaskResult = Future<Result<TaskEntity, AppException>>;

/// List of tasks wrapped within [PaginatedResponse] and [Result] to get tasks + total count
typedef AsyncTaskPaginatedResult = Future<Result<PaginatedResponse<TaskEntity>, AppException>>;

class TaskUseCase {
  const TaskUseCase(this.repository);

  final TaskRepository repository;

  AsyncTaskPaginatedResult fetchTasks(Filter filter) => repository.fetchTasks(filter: filter);

  Future<Result<TaskEntity, AppException>> createTask(TaskEntity task) {
    task.validate();
    return repository.createTask(task);
  }

  Future<Result<TaskEntity, AppException>> upsertTask(TaskEntity task) {
    task.validate();
    return repository.upsertTask(task);
  }
}

final taskUseCaseProvider =
    Provider<TaskUseCase>((ref) => TaskUseCase(ref.watch(taskRepositoryProvider)));
