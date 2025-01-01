import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/checkbox/checkbox.dart';
import '../state/task_detail_provider.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  TaskDetailScreen({
    required this.taskDataOrId,
    super.key,
  }) : assert(
          taskDataOrId.id != null || taskDataOrId.data != null,
          'Either taskId or data must be provided',
        );

  final TaskDataOrId taskDataOrId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen>
    with SingleTickerProviderStateMixin {
  late final _scrollController = ScrollController();
  late final _animationController = AnimationController(
    vsync: this,
  );
  late final Animation<double> _paddingAnimation;
  late final Animation<double> _opacityAnimation;
  late var _expandedHeight = kToolbarHeight * 2;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateAnimation);
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateExpandedHeight());

    // Animation completes in first 80% of scroll
    _paddingAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 0.8, curve: Curves.easeInQuart),
    );

    // Opacity fades even faster - in first 70%
    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 0.7, curve: Curves.easeInQuart),
    );
  }

  void _calculateExpandedHeight() {
    if (!mounted) return;

    final _titleTextLength = (widget.taskDataOrId.data?.name ?? '').length;

    final _scale = _titleTextLength > 40 ? 1.4 : 1.0;

    // Calculate required height for text
    final textSpan = TextSpan(
      text: widget.taskDataOrId.data?.name ?? '',
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
    final scrollProgress = (_scrollController.offset / (kToolbarHeight * 1.2)).clamp(0.0, 1.0);
    _animationController.value = scrollProgress;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);

    return Scaffold(
      backgroundColor: _colors.surface.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: _expandedHeight,
            collapsedHeight: kToolbarHeight,
            pinned: true,
            foregroundColor: _colors.textTokens.primary,
            backgroundColor: _colors.surface.backgroundContrast,
            surfaceTintColor: _colors.surface.backgroundContrast,
            flexibleSpace: AnimatedBuilder(
              animation: _paddingAnimation,
              builder: (context, child) => FlexibleSpaceBar(
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
                    child: const Padding(
                      padding: EdgeInsets.only(right: 6, top: 4),
                      child: AppCheckbox(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: Text(
                        widget.taskDataOrId.data?.name ?? 'Task detail screen',
                        style: _fonts.text.md.medium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  'Task detail screen $index',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
