import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/chips/chips.dart';
import '../models/task_view.dart';
import '../state/task_filter_provider.dart';

typedef TaskFilterView = ({
  TaskView filter,
  GlobalKey key,
});

class TasksFilters extends ConsumerWidget {
  const TasksFilters({
    required this.filterViews,
    super.key,
  });

  final List<TaskFilterView> filterViews;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: _spacing.lg),
      child: Row(
        spacing: _spacing.xs,
        children: filterViews.mapIndexed((index, filterView) {
          return AppChips(
            onClick: () {
              ref.read(selectedTaskFilterProvider.notifier).selectByIndex(index);
              unawaited(ref.read(tasksPageControllerProvider).animateToPage(
                    index,
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.linear,
                  ));
            },
            key: filterView.key,
            label: filterView.filter.label,
            iconPath: filterView.filter.icon,
            isSelected: filterView.filter == ref.watch(selectedTaskFilterProvider),
          );
        }).toList(),
      ),
    );
  }
}
