import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/buttons/icon_button.dart';
import '../../../../shared/property_list/property_list.dart';
import '../../../../shared/status/status.dart';
import '../../../tasks/presentation/state/tasks_provider_old.dart';
import '../state/project_detail_provider.dart';
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

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController scrollController = ScrollController();
  late final TabController tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectViewModel = ref.watch(projectDetailProvider(widget.projectOrId));

    return ProviderScope(
      child: Scaffold(
        body: switch (projectViewModel) {
          AsyncData(value: final project) => ProviderScope(
              overrides: [
                projectNotifierProvider.overrideWith(() => ProjectNotifier(project)),
              ],
              child: _ProjectDetailDataState(
                tabController: tabController,
                controller: scrollController,
              ),
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
    required this.tabController,
  });

  final ScrollController controller;
  final TabController tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);

    return Scaffold(
      backgroundColor: colors.surface.background,
      body: RefreshIndicator(
        onRefresh: () async => Future<void>.delayed(const Duration(milliseconds: 1000)),
        child: NestedScrollView(
          controller: controller,
          headerSliverBuilder: (context, innerBoxScrolled) => [
            ProjectDetailTitle(controller: controller),
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
              child: _ProjectRelationDetailMetaData(),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(tabController: tabController),
            ),
          ],
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TabBarView(
              controller: tabController,
              children: const [
                ProjectTaskView(),
                Center(child: Text('Pages')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectTaskView extends ConsumerWidget {
  const ProjectTaskView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverTabBarDelegate({
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer(
      builder: (context, ref, _) {
        final colors = ref.watch(appThemeProvider);
        final fonts = ref.watch(fontsProvider);

        final textStyle = fonts.headline.xs.medium;

        return Container(
          color: colors.l2Screen.background,
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: _topPadding),
          child: TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            controller: tabController,
            labelPadding: const EdgeInsets.only(right: 20),
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: textStyle,
            unselectedLabelStyle: textStyle,
            labelColor: colors.tabBar.selectedTextColor,
            unselectedLabelColor: colors.tabBar.unselectedTextColor,
            dividerColor: Colors.transparent,
            indicatorColor: colors.tabBar.indicator,
            tabs: const [
              Tab(text: 'Tasks'),
              Tab(text: 'Pages'),
            ],
          ),
        );
      },
    );
  }

  static const _topPadding = 0.0;

  @override
  double get maxExtent => 48 + _topPadding;

  @override
  double get minExtent => 48 + _topPadding;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _ProjectRelationDetailMetaData extends ConsumerWidget {
  const _ProjectRelationDetailMetaData();

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
            label: '${project.metadata?.completedTasks}/${project.metadata?.totalTasks} Tasks',
            iconPath: AssetsV2.addTask,
          ),
          _ProjectMetaDataItem(
            label: '${project.metadata?.totalPages} Pages',
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
