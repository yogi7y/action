import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';

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
    final fonts = ref.watch(fontsProvider);
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);

    final buttonTheme =
        type == AsyncButtonType.primary ? colors.primaryButton : colors.secondaryButton;

    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        decoration: ShapeDecoration(
            color: buttonTheme.background,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1),
            ),
            shadows: [
              BoxShadow(
                color: buttonTheme.shadow.withValues(alpha: .1),
                offset: const Offset(0, 2),
                blurRadius: 4,
              )
            ]),
        child: Text(
          text,
          style: fonts.text.md.semibold.copyWith(
            color: buttonTheme.text,
          ),
        ),
      ),
    );
  }
}
