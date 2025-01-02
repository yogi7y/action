import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';

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

final scopedTaskDetailProvider = Provider<TaskEntity>((ref) => throw UnimplementedError());
