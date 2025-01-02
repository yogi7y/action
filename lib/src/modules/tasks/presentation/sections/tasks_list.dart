import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/checkbox/checkbox.dart';
import '../models/task_view.dart';
import '../state/tasks_provider.dart';
import '../widgets/task_tile.dart';

@immutable
class TasksList extends ConsumerWidget {
  const TasksList({
    required this.taskView,
    super.key,
  });

  final TaskView taskView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _animatedListKey = taskView.animatedListKey;

    return ref.watch(tasksProvider(taskView)).when(
          data: (tasks) => AnimatedList(
            padding: EdgeInsets.zero,
            key: _animatedListKey,
            initialItemCount: tasks.length,
            itemBuilder: (context, index, animation) => ProviderScope(
              overrides: [
                scopedTaskProvider.overrideWithValue(tasks[index]),
              ],
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.2, 1),
                ),
                child: SlideTransition(
                  position: animation.drive(
                    Tween(
                      begin: const Offset(0, -0.3),
                      end: Offset.zero,
                    ).chain(
                      CurveTween(curve: Curves.easeInOut),
                    ),
                  ),
                  // child: const TaskTile(),
                  child: const _TasksLoadingTile(),
                ),
              ),
            ),
          ),
          loading: () => const _TasksLoadingTile(),
          error: (error, _) => Center(child: Text(error.toString())),
        );
  }
}

class BaseShimmer extends ConsumerWidget {
  const BaseShimmer({
    required this.child,
    this.width,
    this.height,
    super.key,
  });

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _isDark = _colors is CardTheme;

    // For light theme
    final _lightBase = _colors.surface.background.withOpacity(0.8);
    final _lightHighlight = _colors.surface.backgroundContrast;

    // For dark theme - using slightly lighter shades for better visibility
    final _darkBase = _colors.surface.modals;
    final _darkHighlight = _colors.accentShade.withOpacity(0.5);

    return Shimmer.fromColors(
      baseColor: _colors.accentShade,
      highlightColor: _colors.surface.modals,
      child: child,
    );
  }
}

// Reusable shimmer shapes
class ShimmerBox extends ConsumerWidget {
  const ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 4,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: borderRadius,
            cornerSmoothing: 1,
          ),
        ),
      ),
    );
  }
}

class ShimmerCircle extends ConsumerWidget {
  const ShimmerCircle({
    required this.size,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _TasksLoadingTile extends ConsumerWidget {
  const _TasksLoadingTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _spacing.lg,
        vertical: _spacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BaseShimmer(
            child: ShimmerBox(
              width: 32,
              height: 32,
              borderRadius: 8,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseShimmer(
                child: ShimmerBox(
                  width: _width * 0.75,
                  height: 20,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  BaseShimmer(
                    child: ShimmerBox(
                      width: _width * 0.3,
                      height: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // BaseShimmer(
                  //   child: ShimmerBox(
                  //     width: _width * 0.15,
                  //     height: 12,
                  //   ),
                  // ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
