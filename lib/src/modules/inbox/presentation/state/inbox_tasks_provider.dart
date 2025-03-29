import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../tasks/data/repository/supabase_task_repository.dart';
import '../../../tasks/domain/entity/task_entity.dart';

final inboxTasksProvider = AsyncNotifierProvider<InboxTasksNotifier, List<TaskEntity>>(
  InboxTasksNotifier.new,
);

class InboxTasksNotifier extends AsyncNotifier<List<TaskEntity>> {
  late final _tasksRepository = ref.watch(taskRepositoryProvider);

  @override
  Future<List<TaskEntity>> build() async {
    final result = await _tasksRepository.fetchUnorganisedTasks(fetchInbox: true);

    if (result is Failure) {
      return [];
    }

    return result.valueOrNull ?? [];
  }
}

final unorganisedTasksProvider = AsyncNotifierProvider<UnorganisedTasksNotifier, List<TaskEntity>>(
  UnorganisedTasksNotifier.new,
);

class UnorganisedTasksNotifier extends AsyncNotifier<List<TaskEntity>> {
  late final _tasksRepository = ref.watch(taskRepositoryProvider);

  @override
  Future<List<TaskEntity>> build() async {
    final result = await _tasksRepository.fetchUnorganisedTasks();

    if (result is Failure) {
      return [];
    }

    return result.valueOrNull ?? [];
  }
}
