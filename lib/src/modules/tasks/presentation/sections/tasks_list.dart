import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logger/logger.dart';
import '../../../../shared/placeholder_widget.dart';
import '../models/task_view.dart';
import '../state/task_filter_provider.dart';
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
    final _count = ref.watch(tasksCountNotifierProvider(taskView));

    return _count.when(
      error: (error, _) => PlaceholderWidget(text: error.toString()),
      loading: _TaskListLoadingState.new,
      data: (count) {
        return _TaskListDataState(
          taskView: taskView,
          count: count,
        );
      },
    );
  }
}

@immutable
class _TaskListDataState extends ConsumerStatefulWidget {
  const _TaskListDataState({
    required this.taskView,
    required this.count,
  });

  final TaskView taskView;
  final int count;

  @override
  ConsumerState<_TaskListDataState> createState() => _TaskListDataStateState();
}

class _TaskListDataStateState extends ConsumerState<_TaskListDataState>
    with AutomaticKeepAliveClientMixin {
  late final _animatedListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    logger('TaskList init state: ${widget.taskView.label}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tasksProvider(widget.taskView).notifier).addAnimatedListKey(
            widget.taskView.label,
            _animatedListKey,
          );

      if (widget.count == 0) {
        ref.read(tasksProvider(widget.taskView.copyWithPage(1)));
      }
    });
  }

  @override
  void dispose() {
    logger('TaskList dispose: ${widget.taskView.label}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(tasksFilterProvider)
          ..invalidate(tasksCountNotifierProvider);

        final _currentTaskView = ref.read(selectedTaskFilterProvider);

        return ref.refresh(tasksProvider(_currentTaskView).future);
      },
      child: Stack(
        children: [
          Visibility(
            visible: (ref.watch(tasksProvider(widget.taskView)).valueOrNull ?? []).isEmpty,
            child: const PlaceholderWidget(text: 'No tasks found'),
          ),
          AnimatedList(
            padding: EdgeInsets.zero,
            key: _animatedListKey,
            initialItemCount: widget.count,
            itemBuilder: (context, index, animation) {
              final _page = index ~/ TasksCountNotifier.pageSize + 1;
              final _itemIndex = index % TasksCountNotifier.pageSize;

              final _value = ref.watch(tasksProvider(widget.taskView.copyWithPage(_page)));

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
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _TaskListLoadingState extends StatelessWidget {
  const _TaskListLoadingState({
    super.key,
  });

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
