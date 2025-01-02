import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../design_system/design_system.dart';
import '../../../dashboard/presentation/state/keyboard_visibility_provider.dart';
import '../state/checklist_provider.dart';
import '../state/new_checklist_provider.dart';
import '../state/task_detail_provider.dart';
import '../widgets/checklist_input_field.dart';
import '../widgets/checklist_item.dart';
import '../widgets/task_detail_header.dart';
import '../widgets/task_properties.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({
    required this.taskDataOrId,
    super.key,
  });

  final TaskDataOrId taskDataOrId;

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

    return Scaffold(
      body: switch (taskDetail) {
        AsyncData(value: final task) => ProviderScope(
            overrides: [scopedTaskDetailProvider.overrideWithValue(task)],
            child: TaskDetailDataView(
              scrollController: scrollController,
            ),
          ),
        AsyncError(error: final error) => TaskDetailErrorView(error: error),
        _ => const TaskDetailLoadingView(),
      },
      floatingActionButton: _AddChecklistFloatingActionButton(),
    );
  }
}

@immutable
class _AddChecklistFloatingActionButton extends ConsumerWidget {
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
          onPressed: () =>
              ref.read(isChecklistTextInputFieldVisibleProvider.notifier).update((value) => !value),
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

@immutable
class TaskDetailDataView extends ConsumerWidget {
  const TaskDetailDataView({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _task = ref.watch(scopedTaskDetailProvider);
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
            const SliverToBoxAdapter(child: TaskProperties()),
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
              child: SizedBox(height: _spacing.xxl * 2),
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
