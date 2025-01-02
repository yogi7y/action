import 'package:flutter/material.dart';

import '../../base/semantics/tab_bar_inline_tokens.dart';
import '../dark_theme.dart';

@immutable
class DarkTabBarTokens extends DarkBaseTheme implements TabBarTokens {
  DarkTabBarTokens({required super.primitiveTokens});

  @override
  Color get underlineBorder => primitiveTokens.neutral.shade800;

  @override
  Color get indicator => primary;

  @override
  Color get selectedTextColor => textTokens.primary;

  @override
  Color get unselectedTextColor => textTokens.secondary;
}
