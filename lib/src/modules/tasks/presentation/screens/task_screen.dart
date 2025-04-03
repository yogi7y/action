import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/strings.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/chips/chips.dart';
import '../../../../shared/header/app_header.dart';
import '../../../../shared/sliver_sized_box.dart';
import '../../domain/entity/task_status.dart';
import '../models/task_view.dart';
import '../models/task_view_variants.dart';
import '../sections/tasks_list.dart';
import '../state/selected_task_filter_provider.dart';
import '../state/task_list_view_data_provider.dart';
import 'task_module.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          AppHeader(
            title: AppStrings.tasks,
            isSliver: true,
            titleSpacing: spacing.horizontalScreenMargin,
          ),
          const _TaskScreenFilters(),
          SliverSizedBox(height: spacing.md),
        ],
        body: const _TaskListViews(),
      ),
    );
  }
}

class _TaskListViews extends ConsumerWidget {
  const _TaskListViews();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(taskScreenTaskViewsProvider);
    return PageView.builder(
      itemCount: filters.length,
      itemBuilder: (context, index) => TaskListView(
        taskListViewData: filters[index].args,
      ),
      onPageChanged: (value) =>
          ref.read(selectedTaskFilterProvider.notifier).state = filters[value].name,
    );
  }
}

class _TaskScreenFilters extends ConsumerWidget {
  const _TaskScreenFilters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(taskScreenTaskViewsProvider);
    final spacing = ref.watch(spacingProvider);

    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: spacing.lg),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters
              .map((filter) => Padding(
                    padding: EdgeInsets.only(right: spacing.xs),
                    child: AppChips(
                      label: filter.name,
                      isSelected: filter.name == ref.watch(selectedTaskFilterProvider),
                      onClick: () =>
                          ref.read(selectedTaskFilterProvider.notifier).state = filter.name,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
