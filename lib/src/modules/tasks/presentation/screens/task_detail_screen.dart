import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../state/checklist_provider.dart';
import '../state/new_checklist_provider.dart';
import '../state/task_detail_provider.dart';
import '../widgets/add_task_floating_action_button.dart';
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
  late final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskDetail = ref.watch(taskDetailProvider(widget.taskDataOrId));

    return ProviderScope(
      overrides: [taskDetailIndexProvider.overrideWithValue(widget.index)],
      child: Scaffold(
        body: switch (taskDetail) {
          AsyncData(value: final task) => ProviderScope(
              overrides: [taskDetailNotifierProvider.overrideWith(() => TaskDetailNotifier(task))],
              child: Builder(builder: (context) {
                return TaskDetailDataView(
                  scrollController: scrollController,
                );
              }),
            ),
          AsyncError(error: final error) => TaskDetailErrorView(error: error),
          _ => const TaskDetailLoadingView(),
        },
        floatingActionButton: AddRemoveFloatingActionButton(
          onStateChanged: (state) =>
              ref.read(isChecklistTextInputFieldVisibleProvider.notifier).update((value) => !value),
        ),
      ),
    );
  }
}

@immutable
class TaskDetailDataView extends ConsumerWidget {
  const TaskDetailDataView({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _task = ref.watch(taskDetailNotifierProvider);
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);

    return Scaffold(
      backgroundColor: _colors.surface.background,
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(checklistProvider(_task.id).future);
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            TaskDetailHeader(
              taskName: _task.name,
              scrollController: scrollController,
            ),
            SliverToBoxAdapter(
              child: Container(
                height: _spacing.sm,
                color: _colors.l2Screen.background,
              ),
            ),
            const SliverToBoxAdapter(child: TaskDetailProperties()),
            SliverToBoxAdapter(
              child: Container(
                height: _spacing.sm,
                color: _colors.l2Screen.background,
              ),
            ),
            SliverToBoxAdapter(
              child: _ChecklistHeadingAndInputField(),
            ),
            Consumer(builder: (context, ref, child) {
              final _checklist = ref.watch(checklistProvider(_task.id));
              final listKey = ref.watch(checklistAnimatedListKeyProvider);

              return _checklist.when(
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
              child: SizedBox(height: _spacing.xxl),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistHeadingAndInputField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);
    final _spacing = ref.watch(spacingProvider);
    return Container(
      color: _colors.surface.background,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Checklist',
            style: _fonts.headline.md.semibold,
          ),
          SizedBox(height: _spacing.md),
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
