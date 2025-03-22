// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../design_system/design_system.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/property_list/property_list.dart';
import '../../../../shared/status/status.dart';
import '../../../context/presentation/state/context_provider.dart';
import '../../../projects/presentation/state/projects_provider.dart';
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
    final project = projectViewModel?.project;
    final colors = ref.watch(appThemeProvider);

    final properties = <PropertyData>[
      PropertyData(
        label: 'Status',
        labelIcon: AppIcons.loaderOutlined,
        valuePlaceholder: 'Status is not set',
        value: StatusWidget(
          state: task.status.toAppCheckboxState(),
          label: task.status.displayStatus,
        ),
        onValueTap: (position, _) async {
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
        },
      ),
      PropertyData(
        label: 'Due',
        labelIcon: AppIcons.calendarOutlined,
        valuePlaceholder: 'Empty',
        isRemovable: true,
        value: task.dueDate != null
            ? SelectedValueWidget(
                label: task.dueDate?.relativeDate ?? '',
              )
            : null,
      ),
      PropertyData(
        label: 'Project',
        labelIcon: AppIcons.hammerOutlined,
        valuePlaceholder: 'Empty',
        isRemovable: true,
        onValueTap: (position, controller) {
          // projectController.openAndFocus();
          controller.toggle();
        },
        overlayChildBuilder: (context) => const ProjectPicker(),
        value: project?.name != null
            ? SelectedValueWidget(
                icon: AppIcons.hammerOutlined,
                label: project?.name ?? '',
              )
            : null,
      ),
      PropertyData(
        label: 'Context',
        labelIcon: AppIcons.tagOutlined,
        valuePlaceholder: 'Empty',
        isRemovable: true,
        value: _context?.name != null
            ? SelectedValueWidget(
                icon: AppIcons.tagOutlined,
                label: _context?.name ?? '',
              )
            : null,
      ),
    ];

    return PropertyList(
      properties: properties,
    );
  }
}

class ProjectPicker extends ConsumerStatefulWidget {
  const ProjectPicker({
    super.key,
  });

  @override
  ConsumerState<ProjectPicker> createState() => _ProjectPickerState();
}

class _ProjectPickerState extends ConsumerState<ProjectPicker> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  // Mock data for projects
  final List<MockProject> _mockProjects = [
    MockProject(id: '1', name: 'Q2 Marketing Strategy'),
    MockProject(id: '2', name: 'Website Redesign'),
    MockProject(id: '3', name: 'Learning Spanish'),
    MockProject(id: '4', name: 'Photography Portfolio'),
    MockProject(id: '5', name: 'Client Proposal: Acme Corp'),
    MockProject(id: '6', name: 'Client Proposal: Acme Corp'),
    MockProject(id: '7', name: 'Client Proposal: Acme Corp'),
    MockProject(id: '8', name: 'Client Proposal: Acme Corp'),
    MockProject(id: '9', name: 'Client Proposal: Acme Corp'),
    MockProject(id: '10', name: 'Client Proposal: Acme Corp'),
  ];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Results card
          Container(
            margin: EdgeInsets.symmetric(horizontal: spacing.md),
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.35,
            ),
            decoration: ShapeDecoration(
              color: colors.overlay.background,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(cornerRadius: 16, cornerSmoothing: 1),
                side: BorderSide(color: colors.overlay.borderStroke),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _mockProjects.length,
              itemBuilder: (context, index) {
                final project = _mockProjects[index];
                return ProjectPickerItem(
                  project: project,
                  onTap: () {
                    // Project selection logic would go here
                  },
                );
              },
            ),
          ),

          // Small spacing
          SizedBox(height: spacing.sm),

          // Search field at the bottom
          Container(
            margin: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.sm),
            child: TextField(
              autofocus: true,
              controller: _textController,
              focusNode: _focusNode,
              style: fonts.text.md.regular.copyWith(
                color: colors.textTokens.primary,
              ),
              decoration: InputDecoration(
                hintText: 'Search projects...',
                hintStyle: fonts.text.md.regular.copyWith(
                  color: colors.textTokens.secondary,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    AppIcons.search,
                    size: 20,
                    color: colors.textTokens.secondary,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.overlay.borderStroke,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.overlay.borderStroke,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.overlay.borderStroke,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                filled: true,
                fillColor: colors.surface.backgroundContrast,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectPickerItem extends ConsumerWidget {
  final MockProject project;
  final VoidCallback onTap;

  const ProjectPickerItem({
    required this.project,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.overlay.borderStroke.withOpacity(0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              AppIcons.hammerOutlined,
              size: 20,
              color: colors.textTokens.secondary,
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Text(
                project.name,
                style: fonts.text.sm.medium.copyWith(
                  color: colors.textTokens.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock data class
class MockProject {
  final String id;
  final String name;

  MockProject({required this.id, required this.name});
}
