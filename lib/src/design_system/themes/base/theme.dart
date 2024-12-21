import 'package:flutter/material.dart';

import 'semantics/bottom_navigation_bar.dart';
import 'semantics/button.dart';
import 'semantics/checkbox.dart';
import 'semantics/chips.dart';
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
    required this.selectedCheckbox,
    required this.unselectedCheckbox,
    required this.intermediateCheckbox,
    required this.primaryButton,
    required this.unselectedChips,
    required this.selectedChips,
    required this.selectableChipsSelected,
    required this.selectableChipsUnselected,
  });

  final BottomNavigationBarTokens selectedBottomNavigationItem;
  final BottomNavigationBarTokens unselectedBottomNavigationItem;

  final CheckboxTokens selectedCheckbox;
  final CheckboxTokens unselectedCheckbox;
  final CheckboxTokens intermediateCheckbox;
  final ButtonTokens primaryButton;
  final ChipsTokens unselectedChips;
  final ChipsTokens selectedChips;
  final SelectableChipsTokens selectableChipsSelected;
  final SelectableChipsTokens selectableChipsUnselected;
}
