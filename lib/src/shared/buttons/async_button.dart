import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/spacing/spacing.dart';
import '../../design_system/typography/typography.dart';
import '../../modules/dashboard/presentation/state/app_theme.dart';

enum AsyncButtonType { primary, secondary }

class AsyncButton extends ConsumerWidget {
  const AsyncButton({
    required this.text,
    required this.onClick,
    this.type = AsyncButtonType.primary,
    super.key,
  });

  final String text;
  final AsyncCallback onClick;
  final AsyncButtonType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _fonts = ref.watch(fontsProvider);
    final _colors = ref.watch(appThemeProvider);
    final _spacing = ref.watch(spacingProvider);

    final _buttonTheme =
        type == AsyncButtonType.primary ? _colors.primaryButton : _colors.secondaryButton;

    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _spacing.md,
          vertical: _spacing.sm,
        ),
        decoration: ShapeDecoration(
            color: _buttonTheme.background,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1),
            ),
            shadows: [
              BoxShadow(
                color: _buttonTheme.shadow.withValues(alpha: .1),
                offset: const Offset(0, 2),
                blurRadius: 4,
              )
            ]),
        child: Text(
          text,
          style: _fonts.text.md.semibold.copyWith(
            color: _buttonTheme.text,
          ),
        ),
      ),
    );
  }
}
