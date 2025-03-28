import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/chips/chips.dart';
import '../state/inbox_tab_provider.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  // Temporary data for demonstration
  final List<String> _last24HoursItems = List.generate(5, (index) => 'Item ${index + 1}');
  final List<String> _unorganisedItems =
      List.generate(20, (index) => 'Unorganised Item ${index + 1}');
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      // Load more items when reaching 80% of the scroll
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);
    final fonts = ref.watch(fontsProvider);
    final selectedTab = ref.watch(inboxTabProvider);

    return Scaffold(
      backgroundColor: colors.surface.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: colors.surface.background,
            title: Text(
              'Inbox',
              style: fonts.headline.lg.semibold,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: Row(
                children: [
                  AppChips(
                    label: 'Tasks',
                    isSelected: selectedTab == InboxTab.tasks,
                    onClick: () => ref.read(inboxTabProvider.notifier).state = InboxTab.tasks,
                  ),
                  SizedBox(width: spacing.sm),
                  AppChips(
                    label: 'Pages',
                    isSelected: selectedTab == InboxTab.pages,
                    onClick: () => ref.read(inboxTabProvider.notifier).state = InboxTab.pages,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: spacing.md)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: Text(
                'Last 24 Hours',
                style: fonts.headline.sm.semibold,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = _last24HoursItems[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.xs),
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: colors.surface.backgroundContrast,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(item),
                );
              },
              childCount: _last24HoursItems.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(spacing.lg, spacing.lg, spacing.lg, spacing.sm),
              child: Text(
                'Unorganised',
                style: fonts.headline.sm.semibold,
              ),
            ),
          ),
          SliverList.builder(
            itemCount: _unorganisedItems.length,
            itemBuilder: (context, index) {
              final item = _unorganisedItems[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.xs),
                padding: EdgeInsets.all(spacing.md),
                decoration: BoxDecoration(
                  color: colors.surface.backgroundContrast,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item),
              );
            },
          ),
        ],
      ),
    );
  }
}
