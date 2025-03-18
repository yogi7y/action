import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/bottom_nav/bottom_nav_bar.dart';
import '../../../shared/bottom_nav/bottom_nav_items_provider.dart';
import '../../../shared/sticky_component_over_keyboard/sticky_component_over_keyboard.dart';
import '../../context/presentation/state/context_provider.dart';
import '../../projects/presentation/state/projects_provider.dart';
import '../../tasks/presentation/state/new_checklist_provider.dart';
import '../../tasks/presentation/state/new_task_provider.dart';
import '../../tasks/presentation/state/task_view_provider.dart';
import 'state/keyboard_visibility_provider.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Activating the listener here.
      ref.read(loadedTaskViewsProvider);
      final selectedTaskView = ref.read(selectedTaskViewProvider);

      ref.read(loadedTaskViewsProvider.notifier).update(
        (state) {
          if (state.contains(selectedTaskView)) return state;

          return {...state, selectedTaskView};
        },
      );
    });

    ref
      ..listenManual(keyboardVisibilityProvider, (previous, next) {
        final previousValue = previous?.valueOrNull ?? false;
        final nextValue = next.valueOrNull ?? false;

        if (previousValue && !nextValue) {
          ref.read(isTaskTextInputFieldVisibleProvider.notifier).update((_) => false);
          ref.read(isChecklistTextInputFieldVisibleProvider.notifier).update((_) => false);
        }
      })
      ..read(projectsProvider)
      ..read(contextsProvider);
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
