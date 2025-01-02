import 'dart:async';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/header/app_header.dart';
import '../../../dashboard/presentation/state/keyboard_visibility_provider.dart';
import '../models/task_view.dart';
import '../sections/task_input_field.dart';
import '../sections/tasks_filters.dart';
import '../sections/tasks_list.dart';
import '../state/new_task_provider.dart';
import '../state/task_filter_provider.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  late final _pageController = ref.watch(tasksPageControllerProvider);
  final _filterKeys = <TaskView, GlobalKey>{};

  @override
  void initState() {
    super.initState();

    final _filters = ref.read(tasksFilterProvider);
    for (final filter in _filters) {
      _filterKeys[filter] = GlobalKey();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.addListener(_onPageChanged);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPageChanged() {
    final controller = ref.read(tasksPageControllerProvider);
    final page = controller.page?.round() ?? 0;
    final filters = ref.read(tasksFilterProvider);

    if (page >= 0 && page < filters.length) {
      _scrollToSelectedFilter(filters[page]);
    }
  }

  void _scrollToSelectedFilter(TaskView selectedFilter) {
    final filterKey = _filterKeys[selectedFilter];
    if (filterKey?.currentContext == null) return;

    unawaited(
      Scrollable.ensureVisible(
        filterKey!.currentContext!,
        alignment: 0.7,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _spacing = ref.watch(spacingProvider);
    final _filters = ref.watch(tasksFilterProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const AppHeader(title: 'Tasks'),
            SliverToBoxAdapter(child: SizedBox(height: _spacing.xxs)),
            SliverToBoxAdapter(
              child: TasksFilters(
                filterViews:
                    _filters.map((filter) => (filter: filter, key: _filterKeys[filter]!)).toList(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: _spacing.lg)),
            const SliverToBoxAdapter(child: TaskInputFieldVisibility()),
          ];
        },
        body: PageView(
          controller: _pageController,
          children: _filters.map((filter) => TasksList(taskView: filter)).toList(),
          onPageChanged: (value) =>
              ref.read(selectedTaskFilterProvider.notifier).selectByIndex(value),
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
            AssetsV2.plus,
            height: 32,
            width: 32,
          ),
        ),
      );
    });
  }
}
