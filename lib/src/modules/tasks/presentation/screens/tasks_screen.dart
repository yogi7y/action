import 'package:auto_route/auto_route.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/header/app_header.dart';
import '../../../dashboard/presentation/state/keyboard_visibility_provider.dart';
import '../sections/task_input_field.dart';
import '../sections/tasks_filters.dart';
import '../sections/tasks_list.dart';
import '../state/new_task_provider.dart';
import '../state/tasks_provider.dart';

@RoutePage()
class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(tasksProvider.future),
        child: CustomScrollView(
          slivers: [
            const AppHeader(title: 'Tasks'),
            SliverToBoxAdapter(child: SizedBox(height: _spacing.xxs)),
            const SliverToBoxAdapter(child: TasksFilters()),
            SliverToBoxAdapter(child: SizedBox(height: _spacing.lg)),
            const SliverToBoxAdapter(child: TaskInputFieldVisibility()),
            const SliverTasksList(),
            SliverToBoxAdapter(child: SizedBox(height: _spacing.xxl)),
          ],
        ),
      ),
      floatingActionButton: _AddTaskFloatingActionButton(),
    );
  }
}

@immutable
class _AddTaskFloatingActionButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    return Consumer(builder: (context, ref, child) {
      final _isKeyboardVisible = ref.watch(keyboardVisibilityProvider).value ?? false;
      final _opacity = _isKeyboardVisible ? 0.0 : 1.0;
      return AnimatedOpacity(
        opacity: _opacity,
        duration: defaultAnimationDuration,
        child: FloatingActionButton(
          onPressed: () {
            ref.read(isTaskTextInputFieldVisibleProvider.notifier).update((value) => !value);
          },
          backgroundColor: _colors.primary,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
          ),
          child: SvgPicture.asset(
            Assets.add,
            height: 32,
            width: 32,
          ),
        ),
      );
    });
  }
}
