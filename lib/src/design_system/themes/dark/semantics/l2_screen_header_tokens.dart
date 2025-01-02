import 'package:flutter/material.dart';

import '../../base/semantics/l2_screen_header_tokens.dart';
import '../dark_theme.dart';

@immutable
class DarkL2ScreenHeaderTokens extends DarkBaseTheme implements L2ScreenHeaderTokens {
  DarkL2ScreenHeaderTokens({required super.primitiveTokens});

  @override
  Color get background => accentShade;

  @override
  Color get foreground => textTokens.primary;
}
