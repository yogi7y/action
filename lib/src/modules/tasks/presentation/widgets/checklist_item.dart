import 'package:core_y/src/extensions/time_ago.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/checkbox/checkbox.dart';
import '../../domain/entity/checklist.dart';
import '../state/checklist_provider.dart';
import '../state/task_detail_provider.dart';

class ChecklistItem extends ConsumerWidget {
  const ChecklistItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);
    final _spacing = ref.watch(spacingProvider);
    final checklist = ref.watch(scopedChecklistProvider);

    final isDone = checklist.status == ChecklistStatus.done;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _spacing.lg,
        vertical: _spacing.xs,
      ),
      child: Row(
        children: [
          AppCheckbox(
            state: checklist.status == ChecklistStatus.done
                ? AppCheckboxState.checked
                : AppCheckboxState.unchecked,
            padding: EdgeInsets.only(right: _spacing.xs),
            onChanged: (state) async {
              final newStatus =
                  state == AppCheckboxState.checked ? ChecklistStatus.done : ChecklistStatus.todo;

              final _taskId = ref.read(taskDetailNotifierProvider).id;

              await ref.read(checklistProvider(_taskId).notifier).updateChecklist(
                    checklist.copyWith(
                      status: newStatus,
                    ),
                  );
            },
          ),
          Expanded(
            child: Text(
              checklist.title,
              style: _fonts.text.md.regular.copyWith(
                fontSize: 15,
                fontVariations: [const FontVariation.weight(450)],
                decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                decorationThickness: 1,
                color: isDone ? _colors.textTokens.secondary : _colors.textTokens.primary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: _spacing.sm),
            child: Text(
              checklist.createdAt.timeAgo,
              style: _fonts.text.xs.regular.copyWith(
                fontSize: 10,
                height: 16 / 10,
                color: _colors.textTokens.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
