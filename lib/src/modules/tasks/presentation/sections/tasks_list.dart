import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/typography/typography.dart';
import '../../../../shared/placeholder_widget.dart';
import '../models/task_view.dart';
import '../state/scoped_task_provider.dart';
import '../state/tasks_provider.dart';
import '../widgets/refresh_tasks_widget.dart';
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
  Widget build(BuildContext context, WidgetRef ref) => ProviderScope(
        overrides: [
          scopedTaskViewProvider.overrideWithValue(taskView),
        ],
        child: ref.watch(tasksNotifierProvider(taskView)).when(
              error: (error, _) => PlaceholderWidget(text: error.toString()),
              loading: _TaskListLoadingState.new,
              data: (tasks) => const _TaskListViewDataState(),
            ),
      );
}

@immutable
class _TaskListViewDataState extends ConsumerStatefulWidget {
  const _TaskListViewDataState();

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
      final taskView = ref.read(scopedTaskViewProvider);
      ref.read(tasksNotifierProvider(taskView).notifier).setAnimatedListKey(_animatedListKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final taskView = ref.read(scopedTaskViewProvider);

    final tasks = ref.watch(tasksNotifierProvider(taskView)).valueOrNull ?? [];

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
