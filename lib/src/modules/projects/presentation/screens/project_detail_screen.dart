import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/buttons/icon_button.dart';
import '../../../../shared/property_list/property_list.dart';
import '../../../../shared/status/status.dart';
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

  late final TabController tabController = TabController(
    length: 2,
    vsync: this,
  );

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
                controller: scrollController,
                tabController: tabController,
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
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    return Scaffold(
      backgroundColor: colors.surface.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 1000));
        },
        child: NestedScrollView(
          controller: controller,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            ProjectDetailTitle(
              controller: controller,
              tabIndex: tabController.index,
            ),
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
            const SliverToBoxAdapter(child: _ProjectRelationDetailMetaData()),
            SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: tabController,
                  isScrollable: true,
                  labelPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  dividerColor: colors.tabBar.underlineBorder,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: colors.tabBar.indicator,
                    ),
                  ),
                  labelStyle: fonts.headline.xs.medium,
                  unselectedLabelStyle: fonts.headline.xs.medium,
                  labelColor: colors.tabBar.selectedTextColor,
                  unselectedLabelColor: colors.tabBar.unselectedTextColor,
                  tabs: const [
                    Tab(text: 'Tasks'),
                    Tab(text: 'Pages'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: tabController,
            children: [
              // Tasks tab
              ListView.builder(
                padding: EdgeInsets.only(bottom: spacing.lg),
                itemCount: 15,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.check_box_outline_blank),
                  title: Text('Task ${index + 1}'),
                  subtitle: Text('Task description ${index + 1}'),
                  trailing: const Icon(Icons.more_vert),
                ),
              ),
              // Pages tab
              ListView.builder(
                padding: EdgeInsets.only(bottom: spacing.lg),
                itemCount: 3,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.description),
                  title: Text('Page ${index + 1}'),
                  subtitle: const Text('Last edited 2 days ago'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final container = ProviderScope.containerOf(context);
    final spacing = container.read(spacingProvider);

    return Container(
      padding: EdgeInsets.zero,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
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
