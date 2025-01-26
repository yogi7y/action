import 'package:flutter/material.dart';

import '../../base/semantics/project_card_tokens.dart';
import '../dark_theme.dart';

@immutable
class DarkProjectCardTokens extends DarkBaseTheme implements ProjectCardTokens {
  DarkProjectCardTokens({required super.primitiveTokens})
      : headerBackground = const Color(0xFF283344),
        background = primitiveTokens.neutral.shade800,
        titleForeground = primitiveTokens.neutral.shade50,
        subtitleForeground = primitiveTokens.neutral.shade400,
        shadow = const Color(0xFF090F20).withValues(alpha: .2);

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
