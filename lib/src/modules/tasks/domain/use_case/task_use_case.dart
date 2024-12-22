import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/task_repository.dart';

class TaskUseCase {
  const TaskUseCase(this.repository);

  final TaskRepository repository;

  AsyncTaskResult fetchTasks() => repository.fetchTasks();
}

final taskUseCaseProvider =
    Provider<TaskUseCase>((ref) => TaskUseCase(ref.watch(taskRepositoryProvider)));
