import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_view.dart';
import '../state/tasks_provider.dart';
import '../widgets/task_loading_tile.dart';
import '../widgets/task_tile.dart';

@immutable
class TasksList extends ConsumerWidget {
  const TasksList({
    required this.taskView,
    super.key,
  });

  final TaskView taskView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _animatedListKey = taskView.animatedListKey;

    final _count = ref.watch(totalTasksForViewProvider(taskView)).valueOrNull ?? 0;

    if (_count == 0) {
      return const Center(child: Text('No tasks found'));
    }

    return AnimatedList(
      padding: EdgeInsets.zero,
      key: _animatedListKey,
      initialItemCount: _count,
      itemBuilder: (context, index, animation) {
        final _page = index ~/ 20 + 1;
        final _itemIndex = index % 20;

        final _value = ref.watch(tasksProvider(taskView.copyWithPage(_page)));

        return _value.when(
          data: (tasks) {
            if (_itemIndex >= tasks.length) return const SizedBox.shrink();

            return ProviderScope(
              overrides: [
                scopedTaskProvider.overrideWithValue(tasks[_itemIndex]),
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
            );
          },
          loading: () => const TasksLoadingTile(),
          error: (error, _) => Center(child: Text(error.toString())),
        );
      },
    );

    // return ref.watch(tasksProvider(taskView)).when(
    //       data: (tasks) => AnimatedList(
    //         padding: EdgeInsets.zero,
    //         key: _animatedListKey,
    //         initialItemCount: tasks.length,
    //         itemBuilder: (context, index, animation) => ProviderScope(
    //           overrides: [
    //             scopedTaskProvider.overrideWithValue(tasks[index]),
    //           ],
    //           child: FadeTransition(
    //             opacity: CurvedAnimation(
    //               parent: animation,
    //               curve: const Interval(0.2, 1),
    //             ),
    //             child: SlideTransition(
    //               position: animation.drive(
    //                 Tween(
    //                   begin: const Offset(0, -0.3),
    //                   end: Offset.zero,
    //                 ).chain(
    //                   CurveTween(curve: Curves.easeInOut),
    //                 ),
    //               ),
    //               child: const TaskTile(),
    //             ),
    //           ),
    //         ),
    //       ),
    //       loading: () => const TasksLoadingTile(),
    //       error: (error, _) => Center(child: Text(error.toString())),
    //     );
  }
}
