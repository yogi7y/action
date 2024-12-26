import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../../modules/dashboard/presentation/state/keyboard_visibility_provider.dart';
import 'sticky_keyboard_provider.dart';
import 'sticky_options.dart';
import 'sticky_text_field.dart';

class StickyComponentOverKeyboard extends ConsumerWidget {
  const StickyComponentOverKeyboard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isKeyboardVisible = ref.watch(keyboardVisibilityProvider).value ?? false;

    if (!_isKeyboardVisible) return const SizedBox.shrink();

    return AnimatedPositioned(
      bottom: 0,
      duration: defaultAnimationDuration,
      child: _StickComponentData(),
    );
  }
}

class _StickComponentData extends ConsumerStatefulWidget {
  @override
  ConsumerState<_StickComponentData> createState() => _StickComponentDataState();
}

class _StickComponentDataState extends ConsumerState<_StickComponentData> {
  late final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeight());
  }

  void _updateHeight() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final height = renderBox.size.height;
      ref.read(stickyComponentHeightProvider.notifier).state = height;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);

    final _showStickyKeyboard = ref.watch(showStickyTextFieldProvider);

    final _height = ref.watch(stickyComponentHeightProvider);
    final _size = MediaQuery.of(context).size;

    return Container(
      key: _key,
      height: _height,
      padding: EdgeInsets.symmetric(
        horizontal: _spacing.md,
        vertical: _spacing.sm,
      ),
      decoration: BoxDecoration(
        color: _colors.surface.backgroundContrast,
      ),
      width: _size.width,
      child: _showStickyKeyboard ? const StickyTextField() : const StickyOptions(),
    );
  }
}
