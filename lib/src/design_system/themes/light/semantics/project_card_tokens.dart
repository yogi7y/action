// lib/src/design_system/themes/light/semantics/project_card.dart

import 'package:flutter/material.dart';
import '../../base/semantics/project_card_tokens.dart';
import '../light_theme.dart';

@immutable
class LightProjectCardTokens extends LightBaseTheme implements ProjectCardTokens {
  LightProjectCardTokens({required super.primitiveTokens})
      : headerBackground = primitiveTokens.rose.shade50,
        background = primitiveTokens.white,
        titleForeground = primitiveTokens.neutral.shade700,
        subtitleForeground = primitiveTokens.neutral.shade500,
        shadow = const Color(0xFFFECDD3).withValues(alpha: .1);

  @override
  final Color headerBackground;

  @override
  final Color background;

  @override
  final Color titleForeground;

  @override
  final Color subtitleForeground;

  @override
  final Color shadow;
}
