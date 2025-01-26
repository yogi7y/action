import 'package:flutter/material.dart';

import '../../base/semantics/l2_screen_header_tokens.dart';
import '../light_theme.dart';

@immutable
class LightL2ScreenHeaderTokens extends LightBaseTheme implements L2ScreenHeaderTokens {
  LightL2ScreenHeaderTokens({required super.primitiveTokens});

  @override
  Color get background => accentShade;

  @override
  Color get foreground => textTokens.primary;
}
