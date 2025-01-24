import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/buttons/icon_button.dart';
import '../../../../shared/header/detail_header.dart';
import '../../../../shared/property_list/property_list.dart';
import '../../../../shared/status/status.dart';
import '../state/project_detail_provider.dart';
import '../view_models/project_view_model.dart';
import '../widgets/project_detail_header.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  const ProjectDetailScreen({
    required this.projectOrId,
    super.key,
  });

  final ProjectOrId projectOrId;

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  late final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _project = ref.watch(projectDetailProvider(widget.projectOrId));

    return ProviderScope(
      child: Scaffold(
        body: switch (_project) {
          AsyncData(value: final project) => ProviderScope(
              overrides: [
                projectNotifierProvider.overrideWith(
                  () => ProjectNotifier(
                    ProjectViewModel(
                      project: project,
                      totalTasks: 0,
                      totalPages: 0,
                      completedTasks: 0,
                    ),
                  ),
                ),
              ],
              child: _ProjectDetailDataState(controller: scrollController),
            ),
          AsyncError(error: final error) => Center(child: Text(error.toString())),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

@immutable
class _ProjectDetailDataState extends ConsumerWidget {
  const _ProjectDetailDataState({
    required this.controller,
  });

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectNotifierProvider);
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);
    final fonts = ref.watch(fontsProvider);

    return Scaffold(
      backgroundColor: colors.surface.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 1000));
        },
        child: CustomScrollView(
          slivers: [
            ProjectDetailHeader(controller: controller),
            SliverToBoxAdapter(
              child: Container(
                height: spacing.sm,
                color: colors.l2Screen.background,
              ),
            ),
            const SliverToBoxAdapter(child: _ProjectDetailProperties()),
            SliverToBoxAdapter(
              child: Container(
                height: spacing.xs,
                color: colors.l2Screen.background,
              ),
            ),
            const SliverToBoxAdapter(
              child: _ProjectDetailMetaData(),
            )
          ],
        ),
      ),
    );
  }
}

class _ProjectDetailMetaData extends ConsumerWidget {
  const _ProjectDetailMetaData();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);
    final project = ref.watch(projectNotifierProvider);

    return Container(
      color: colors.l2Screen.background,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ProjectMetaDataItem(
            label: '${project.completedTasks}/${project.totalTasks} Tasks',
            iconPath: AssetsV2.addTask,
          ),
          _ProjectMetaDataItem(
            label: '${project.totalPages} Pages',
            iconPath: AssetsV2.bookmarkAdd,
          ),
          const _ProjectMetaDataItem(
            label: '7th Dec 2024',
            iconPath: AssetsV2.clock,
          ),
        ],
      ),
    );
  }
}

class _ProjectMetaDataItem extends ConsumerWidget {
  const _ProjectMetaDataItem({
    required this.label,
    required this.iconPath,
  });

  final String label;
  final String iconPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    return Row(
      children: [
        AppIconButton(
          svgIconPath: iconPath,
          size: 16,
          color: colors.textTokens.secondary,
        ),
        SizedBox(width: spacing.xxs),
        Text(
          label,
          style: fonts.text.xs.medium.copyWith(
            color: colors.textTokens.secondary,
          ),
        )
      ],
    );
  }
}

class _ProjectDetailProperties extends ConsumerWidget {
  const _ProjectDetailProperties();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectNotifierProvider).project;

    return PropertyList(
      properties: [
        PropertyData(
          label: 'Status',
          labelIcon: AssetsV2.loader,
          valuePlaceholder: 'Status is not set',
          value: StatusWidget(
            state: project.status.toAppCheckboxState(),
            label: project.status.displayStatus,
          ),
        ),
        PropertyData(
          label: 'Due',
          labelIcon: AssetsV2.calendar,
          valuePlaceholder: 'Empty',
          isRemovable: true,
          value: project.dueDate != null
              ? SelectedValueWidget(
                  label: project.dueDate?.relativeDate ?? '',
                )
              : null,
        ),
      ],
    );
  }
}
