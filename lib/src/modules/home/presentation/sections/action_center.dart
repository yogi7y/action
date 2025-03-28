import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../design_system/design_system.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../modules/tasks/domain/entity/task_entity.dart';
import '../../../../modules/tasks/domain/entity/task_status.dart';
import '../../../../shared/buttons/clickable_svg.dart';

/// Provider for the selected tab index in the Action Center
final actionCenterSelectedTabProvider = StateProvider<int>((ref) => 0);

/// Action Center component for the home screen
/// Displays priority tasks in a tabbed interface
class ActionCenter extends ConsumerStatefulWidget {
  const ActionCenter({super.key});

  @override
  ConsumerState<ActionCenter> createState() => _ActionCenterState();
}

class _ActionCenterState extends ConsumerState<ActionCenter> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      ref.read(actionCenterSelectedTabProvider.notifier).state = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);
    final selectedTabIndex = ref.watch(actionCenterSelectedTabProvider);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(left: spacing.lg, right: spacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Action Center',
              style: fonts.headline.md.semibold,
            ),
            AppIconButton(
              icon: AppIcons.addTaskOutlined,
              size: 24,
              color: colors.textTokens.primary,
              onClick: () => unawaited(context.pushNamed(AppRoute.inbox.name)),
            ),
          ],
        ),
      ),
      SizedBox(height: spacing.sm),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
      //   child: Align(
      //     alignment: Alignment.centerLeft,
      //     child: TabBar(
      //       padding: EdgeInsets.zero,
      //       controller: _tabController,
      //       isScrollable: true,
      //       tabAlignment: TabAlignment.start,
      //       dividerColor: colors.overlay.borderStroke,
      //       tabs: const [
      //         _ActionCenterTab(label: 'In Progress'),
      //         _ActionCenterTab(label: 'Do Next'),
      //         _ActionCenterTab(label: 'Due Soon'),
      //       ],
      //       labelColor: colors.textTokens.primary,
      //       unselectedLabelColor: colors.textTokens.secondary,
      //       indicatorColor: colors.primary,
      //       indicatorSize: TabBarIndicatorSize.label,
      //     ),
      //   ),
      // ),
      // SizedBox(
      //   child: TabBarView(
      //     controller: _tabController,
      //     children: const [
      //       Placeholder(),
      //       Placeholder(),
      //       Placeholder(),
      //     ],
      //   ),
      // ),
    ]);
  }
}

class _ActionCenterTab extends ConsumerWidget {
  const _ActionCenterTab({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    return Padding(
      padding: EdgeInsets.only(top: spacing.xs, bottom: spacing.xs),
      child: Text(
        label,
        style: fonts.text.sm.medium,
      ),
    );
  }
}
