import 'package:flutter/material.dart';

import '../../base/semantics/l2_screen_header_tokens.dart';
import '../dark_theme.dart';

@immutable
class DarkL2ScreenHeaderTokens extends DarkBaseTheme implements L2ScreenHeaderTokens {
  DarkL2ScreenHeaderTokens({required super.primitiveTokens})
      : background = primitiveTokens.dark, // accent-shade
        foreground = primitiveTokens.neutral.shade100; // text/primary

  @override
  final Color background;

  @override
  final Color foreground;
}
