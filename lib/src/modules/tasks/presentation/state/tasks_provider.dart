import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';

final tasksProvider = FutureProvider<List<TaskEntity>>((ref) async {
  final useCase = ref.watch(taskUseCaseProvider);
  final result = await useCase.fetchTasks();

  return result.fold(
    onSuccess: (tasks) => tasks,
    onFailure: (error) => throw error,
  );
});

final scopedTaskProvider = Provider<TaskEntity>(
    (ref) => throw UnimplementedError('Ensure to override scopedTaskProvider'));
