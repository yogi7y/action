import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/header/app_header.dart';
import '../models/task_view.dart';
import '../sections/task_input_field.dart';
import '../sections/tasks_filters.dart';
import '../sections/tasks_list.dart';
import '../state/new_task_provider.dart';
import '../state/task_filter_provider.dart';
import '../widgets/add_remove_floating_action_button.dart';

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

    final filters = ref.read(tasksFilterProvider);
    for (final filter in filters) {
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
    final spacing = ref.watch(spacingProvider);
    final filters = ref.watch(tasksFilterProvider);

    return BackButtonListener(
      onBackButtonPressed: () async => false,
      child: Scaffold(
        body: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const AppHeader(title: 'Tasks'),
              SliverToBoxAdapter(child: SizedBox(height: spacing.xxs)),
              SliverToBoxAdapter(
                child: TasksFilters(
                  filterViews:
                      filters.map((filter) => (filter: filter, key: _filterKeys[filter]!)).toList(),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),
              const SliverToBoxAdapter(child: TaskInputFieldVisibility()),
              SliverToBoxAdapter(child: SizedBox(height: spacing.xs)),
            ];
          },
          body: PageView(
            controller: _pageController,
            children: filters.map((filter) => TasksListView(taskView: filter)).toList(),
            onPageChanged: (value) => ref.read(selectedTaskView.notifier).selectByIndex(value),
          ),
        ),
        floatingActionButton: AddRemoveFloatingActionButton(
          onStateChanged: (state) =>
              ref.read(isTaskTextInputFieldVisibleProvider.notifier).update((value) => !value),
        ),
      ),
    );
  }
}
