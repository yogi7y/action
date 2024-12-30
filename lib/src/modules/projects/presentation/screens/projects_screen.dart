import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/header/app_header.dart';
import '../../../../shared/tab_bar/chip_tab_bar.dart';
import '../../../context/presentation/screens/context_screen.dart';
import '../sections/projects_list.dart';
import '../state/project_and_context_provider.dart';

@RoutePage()
class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  late final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _spacing = ref.watch(spacingProvider);

    final _selectedTab = ref.watch(projectAndContextProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const AppHeader(title: 'Projects'),
            SliverToBoxAdapter(
              child: ChipTabBar(
                pageController: _pageController,
                selectedIndex: _selectedTab.indexValue,
                onTabChanged: (index) {
                  ref
                      .read(projectAndContextProvider.notifier)
                      .update((_) => ProjectAndContext.fromIndex(index));
                  unawaited(_pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ));
                },
                items: const [
                  ChipTabBarItem(
                    label: 'Project',
                    icon: Assets.hardware,
                  ),
                  ChipTabBarItem(
                    label: 'Context',
                    icon: Assets.tag,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: _spacing.xxl)),
          ];
        },
        body: PageView(
          controller: _pageController,
          children: const [
            ProjectGridView(),
            ContextScreen(),
          ],
        ),
      ),
    );
  }
}
