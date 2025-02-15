import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/icons/app_icons.dart';
import '../../design_system/themes/base/theme.dart';
import 'clickable_svg.dart';

class SendIcon extends ConsumerWidget {
  const SendIcon({
    required this.onClick,
    required this.isEnabled,
    this.size = 24,
    super.key,
  });

  final AsyncCallback onClick;
  final bool isEnabled;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);

    final iconColor = isEnabled ? colors.primary : colors.textTokens.secondary;

    return Consumer(
      builder: (context, ref, _) {
        return AppIconButton(
          icon: AppIcons.chevronLeft,
          size: size,
          color: iconColor,
          onClick: () async {
            unawaited(HapticFeedback.lightImpact());
            return onClick();
          },
        );
      },
    );
  }
}
