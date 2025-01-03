import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/checkbox/checkbox.dart';
import '../../domain/entity/task.dart';
import '../state/task_detail_provider.dart';

class TaskDetailHeader extends ConsumerStatefulWidget {
  const TaskDetailHeader({
    required this.taskName,
    required this.scrollController,
    super.key,
  });

  final String taskName;
  final ScrollController scrollController;

  @override
  ConsumerState<TaskDetailHeader> createState() => _TaskDetailHeaderState();
}

class _TaskDetailHeaderState extends ConsumerState<TaskDetailHeader>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(vsync: this);
  late final Animation<double> _paddingAnimation;
  late final Animation<double> _opacityAnimation;
  late var _expandedHeight = kToolbarHeight * 2;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateAnimation);
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateExpandedHeight());

    _paddingAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 0.8, curve: Curves.easeInQuart),
    );

    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 0.7, curve: Curves.easeInQuart),
    );
  }

  void _calculateExpandedHeight() {
    if (!mounted) return;

    final _titleTextLength = widget.taskName.length;
    final _scale = _titleTextLength > 40 ? 1.3 : 1.0;

    final textSpan = TextSpan(
      text: widget.taskName,
      style: ref.read(fontsProvider).text.md.medium.copyWith(
            fontSize: 16 * _scale,
          ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 72);

    setState(() {
      _expandedHeight = kToolbarHeight + (textPainter.height) + 32;
    });
  }

  void _updateAnimation() {
    final scrollProgress =
        (widget.scrollController.offset / (kToolbarHeight * 1.2)).clamp(0.0, 1.0);
    _animationController.value = scrollProgress;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);

    return SliverAppBar(
      expandedHeight: _expandedHeight,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      foregroundColor: _colors.textTokens.primary,
      backgroundColor: _colors.surface.backgroundContrast,
      surfaceTintColor: _colors.surface.backgroundContrast,
      flexibleSpace: AnimatedBuilder(
        animation: _paddingAnimation,
        builder: (context, child) => FlexibleSpaceBar(
          expandedTitleScale: 1.3,
          titlePadding: EdgeInsets.only(
            bottom: 16,
            left: lerpDouble(20, 28, _paddingAnimation.value) ?? 24,
          ),
          title: child,
          background: ColoredBox(color: _colors.surface.backgroundContrast),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(-28 * _opacityAnimation.value, 0),
                child: Opacity(
                  opacity: 1 - _opacityAnimation.value,
                  child: child,
                ),
              ),
              child: const _Checkbox(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(
                  widget.taskName,
                  style: _fonts.text.md.medium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 4),
      child: Consumer(
        builder: (context, ref, child) => AppCheckbox(
          onChanged: (state) async {
            await ref.read(taskDetailNotifierProvider.notifier).updateTaskWithCallback(
                  (task) => task.copyWith(status: TaskStatus.fromAppCheckboxState(state)),
                );
          },
          state: AppCheckboxState.fromTaskStatus(
            status: ref.watch(
              taskDetailNotifierProvider.select((value) => value.status),
            ),
          ),
        ),
      ),
    );
  }
}
