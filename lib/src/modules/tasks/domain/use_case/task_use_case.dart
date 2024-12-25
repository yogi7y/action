import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/task.dart';
import '../repository/task_repository.dart';

typedef Tasks = List<TaskEntity>;
typedef TaskResult = Result<Tasks, AppException>;
typedef AsyncTaskResult = Future<TaskResult>;

class TaskUseCase {
  const TaskUseCase(this.repository);

  final TaskRepository repository;

  AsyncTaskResult fetchTasks() => repository.fetchTasks();

  Future<Result<TaskEntity, AppException>> createTask(TaskPropertiesEntity task) =>
      repository.createTask(task);
}

final taskUseCaseProvider =
    Provider<TaskUseCase>((ref) => TaskUseCase(ref.watch(taskRepositoryProvider)));
