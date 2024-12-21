import 'package:flutter/material.dart';

import '../../colors/primitive_tokens.dart';
import '../base/semantics/bottom_navigation_bar.dart';
import '../base/semantics/button.dart';
import '../base/semantics/checkbox.dart';
import '../base/semantics/chips.dart';
import '../base/semantics/surface.dart';
import '../base/semantics/text.dart';
import '../base/theme.dart';
import 'semantics/bottom_navigation_bar.dart';
import 'semantics/button.dart';
import 'semantics/checkbox.dart';
import 'semantics/chips.dart';
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
  SurfaceTokens get surface => LightSurfaceTokens(primitiveTokens);

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

  @override
  CheckboxTokens get selectedCheckbox =>
      LightCheckboxSelectedTokens(primitiveTokens: primitiveTokens);

  @override
  CheckboxTokens get unselectedCheckbox =>
      LightCheckboxUnselectedTokens(primitiveTokens: primitiveTokens);

  @override
  CheckboxTokens get intermediateCheckbox =>
      LightCheckboxIntermediateTokens(primitiveTokens: primitiveTokens);

  @override
  ButtonTokens get primaryButton => LightPrimaryButtonTokens(primitiveTokens: primitiveTokens);

  @override
  ChipsTokens get unselectedChips => LightUnselectedChipsTokens(primitiveTokens: primitiveTokens);

  @override
  ChipsTokens get selectedChips => LightSelectedChipsTokens(primitiveTokens: primitiveTokens);

  @override
  SelectableChipsTokens get selectableChipsSelected =>
      LightSelectableChipsSelectedTokens(primitiveTokens: primitiveTokens);

  @override
  SelectableChipsTokens get selectableChipsUnselected =>
      LightSelectableChipsUnselectedTokens(primitiveTokens: primitiveTokens);
}
