import 'package:flutter/material.dart';

import 'semantics/bottom_navigation_bar.dart';
import 'semantics/surface.dart';
import 'semantics/text.dart';

@immutable
abstract class BaseTheme {
  const BaseTheme({
    required this.primary,
    required this.surface,
    required this.textTokens,
  });

  final Color primary;
  final SurfaceTokens surface;
  final TextTokens textTokens;
}

@immutable
abstract class ComponentThemes {
  const ComponentThemes({
    required this.selectedBottomNavigationItem,
    required this.unselectedBottomNavigationItem,
  });

  final BottomNavigationBarTokens selectedBottomNavigationItem;
  final BottomNavigationBarTokens unselectedBottomNavigationItem;
}
