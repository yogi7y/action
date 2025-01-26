import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/router.dart';
import '../../core/router/routes.dart';
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
    final isKeyboardVisible = ref.watch(keyboardVisibilityProvider).value ?? false;
    final currentRoute = ref.watch(routerProvider).state.path;

    if (!isKeyboardVisible || currentRoute != AppRoute.tasks.path) return const SizedBox.shrink();

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
    final spacing = ref.watch(spacingProvider);
    final colors = ref.watch(appThemeProvider);

    final showStickyKeyboard = ref.watch(showStickyTextFieldProvider);

    final height = ref.watch(stickyComponentHeightProvider);
    final size = MediaQuery.of(context).size;

    return Container(
      key: _key,
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surface.backgroundContrast,
      ),
      width: size.width,
      child: showStickyKeyboard ? const StickyTextField() : const StickyOptions(),
    );
  }
}
