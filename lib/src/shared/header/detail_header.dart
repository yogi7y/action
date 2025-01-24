import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';

class DetailHeader extends ConsumerStatefulWidget {
  const DetailHeader({
    required this.title,
    required this.scrollController,
    this.leading,
    this.expandedHeight,
    this.titleStyle,
    this.backgroundColor,
    this.maxLines = 3,
    super.key,
  });

  /// The String that is displayed in the header.
  final String title;

  final ScrollController scrollController;
  final Widget? leading;
  final double? expandedHeight;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final int maxLines;

  @override
  ConsumerState<DetailHeader> createState() => _DetailHeaderState();
}

class _DetailHeaderState extends ConsumerState<DetailHeader> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(vsync: this);
  late final Animation<double> _paddingAnimation;
  late final Animation<double> _opacityAnimation;
  late var _calculatedExpandedHeight = kToolbarHeight * 2;

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

    if (widget.expandedHeight != null) {
      setState(() => _calculatedExpandedHeight = widget.expandedHeight!);
      return;
    }

    final titleLength = widget.title.length;
    final scale = titleLength > 40 ? 1.3 : 1.0;

    final textSpan = TextSpan(
      text: widget.title,
      style: (widget.titleStyle ?? ref.read(fontsProvider).text.md.medium)
          .copyWith(fontSize: 16 * scale),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 72);

    setState(() {
      _calculatedExpandedHeight = kToolbarHeight + textPainter.height + 32;
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
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final backgroundColor = widget.backgroundColor ?? colors.surface.backgroundContrast;

    return SliverAppBar(
      expandedHeight: _calculatedExpandedHeight,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      foregroundColor: colors.textTokens.primary,
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      flexibleSpace: AnimatedBuilder(
        animation: _paddingAnimation,
        builder: (context, child) => FlexibleSpaceBar(
          expandedTitleScale: 1.3,
          titlePadding: EdgeInsets.only(
            bottom: 16,
            left: lerpDouble(20, 28, _paddingAnimation.value) ?? 24,
          ),
          title: child,
          background: ColoredBox(color: backgroundColor),
        ),
        child: Row(
          children: [
            if (widget.leading != null)
              AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(-28 * _opacityAnimation.value, 0),
                  child: Opacity(
                    opacity: 1 - _opacityAnimation.value,
                    child: child,
                  ),
                ),
                child: widget.leading,
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(
                  widget.title,
                  style: widget.titleStyle ?? fonts.text.md.medium,
                  maxLines: widget.maxLines,
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
