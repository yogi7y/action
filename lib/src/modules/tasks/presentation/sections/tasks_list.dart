import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/typography/typography.dart';
import '../models/task_list_view_data.dart';
import '../state/scoped_task_provider.dart';
import '../state/tasks_provider.dart';
import '../widgets/refresh_tasks_widget.dart';
import '../widgets/task_loading_tile.dart';
import '../widgets/task_tile.dart';

@immutable
class TaskListView extends ConsumerWidget {
  const TaskListView({
    required this.taskListViewData,
    super.key,
  });

  final TaskListViewData taskListViewData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider(taskListViewData));

    return tasksAsync.when(
      data: (_) => _TaskListViewDataState(taskListViewData: taskListViewData),
      loading: () => const _TaskListLoadingState(),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}

@immutable
class _TaskListViewDataState extends ConsumerStatefulWidget {
  const _TaskListViewDataState({
    required this.taskListViewData,
  });

  final TaskListViewData taskListViewData;

  @override
  ConsumerState<_TaskListViewDataState> createState() => _TaskListDataStateState();
}

class _TaskListDataStateState extends ConsumerState<_TaskListViewDataState>
    with AutomaticKeepAliveClientMixin {
  late final _animatedListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setAnimatedListKey();
    });
  }

  void _setAnimatedListKey() {
    ref.read(tasksProvider(widget.taskListViewData).notifier).setAnimatedListKey(_animatedListKey);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tasks = ref.watch(tasksProvider(widget.taskListViewData)).valueOrNull ?? [];

    if (tasks.isEmpty) return const _EmptyState();

    return RefreshTasksWidget(
      child: Stack(
        children: [
          AnimatedList(
            padding: EdgeInsets.zero,
            key: _animatedListKey,
            initialItemCount: tasks.length,
            itemBuilder: (context, index, animation) => ProviderScope(
              overrides: [
                scopedTaskProvider.overrideWithValue((index: index, task: tasks[index])),
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

class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fonts = ref.watch(fontsProvider);
    final height = MediaQuery.of(context).size.height * .7;

    return RefreshTasksWidget(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: height,
          child: Center(
            child: Text(
              'No tasks found',
              style: fonts.headline.xs.medium,
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskListLoadingState extends ConsumerWidget {
  const _TaskListLoadingState();

  @override
  Widget build(BuildContext context, WidgetRef ref) => SingleChildScrollView(
        child: Column(
          children: List.generate(
            10,
            (index) => const TasksLoadingTile(),
          ),
        ),
      );
}
