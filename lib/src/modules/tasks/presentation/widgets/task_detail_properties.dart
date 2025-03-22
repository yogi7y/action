// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/router/routes.dart';
import '../../../../design_system/design_system.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/property_list/property_list.dart';
import '../../../../shared/status/status.dart';
import '../../../context/presentation/state/context_provider.dart';
import '../../../projects/presentation/state/project_picker_provider.dart';
import '../../../projects/presentation/state/projects_provider.dart';
import '../../../projects/presentation/view_models/project_view_model.dart';
import '../../../projects/presentation/widgets/project_picker.dart';
import '../../domain/entity/task_status.dart';
import '../state/task_detail_provider.dart';

class TaskDetailProperties extends ConsumerWidget {
  const TaskDetailProperties({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskDetailNotifierProvider);

    final projectViewModel = ref.watch(projectByIdProvider(task.projectId ?? ''));
    // ignore: no_leading_underscores_for_local_identifiers
    final _context = ref.watch(contextByIdProvider(task.contextId ?? ''));

    final properties = <PropertyTileData>[
      PropertyTileData(
        label: 'Status',
        labelIcon: AppIcons.loaderOutlined,
        valuePlaceholder: 'Status is not set',
        child: StatusWidget(
          state: task.status.toAppCheckboxState(),
          label: task.status.displayStatus,
        ),
        onValueTap: (position, _) async => _onStatusTap(context, ref, position),
      ),
      PropertyTileData(
        label: 'Due',
        labelIcon: AppIcons.calendarOutlined,
        valuePlaceholder: 'Empty',
        child: task.dueDate != null
            ? SelectedValueWidget(
                label: task.dueDate?.relativeDate ?? '',
              )
            : null,
      ),
      PropertyTileData(
        label: 'Project',
        labelIcon: AppIcons.hammerOutlined,
        valuePlaceholder: 'Empty',
        onValueTap: (position, controller) => controller.toggle(),
        actionBuilder: const _ProjectTileAction(),
        overlayChildBuilder: (context, controller) => ProjectPicker(
          controller: controller,
          data: ProjectPickerData(
            selectedProject: projectViewModel,
            onRemove: (entity) async {
              return ref
                  .read(taskDetailNotifierProvider.notifier)
                  .updateTask((task) => task.mark(projectIdAsNull: true));
            },
            onProjectSelected: (project) async => ref
                .read(taskDetailNotifierProvider.notifier)
                .updateTask((task) => task.copyWith(projectId: project.project.id)),
          ),
        ),
        child: projectViewModel?.project.name != null
            ? SelectedValueWidget(
                icon: AppIcons.hammerOutlined,
                label: projectViewModel?.project.name ?? '',
              )
            : null,
      ),
      PropertyTileData(
        label: 'Context',
        labelIcon: AppIcons.tagOutlined,
        valuePlaceholder: 'Empty',
        child: _context?.name != null
            ? SelectedValueWidget(
                icon: AppIcons.tagOutlined,
                label: _context?.name ?? '',
              )
            : null,
      ),
    ];

    return PropertyList(properties: properties);
  }

  Future<void> _onStatusTap(BuildContext context, WidgetRef ref, Offset position) async {
    final colors = ref.watch(appThemeProvider);

    final x = position.dx + 20;
    final y = position.dy + 40;

    final menuPosition = RelativeRect.fromLTRB(x, y, x, y);

    await showMenu(
      context: context,
      position: menuPosition,
      color: colors.overlay.background,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
        side: BorderSide(color: colors.overlay.borderStroke),
      ),
      items: [
        for (final status in TaskStatus.values)
          PopupMenuItem<TaskStatus>(
            value: status,
            height: 20,
            onTap: () async => ref
                .read(taskDetailNotifierProvider.notifier)
                .updateTask((task) => task.copyWith(status: status)),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: StatusWidget(
              state: status.toAppCheckboxState(),
              label: status.displayStatus,
            ),
          ),
      ],
    );

    return;
  }
}

class _ProjectTileAction extends ConsumerWidget {
  const _ProjectTileAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final projectId = ref.read(taskDetailNotifierProvider).projectId;

        unawaited(
          context.pushNamed(
            AppRoute.projectDetail.name,
            pathParameters: {'id': projectId!}, // handle the bang operator.
          ),
        );
      },
      child: const SizedBox(
        height: 20,
        width: 20,
        child: Placeholder(),
      ),
    );
  }
}
