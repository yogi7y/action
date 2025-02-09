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
    final spacing = ref.watch(spacingProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: spacing.xs,
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
    final dueDate = ref.watch(newTaskProvider.select((value) => value.dueDate));
    final relativeDueDate = dueDate?.relativeDate;

    return AppSelectableChip(
      iconPath: AssetsV2.calendarOutlined,
      value: relativeDueDate,
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
    final selectedContextId = ref.watch(newTaskProvider.select((value) => value.contextId));
    final selectedContext = selectedContextId != null && selectedContextId.isNotEmpty
        ? ref.watch(contextByIdProvider(selectedContextId))
        : null;
    return AppSelectableChip(
      iconPath: AssetsV2.tag,
      label: 'Context',
      value: selectedContext?.name,
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
    final selectedProjectId = ref.watch(newTaskProvider.select((value) => value.projectId));
    final selectedProject = selectedProjectId != null && selectedProjectId.isNotEmpty
        ? ref.watch(projectByIdProvider(selectedProjectId))
        : null;

    return AppSelectableChip(
      iconPath: AssetsV2.hammerOutlined,
      value: selectedProject?.project.name,
      label: 'Project',
      onCrossClick: () => ref.read(newTaskProvider.notifier).mark(projectIdAsNull: true),
      onClick: () => ref
          .read(currentStickyTextFieldTypeProvider.notifier)
          .update((_) => StickyTextFieldType.project),
    );
  }
}
