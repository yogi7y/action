import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/paginated_response.dart';
import '../entity/task.dart';
import '../entity/task_view_type.dart';
import '../repository/task_repository.dart';

typedef TaskId = String;
typedef Tasks = List<TaskEntity>;
typedef TaskResult = Result<Tasks, AppException>;
typedef AsyncTasksResult = Future<Result<PaginatedResponse<TaskEntity>, AppException>>;
typedef AsyncTaskResult = Future<Result<TaskEntity, AppException>>;
typedef AsyncTaskCountResult = Future<Result<int, AppException>>;

class TaskUseCase {
  const TaskUseCase(this.repository);

  final TaskRepository repository;

  AsyncTasksResult fetchTasks(
    TaskQuerySpecification querySpecification, {
    required int page,
    required int pageSize,
  }) =>
      repository.fetchTasks(
        querySpecification,
        page: page,
        pageSize: pageSize,
      );

  AsyncTaskCountResult getTotalTasks(TaskQuerySpecification spec) => repository.getTotalTasks(spec);

  AsyncTaskResult getTaskById(TaskId id) => repository.getTaskById(id);

  Future<Result<TaskEntity, AppException>> createTask(TaskPropertiesEntity task) =>
      repository.createTask(task);

  Future<Result<TaskEntity, AppException>> updateTask(TaskEntity task) =>
      repository.updateTask(task);
}

final taskUseCaseProvider =
    Provider<TaskUseCase>((ref) => TaskUseCase(ref.watch(taskRepositoryProvider)));
