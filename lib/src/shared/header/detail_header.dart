import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';

class DetailHeader extends ConsumerWidget {
  const DetailHeader({
    required this.data,
    super.key,
  });

  final DetailHeaderData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        detailHeaderTitleProvider.overrideWith((ref) => data.title),
        _detailHeaderDataProvider.overrideWith((ref) => data),
      ],
      child: const _DetailHeader(),
    );
  }
}

class _DetailHeader extends ConsumerStatefulWidget {
  const _DetailHeader();

  @override
  ConsumerState<_DetailHeader> createState() => _DetailHeaderState();
}

class _DetailHeaderState extends ConsumerState<_DetailHeader> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(vsync: this);
  late final Animation<double> _paddingAnimation;
  late final Animation<double> _opacityAnimation;
  late var _calculatedExpandedHeight = kToolbarHeight * 2;
  late final controller = TextEditingController();
  Timer? _debounceTimer;

  late final data = ref.read(_detailHeaderDataProvider);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = ref.read(_detailHeaderDataProvider);
      data.scrollController.addListener(_updateAnimation);

      _calculateExpandedHeight();
      syncControllerAndValue();
    });

    _paddingAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 0.8, curve: Curves.easeInQuart),
    );

    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 0.7, curve: Curves.easeInQuart),
    );
  }

  void syncControllerAndValue() {
    controller
      ..text = ref.read(detailHeaderTitleProvider)
      ..addListener(() {
        final newText = controller.text;
        ref.read(detailHeaderTitleProvider.notifier).state = newText;

        final onTextChanged = ref.read(_detailHeaderDataProvider).onTextChanged;
        if (onTextChanged != null) {
          _debounceTimer?.cancel();
          _debounceTimer = Timer(const Duration(seconds: 2), () {
            onTextChanged(newText);
          });
        }
      });
  }

  void _calculateExpandedHeight() {
    if (!mounted) return;

    if (data.expandedHeight != null) {
      setState(() => _calculatedExpandedHeight = data.expandedHeight!);
      return;
    }

    final titleLength = data.title.length;
    final scale = titleLength > 40 ? 1.3 : 1.0;

    final textSpan = TextSpan(
      text: data.title,
      style: (data.titleStyle ?? ref.read(fontsProvider).text.md.medium)
          .copyWith(fontSize: 16 * scale),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: data.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 72);

    setState(() {
      _calculatedExpandedHeight = kToolbarHeight + textPainter.height + 32;
    });
  }

  void _updateAnimation() {
    final scrollProgress = (data.scrollController.offset / (kToolbarHeight * 1.2)).clamp(0.0, 1.0);
    _animationController.value = scrollProgress;
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final backgroundColor = data.backgroundColor ?? colors.surface.backgroundContrast;

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
            bottom: lerpDouble(16, 16, _paddingAnimation.value) ?? 0,
            left: lerpDouble(20, 28, _paddingAnimation.value) ?? 24,
          ),
          title: child,
          background: ColoredBox(color: backgroundColor),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.leading != null)
              AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(-28 * _opacityAnimation.value, 0),
                  child: Opacity(
                    opacity: 1 - _opacityAnimation.value,
                    child: child,
                  ),
                ),
                child: data.leading,
              ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final isInEditMode = ref.watch(_isInEditModeProvider);

                  return Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: isInEditMode
                        ? TextFormField(
                            controller: controller,
                            style: (data.titleStyle ?? fonts.text.md.medium)
                                .copyWith(letterSpacing: 0),
                            minLines: 1,
                            maxLines: data.maxLines,
                            scrollPadding: EdgeInsets.zero,
                            onTapOutside: (_) =>
                                ref.read(_isInEditModeProvider.notifier).state = false,
                            autofocus: true,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              border: InputBorder.none,
                            ),
                          )
                        : GestureDetector(
                            onTap: () => ref.read(_isInEditModeProvider.notifier).state = true,
                            child: Consumer(
                              builder: (context, ref, child) {
                                final title = ref.watch(detailHeaderTitleProvider);

                                return Text(
                                  title,
                                  style: data.titleStyle ?? fonts.text.md.medium,
                                  maxLines: data.maxLines,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _detailHeaderDataProvider = Provider<DetailHeaderData>(
  (ref) => throw UnimplementedError('Ensure to override detailHeaderDataProvider'),
  name: 'detailHeaderDataProvider',
);
final detailHeaderTitleProvider = StateProvider<String>(
  (ref) => '',
  name: 'detailHeaderTitleProvider',
);
final _isInEditModeProvider = StateProvider<bool>(
  (ref) => false,
  name: 'isInEditModeProvider',
);

@immutable
class DetailHeaderData {
  const DetailHeaderData({
    required this.title,
    required this.scrollController,
    this.leading,
    this.expandedHeight,
    this.titleStyle,
    this.backgroundColor,
    this.maxLines = 3,
    this.onTextChanged,
  });

  /// The String that is displayed in the header.
  final String title;
  final ScrollController scrollController;
  final Widget? leading;
  final double? expandedHeight;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final int maxLines;

  /// Callback triggered when text is changed, with debounce of 2 seconds
  final void Function(String)? onTextChanged;
}
