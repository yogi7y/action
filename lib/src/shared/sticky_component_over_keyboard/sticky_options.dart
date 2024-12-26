import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../../modules/projects/presentation/state/projects_provider.dart';
import '../../modules/tasks/presentation/state/new_task_provider.dart';
import '../chips/selectable_chip.dart';
import 'sticky_keyboard_provider.dart';

@immutable
class StickyOptions extends ConsumerWidget {
  const StickyOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    return Row(
      spacing: _spacing.xs,
      children: [
        _ProjectOption(),
        AppSelectableChip(
          iconPath: Assets.tag,
          label: 'Context',
          onClick: () {
            ref
                .read(currentStickyTextFieldTypeProvider.notifier)
                .update((_) => StickyTextFieldType.context);
          },
        ),
        AppSelectableChip(
          iconPath: Assets.calendarMonth,
          label: 'Due Date',
          onClick: () {},
        ),
      ],
    );
  }
}

class _ProjectOption extends ConsumerWidget {
  const _ProjectOption();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedProjectId = ref.watch(newTaskProvider.select((value) => value.projectId));
    final _selectedProject = _selectedProjectId != null && _selectedProjectId.isNotEmpty
        ? ref.watch(projectByIdProvider(_selectedProjectId))
        : null;

    return AppSelectableChip(
      iconPath: Assets.construction,
      value: _selectedProject?.name,
      label: 'Project',
      onCrossClick: () => ref.read(newTaskProvider.notifier).mark(projectIdAsNull: true),
      onClick: () => ref
          .read(currentStickyTextFieldTypeProvider.notifier)
          .update((_) => StickyTextFieldType.project),
    );
  }
}
