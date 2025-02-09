import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/placeholder_widget.dart';
import '../models/task_view.dart';
import '../state/scoped_task_provider.dart';
import '../state/tasks_provider.dart';
import '../widgets/task_loading_tile.dart';
import '../widgets/task_tile.dart';

@immutable
class TasksListView extends ConsumerWidget {
  const TasksListView({
    required this.taskView,
    super.key,
  });

  final TaskView taskView;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(tasksNotifierProvider(taskView)).when(
            error: (error, _) => PlaceholderWidget(text: error.toString()),
            loading: () => const _TaskListLoadingState(),
            data: (tasks) => _TaskListViewDataState(taskView: taskView),
          );
}

@immutable
class _TaskListViewDataState extends ConsumerStatefulWidget {
  const _TaskListViewDataState({
    required this.taskView,
  });

  final TaskView taskView;

  @override
  ConsumerState<_TaskListViewDataState> createState() => _TaskListDataStateState();
}

class _TaskListDataStateState extends ConsumerState<_TaskListViewDataState>
    with AutomaticKeepAliveClientMixin {
  late final _animatedListKey = GlobalKey<AnimatedListState>();

  /// For easier `taskView` access rather than writing `widget.taskView` each time.
  late final _taskView = widget.taskView;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tasks = ref.watch(tasksNotifierProvider(_taskView)).valueOrNull ?? [];

    return RefreshIndicator(
      onRefresh: () async {},
      child: Stack(
        children: [
          AnimatedList(
            padding: EdgeInsets.zero,
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
                    ).chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: const TaskTile(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _TaskListLoadingState extends StatelessWidget {
  const _TaskListLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        10,
        (index) => const TasksLoadingTile(),
      ),
    );
  }
}
