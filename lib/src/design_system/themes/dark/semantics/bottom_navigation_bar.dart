import 'package:flutter/material.dart';

import '../../base/semantics/bottom_navigation_bar.dart';
import '../dark_theme.dart';

@immutable
class DarkBottomNavigationSelectedTokens extends DarkTheme implements BottomNavigationBarTokens {
  const DarkBottomNavigationSelectedTokens({required super.primitiveTokens});

  @override
  Color get background => primary;

  @override
  Color get text => primitiveTokens.white;
}

@immutable
class DarkBottomNavigationUnSelectedTokens extends DarkTheme implements BottomNavigationBarTokens {
  const DarkBottomNavigationUnSelectedTokens({required super.primitiveTokens});

  @override
  Color get background => surface.modals;

  @override
  Color get text => textTokens.secondary;
}
