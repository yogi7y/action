import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/strings.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/chips/chips.dart';
import '../../../../shared/header/app_header.dart';
import '../sections/inbox_tasks.dart';
import '../state/inbox_tab_provider.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);
    final fonts = ref.watch(fontsProvider);
    final selectedTab = ref.watch(inboxTabProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) {
          return [
            AppHeader(
              title: AppStrings.inbox,
              titleSpacing: spacing.lg,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                child: Row(
                  children: [
                    AppChips(
                      label: AppStrings.tasks,
                      isSelected: selectedTab == InboxTab.tasks,
                      onClick: () => ref.read(inboxTabProvider.notifier).state = InboxTab.tasks,
                    ),
                    SizedBox(width: spacing.sm),
                    AppChips(
                      label: AppStrings.pages,
                      isSelected: selectedTab == InboxTab.pages,
                      onClick: () => ref.read(inboxTabProvider.notifier).state = InboxTab.pages,
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: EdgeInsets.only(top: spacing.lg),
          child: PageView(
            onPageChanged: (index) => ref.read(inboxTabProvider.notifier).state =
                index == 0 ? InboxTab.tasks : InboxTab.pages,
            children: const [
              InboxTasks(),
              CustomScrollView(),
            ],
          ),
        ),
      ),
    );
  }
}
