import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dark/dark_theme.dart';
import '../light/light_theme.dart';
import 'semantics/bottom_navigation_bar.dart';
import 'semantics/button.dart';
import 'semantics/checkbox.dart';
import 'semantics/chips.dart';
import 'semantics/surface.dart';
import 'semantics/text.dart';

enum AppThemeType { light, dark }

final appThemeProvider = NotifierProvider<AppThemeNotifier, AppTheme>(AppThemeNotifier.new);

class AppThemeNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() {
    final _darkTheme = ref.watch(darkThemeColorsProvider);
    final _lightTheme = ref.watch(lightThemeColorsProvider);
    return _lightTheme;
  }

  void toggle() {
    final _darkTheme = ref.watch(darkThemeColorsProvider);
    final _lightTheme = ref.watch(lightThemeColorsProvider);

    state = state is LightTheme ? _darkTheme : _lightTheme;
  }
}

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
abstract class AppTheme extends BaseTheme {
  const AppTheme({
    required super.primary,
    required super.surface,
    required super.textTokens,
    required this.selectedBottomNavigationItem,
    required this.unselectedBottomNavigationItem,
    required this.selectedCheckbox,
    required this.unselectedCheckbox,
    required this.intermediateCheckbox,
    required this.primaryButton,
    required this.secondaryButton,
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
  final ButtonTokens secondaryButton;
  final ChipsTokens unselectedChips;
  final ChipsTokens selectedChips;
  final SelectableChipsTokens selectableChipsSelected;
  final SelectableChipsTokens selectableChipsUnselected;
}
