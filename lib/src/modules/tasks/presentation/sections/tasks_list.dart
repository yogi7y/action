import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/tasks_provider.dart';
import '../widgets/task_tile.dart';

class SliverTasksList extends ConsumerWidget {
  const SliverTasksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tasksProvider).when(
          data: (tasks) => SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final task = tasks[index];
                return ProviderScope(
                  overrides: [
                    scopedTaskProvider.overrideWithValue(task),
                  ],
                  child: const TaskTile(),
                );
              },
              childCount: tasks.length,
            ),
          ),
          loading: () =>
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
          error: (error, _) => SliverFillRemaining(child: Center(child: Text(error.toString()))),
        );
  }
}
