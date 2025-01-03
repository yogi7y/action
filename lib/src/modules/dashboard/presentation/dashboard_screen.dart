import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    ref
      ..read(tasksCountNotifierProvider(_currentFilter))
      ..read(tasksProvider(_currentFilter));
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
