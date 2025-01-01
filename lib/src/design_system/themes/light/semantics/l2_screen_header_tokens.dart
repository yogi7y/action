import 'package:flutter/material.dart';

import '../../base/semantics/l2_screen_header_tokens.dart';
import '../light_theme.dart';

@immutable
class LightL2ScreenHeaderTokens extends LightBaseTheme implements L2ScreenHeaderTokens {
  LightL2ScreenHeaderTokens({required super.primitiveTokens})
      : background = primitiveTokens.neutral.shade50,
        foreground = primitiveTokens.neutral.shade700;

  @override
  final Color background;

  @override
  final Color foreground;
}
