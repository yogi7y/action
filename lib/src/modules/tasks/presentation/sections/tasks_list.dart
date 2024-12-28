import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/tasks_provider.dart';
import '../widgets/task_tile.dart';

@immutable
class SliverTasksList extends ConsumerWidget {
  const SliverTasksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _animatedListKey = ref.watch(tasksProvider.notifier).animatedListKey;

    return ref.watch(tasksProvider).when(
          data: (tasks) => SliverAnimatedList(
            key: _animatedListKey,
            initialItemCount: tasks.length,
            itemBuilder: (context, index, animation) => ProviderScope(
              overrides: [
                scopedTaskProvider.overrideWithValue(tasks[index]),
              ],
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.2, 1),
                ),
                child: SlideTransition(
                  position: animation.drive(
                    Tween(
                      begin: const Offset(0, -0.3),
                      end: Offset.zero,
                    ).chain(
                      CurveTween(curve: Curves.easeInOut),
                    ),
                  ),
                  child: const TaskTile(),
                ),
              ),
            ),
          ),
          loading: () =>
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
          error: (error, _) => SliverFillRemaining(child: Center(child: Text(error.toString()))),
        );
  }
}
