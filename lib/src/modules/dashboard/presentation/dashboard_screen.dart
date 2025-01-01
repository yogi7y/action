import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/design_system.dart';
import '../../../shared/bottom_nav/bottom_nav_bar.dart';
import '../../../shared/bottom_nav/bottom_nav_items_provider.dart';
import '../../../shared/sticky_component_over_keyboard/sticky_component_over_keyboard.dart';
import '../../context/presentation/state/context_provider.dart';
import '../../projects/presentation/state/projects_provider.dart';
import '../../tasks/presentation/state/task_filter_provider.dart';
import '../../tasks/presentation/state/tasks_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    ref
      ..read(projectsProvider)
      ..read(contextsProvider);

    final _currentFilter = ref.read(tasksFilterProvider).first;
    ref.read(tasksProvider(_currentFilter));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.navigationShell,
          const StickyComponentOverKeyboard(),
        ],
      ),
      bottomNavigationBar: ProviderScope(
        overrides: [
          navigatorShellProvider.overrideWithValue(widget.navigationShell),
        ],
        child: const BottomNavBar(),
      ),
    );
  }
}

class _DashboardScreenScaffold extends ConsumerStatefulWidget {
  const _DashboardScreenScaffold({
    required this.child,
    required this.controller,
  });

  final Widget child;
  final PageController controller;

  @override
  ConsumerState<_DashboardScreenScaffold> createState() => _DashboardScreenScaffoldState();
}

class _DashboardScreenScaffoldState extends ConsumerState<_DashboardScreenScaffold> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      final _index = widget.controller.page!.round();
      final _items = ref.read(bottomNavItemsProvider);
      final _newSelectedItem = _items[_index];

      final _newSelectedItemWithIndex = (index: _index, item: _newSelectedItem);

      ref.read(selectedBottomNavProvider.notifier).update((e) => _newSelectedItemWithIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _colors = ref.watch(appThemeProvider);
    return Scaffold(
      backgroundColor: _colors.surface.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          const StickyComponentOverKeyboard(),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
