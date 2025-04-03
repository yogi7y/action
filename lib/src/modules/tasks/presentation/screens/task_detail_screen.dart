import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../dashboard/presentation/state/keyboard_visibility_provider.dart';
import '../state/checklist_provider.dart';
import '../state/new_checklist_provider.dart';
import '../state/task_detail_provider.dart';
import '../state/task_view_provider.old.dart';
import '../widgets/add_remove_floating_action_button.dart';
import '../widgets/checklist_input_field.dart';
import '../widgets/checklist_item.dart';
import '../widgets/task_detail_header.dart';
import '../widgets/task_detail_properties.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({
    required this.taskDataOrId,
    this.index,
    super.key,
  });

  final TaskDataOrId taskDataOrId;
  final int? index;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late final scrollController = ScrollController();
  late final _checklistSectionKey = GlobalKey(debugLabel: 'Checklist Section');

  @override
  void initState() {
    super.initState();

    ref.listenManual(keyboardVisibilityProvider, (previous, next) {
      final previousValue = previous?.valueOrNull ?? false;
      final nextValue = next.valueOrNull ?? false;

      if (previousValue && !nextValue) {
        unawaited(scrollController.animateTo(
          0,
          duration: defaultAnimationDuration,
          curve: Curves.easeOutCubic,
        ));
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskDetail = ref.watch(taskDetailProvider(widget.taskDataOrId));

    return Scaffold(
      body: switch (taskDetail) {
        AsyncData(value: final task) => ProviderScope(
            overrides: [taskDetailNotifierProvider.overrideWith(() => TaskDetailNotifier(task))],
            child: TaskDetailDataView(
              scrollController: scrollController,
              checklistSectionKey: _checklistSectionKey,
            ),
          ),
        AsyncError(error: final error) => TaskDetailErrorView(error: error),
        _ => const TaskDetailLoadingView(),
      },
      floatingActionButton: AddRemoveFloatingActionButton(
        onStateChanged: (state) {
          ref.read(isChecklistTextInputFieldVisibleProvider.notifier).update((value) => true);

          final checklistContext = _checklistSectionKey.currentContext;
          if (checklistContext == null) return;

          final renderBox = checklistContext.findRenderObject() as RenderBox?;
          if (renderBox == null) return;

          final position = renderBox.localToGlobal(Offset.zero);
          final scrollOffset =
              scrollController.offset + position.dy - MediaQuery.of(context).padding.top - 40;

          unawaited(scrollController.animateTo(
            scrollOffset,
            duration: defaultAnimationDuration,
            curve: Curves.easeOutCubic,
          ));
        },
      ),
    );
  }
}

@immutable
class TaskDetailDataView extends ConsumerWidget {
  const TaskDetailDataView({
    required this.scrollController,
    required this.checklistSectionKey,
    super.key,
  });

  final ScrollController scrollController;
  final GlobalKey checklistSectionKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskDetailNotifierProvider);
    final spacing = ref.watch(spacingProvider);
    final colors = ref.watch(appThemeProvider);

    return Scaffold(
      backgroundColor: colors.surface.background,
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(checklistProvider(task.id!).future);
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            TaskDetailHeader(
              title: task.name,
              scrollController: scrollController,
            ),
            SliverToBoxAdapter(
              child: Container(
                height: spacing.sm,
                color: colors.l2Screen.background,
              ),
            ),
            const SliverToBoxAdapter(child: TaskDetailProperties()),
            SliverToBoxAdapter(
              child: Container(
                height: spacing.sm,
                color: colors.l2Screen.background,
              ),
            ),
            SliverToBoxAdapter(
              child: _ChecklistHeadingAndInputField(
                key: checklistSectionKey,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: spacing.xs),
            ),
            Consumer(builder: (context, ref, child) {
              final checklist = ref.watch(checklistProvider(task.id!));
              final listKey = ref.watch(checklistAnimatedListKeyProvider);

              return checklist.when(
                data: (items) {
                  return SliverAnimatedList(
                    key: listKey,
                    initialItemCount: items.length,
                    itemBuilder: (context, index, animation) => ProviderScope(
                      key: ValueKey(index + 100),
                      overrides: [
                        scopedChecklistProvider.overrideWithValue(items[index]),
                      ],
                      child: FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: animation.drive(
                            Tween(
                              begin: const Offset(0, -0.3),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeInOut)),
                          ),
                          child: ChecklistItem(
                            key: ValueKey(index),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                error: (error, _) => SliverToBoxAdapter(child: Text(error.toString())),
                loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              );
            }),
            SliverToBoxAdapter(
              child: SizedBox(height: spacing.xxl),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 2000), // Force scrollable content
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistHeadingAndInputField extends ConsumerWidget {
  const _ChecklistHeadingAndInputField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);
    return Container(
      color: colors.surface.background,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Checklist',
            style: fonts.headline.md.semibold,
          ),
          SizedBox(height: spacing.md),
          const ChecklistInputVisibility(),
        ],
      ),
    );
  }
}

@immutable
class TaskDetailErrorView extends StatelessWidget {
  const TaskDetailErrorView({
    required this.error,
    super.key,
  });

  final Object error;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

@immutable
class TaskDetailLoadingView extends StatelessWidget {
  const TaskDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
