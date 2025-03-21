import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../design_system/design_system.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/buttons/clickable_svg.dart';
import '../../../../shared/property_list/property_list.dart';
import '../../../../shared/status/status.dart';
import '../../../tasks/presentation/mixin/task_module_scope.dart';
import '../../../tasks/presentation/screens/task_module.dart';
import '../../../tasks/presentation/sections/tasks_filters.dart';
import '../../../tasks/presentation/state/filter_keys_provider.dart';
import '../sections/project_task_view.dart';
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
    with SingleTickerProviderStateMixin, TaskModuleScope {
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

    return Scaffold(
      body: switch (projectViewModel) {
        AsyncData(value: final project) => ProviderScope(
            overrides: [
              projectNotifierProvider.overrideWith(() => ProjectNotifier(project)),
              ...createTaskModuleScope(
                TaskModuleData(
                  taskViews: projectTaskViews(
                    project.project.id!,
                  ),
                  smallerChips: true,
                  showFilters: false,
                  onRefresh: () async {
                    final projectOrId = (id: project.project.id, value: null);
                    return ref.refresh(projectDetailProvider(projectOrId));
                  },
                ),
              ),
            ],
            child: _ProjectDetailDataState(
              tabController: tabController,
              controller: scrollController,
            ),
          ),
        AsyncError(error: final error) => Center(child: Text(error.toString())),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

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
      body: NestedScrollView(
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
          padding: EdgeInsets.only(top: spacing.sm),
          child: TabBarView(
            controller: tabController,
            children: const [
              TaskModule(),
              Center(child: Text('Pages')),
            ],
          ),
        ),
      ),
    );
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
        final spacing = ref.watch(spacingProvider);
        final textStyle = fonts.headline.xs.medium;
        ref.watch(filterKeysProvider); // watching for any rebuilds.

        return ColoredBox(
          color: colors.surface.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
              ),
              SizedBox(height: spacing.md),
              TasksFilters(
                filterViews: ref.watch(filterKeysProvider.notifier).getFilterViews(),
                smallerChips: ref.watch(taskModelDataProvider).smallerChips,
              ),
            ],
          ),
        );
      },
    );
  }

  static const _topPadding = 0.0;

  @override
  double get maxExtent => 48 + _topPadding + 48;

  @override
  double get minExtent => 48 + _topPadding + 48;

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
            iconData: AppIcons.addTaskOutlined,
          ),
          _ProjectMetaDataItem(
            label: '${project.metadata?.totalPages} Pages',
            iconData: AppIcons.bookmarkAddOutlined,
          ),
          const _ProjectMetaDataItem(
            label: '7th Dec 2024',
            iconData: AppIcons.clockOutlined,
          ),
        ],
      ),
    );
  }
}

class _ProjectMetaDataItem extends ConsumerWidget {
  const _ProjectMetaDataItem({
    required this.label,
    required this.iconData,
  });

  final String label;
  final IconData iconData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    return Row(
      children: [
        AppIconButton(
          icon: iconData,
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
          labelIcon: AppIcons.loaderOutlined,
          valuePlaceholder: 'Status is not set',
          value: StatusWidget(
            state: project.status.toAppCheckboxState(),
            label: project.status.displayStatus,
          ),
        ),
        PropertyData(
          label: 'Due',
          labelIcon: AppIcons.calendarOutlined,
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
