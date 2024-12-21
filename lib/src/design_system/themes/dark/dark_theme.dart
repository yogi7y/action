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

class DarkBaseTheme implements BaseTheme {
  const DarkBaseTheme({
    required this.primitiveTokens,
  });

  final PrimitiveColorTokens primitiveTokens;

  @override
  Color get primary => primitiveTokens.rose.shade500;

  @override
  SurfaceTokens get surface => DarkSurface(primitiveTokens);

  @override
  TextTokens get textTokens => DarkTextTokens(primitiveTokens);
}

@immutable
class DarkTheme extends DarkBaseTheme implements ComponentThemes {
  const DarkTheme({required super.primitiveTokens});

  @override
  BottomNavigationBarTokens get selectedBottomNavigationItem =>
      DarkBottomNavigationSelectedTokens(primitiveTokens: primitiveTokens);

  @override
  BottomNavigationBarTokens get unselectedBottomNavigationItem =>
      DarkBottomNavigationUnSelectedTokens(primitiveTokens: primitiveTokens);
  @override
  CheckboxTokens get selectedCheckbox =>
      DarkCheckboxSelectedTokens(primitiveTokens: primitiveTokens);

  @override
  CheckboxTokens get unselectedCheckbox =>
      DarkCheckboxUnselectedTokens(primitiveTokens: primitiveTokens);

  @override
  CheckboxTokens get intermediateCheckbox =>
      DarkCheckboxIntermediateTokens(primitiveTokens: primitiveTokens);

  @override
  ButtonTokens get primaryButton => DarkPrimaryButtonTokens(primitiveTokens: primitiveTokens);

  @override
  ChipsTokens get unselectedChips => DarkUnselectedChipsTokens(primitiveTokens: primitiveTokens);

  @override
  ChipsTokens get selectedChips => DarkSelectedChipsTokens(primitiveTokens: primitiveTokens);

  @override
  SelectableChipsTokens get selectableChipsSelected =>
      DarkSelectableChipsSelectedTokens(primitiveTokens: primitiveTokens);

  @override
  SelectableChipsTokens get selectableChipsUnselected =>
      DarkSelectableChipsUnselectedTokens(primitiveTokens: primitiveTokens);
}
