import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/strings.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/sliver_sized_box.dart';
import '../../../tasks/presentation/state/scoped_task_provider.dart';
import '../../../tasks/presentation/widgets/task_loading_tile.dart';
import '../../../tasks/presentation/widgets/task_tile.dart';
import '../state/inbox_tasks_provider.dart';

class InboxTasks extends ConsumerWidget {
  const InboxTasks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);
    final fonts = ref.watch(fontsProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(unorganisedTasksProvider),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.horizontalScreenPadding),
              child: Text(
                AppStrings.last24HoursTitle,
                style: fonts.headline.sm.semibold,
              ),
            ),
          ),
          SliverSizedBox(height: spacing.md),
          const _Last24Hours(),
          SliverSizedBox(height: spacing.lg),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.horizontalScreenPadding),
              child: Text(
                AppStrings.unorganisedTitle,
                style: fonts.headline.sm.semibold,
              ),
            ),
          ),
          SliverSizedBox(height: spacing.md),
          const _UnorganisedTasks(),
        ],
      ),
    );
  }
}

class _Last24Hours extends ConsumerWidget {
  const _Last24Hours();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxTasks = ref.watch(inboxTasksProvider);
    final fonts = ref.watch(fontsProvider);

    return inboxTasks.when(
      data: (data) {
        if (data.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: Center(
                child: Text(
                  'Your inbox is clear! 🎉',
                  style: fonts.text.lg.medium,
                ),
              ),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ProviderScope(
              overrides: [scopedTaskProvider.overrideWithValue((index: index, task: data[index]))],
              child: const TaskTile(),
            ),
            childCount: data.length,
          ),
        );
      },
      error: (error, stackTrace) => SliverToBoxAdapter(child: Text(error.toString())),
      loading: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const TasksLoadingTile(),
          childCount: 4,
        ),
      ),
    );
  }
}

class _UnorganisedTasks extends ConsumerWidget {
  const _UnorganisedTasks();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(unorganisedTasksProvider);
    final fonts = ref.watch(fontsProvider);
    return tasks.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: Center(
                child: Text(
                  'No unorganised items',
                  style: fonts.text.lg.medium,
                ),
              ),
            ),
          );
        }
        return SliverList.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ProviderScope(
              overrides: [scopedTaskProvider.overrideWithValue((index: index, task: task))],
              child: const TaskTile(),
            );
          },
        );
      },
      loading: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const TasksLoadingTile(),
          childCount: 8,
        ),
      ),
      error: (error, stackTrace) => SliverToBoxAdapter(
        child: ErrorWidget(error.toString()),
      ),
    );
  }
}
