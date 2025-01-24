import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/date_time_extension.dart';
import '../../design_system/design_system.dart';
import '../../modules/context/presentation/state/context_provider.dart';
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: _spacing.xs,
        children: const [
          _ProjectOption(),
          _ContextOption(),
          _DueDateOption(),
        ],
      ),
    );
  }
}

class _DueDateOption extends ConsumerWidget {
  const _DueDateOption();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _dueDate = ref.watch(newTaskProvider.select((value) => value.dueDate));
    final _relativeDueDate = _dueDate?.relativeDate;

    return AppSelectableChip(
      iconPath: Assets.calendarMonth,
      value: _relativeDueDate,
      label: 'Due Date',
      onCrossClick: () => ref.read(newTaskProvider.notifier).mark(dueDateAsNull: true),
      onClick: () {},
    );
  }
}

@immutable
class _ContextOption extends ConsumerWidget {
  const _ContextOption();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedContextId = ref.watch(newTaskProvider.select((value) => value.contextId));
    final _selectedContext = _selectedContextId != null && _selectedContextId.isNotEmpty
        ? ref.watch(contextByIdProvider(_selectedContextId))
        : null;
    return AppSelectableChip(
      iconPath: Assets.tag,
      label: 'Context',
      value: _selectedContext?.name,
      onCrossClick: () => ref.read(newTaskProvider.notifier).mark(contextIdAsNull: true),
      onClick: () => ref
          .read(currentStickyTextFieldTypeProvider.notifier)
          .update((_) => StickyTextFieldType.context),
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
      value: _selectedProject?.project.name,
      label: 'Project',
      onCrossClick: () => ref.read(newTaskProvider.notifier).mark(projectIdAsNull: true),
      onClick: () => ref
          .read(currentStickyTextFieldTypeProvider.notifier)
          .update((_) => StickyTextFieldType.project),
    );
  }
}
