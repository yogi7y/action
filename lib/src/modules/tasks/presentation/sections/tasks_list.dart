import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/tasks_provider.dart';
import '../widgets/task_tile.dart';

class TasksList extends ConsumerWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tasksProvider).when(
          data: (tasks) {
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ProviderScope(
                  overrides: [
                    scopedTaskProvider.overrideWithValue(task),
                  ],
                  child: const TaskTile(),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
        );
  }
}
