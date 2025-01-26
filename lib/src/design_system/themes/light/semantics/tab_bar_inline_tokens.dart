import 'package:flutter/material.dart';

import '../../base/semantics/tab_bar_inline_tokens.dart';
import '../light_theme.dart';

@immutable
class LightTabBarTokens extends LightBaseTheme implements TabBarTokens {
  LightTabBarTokens({required super.primitiveTokens});

  @override
  Color get underlineBorder => primitiveTokens.neutral.shade200;

  @override
  Color get indicator => primary;

  @override
  Color get selectedTextColor => textTokens.primary;

  @override
  Color get unselectedTextColor => textTokens.secondary;
}
