import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/chips/chips.dart';

class TasksFilters extends ConsumerWidget {
  const TasksFilters({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: _spacing.lg),
      child: Row(
        spacing: _spacing.xs,
        children: const [
          AppChips(
            label: 'Inbox',
            iconPath: Assets.inbox,
            isSelected: true,
          ),
          AppChips(label: 'In Progress', iconPath: Assets.play),
          AppChips(label: 'Todo', iconPath: Assets.check),
          AppChips(label: 'Todo', iconPath: Assets.check),
          AppChips(label: 'Todo', iconPath: Assets.check),
          AppChips(label: 'Todo', iconPath: Assets.check),
          AppChips(label: 'Todo', iconPath: Assets.check),
        ],
      ),
    );
  }
}
