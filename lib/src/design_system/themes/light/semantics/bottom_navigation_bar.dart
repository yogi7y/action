import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../base/semantics/bottom_navigation_bar.dart';
import '../light_theme.dart';

@immutable
class LightBottomNavigationSelectedTokens extends LightBaseTheme
    implements BottomNavigationBarTokens {
  LightBottomNavigationSelectedTokens({required super.primitiveTokens});

  @override
  Color get background => primary;

  @override
  Color get text => primitiveTokens.white;
}

@immutable
class LightBottomNavigationUnSelectedTokens extends LightBaseTheme
    implements BottomNavigationBarTokens {
  LightBottomNavigationUnSelectedTokens({required super.primitiveTokens});

  @override
  Color get background => surface.modals;

  @override
  Color get text => textTokens.secondary;
}
