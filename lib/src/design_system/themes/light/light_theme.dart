import 'package:flutter/material.dart';

import '../../colors/primitive_tokens.dart';
import '../base/semantics/bottom_navigation_bar.dart';
import '../base/semantics/surface.dart';
import '../base/semantics/text.dart';
import '../base/theme.dart';
import 'semantics/bottom_navigation_bar.dart';
import 'semantics/surface.dart';
import 'semantics/text.dart';

class LightBaseTheme implements BaseTheme {
  const LightBaseTheme({
    required this.primitiveTokens,
  });

  final PrimitiveColorTokens primitiveTokens;

  @override
  Color get primary => primitiveTokens.rose.shade400;

  @override
  SurfaceTokens get surface => LightSurface(primitiveTokens);

  @override
  TextTokens get textTokens => LightTextTokens(primitiveTokens);
}

@immutable
class LightTheme extends LightBaseTheme implements ComponentThemes {
  const LightTheme({required super.primitiveTokens});

  @override
  BottomNavigationBarTokens get selectedBottomNavigationItem =>
      LightBottomNavigationSelectedTokens(primitiveTokens: primitiveTokens);

  @override
  BottomNavigationBarTokens get unselectedBottomNavigationItem =>
      LightBottomNavigationUnSelectedTokens(primitiveTokens: primitiveTokens);
}
