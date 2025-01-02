import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dark/dark_theme.dart';
import '../light/light_theme.dart';
import 'semantics/bottom_navigation_bar.dart';
import 'semantics/button.dart';
import 'semantics/checkbox.dart';
import 'semantics/chips.dart';
import 'semantics/l2_screen_header_tokens.dart';
import 'semantics/project_card_tokens.dart';
import 'semantics/status_tokens.dart';
import 'semantics/surface.dart';
import 'semantics/tab_bar_inline_tokens.dart';
import 'semantics/task_detail_overview_tile_token.dart';
import 'semantics/text.dart';

enum AppThemeType { light, dark }

final appThemeProvider = NotifierProvider<AppThemeNotifier, AppTheme>(AppThemeNotifier.new);

class AppThemeNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() {
    final _darkTheme = ref.watch(darkThemeColorsProvider);
    final _lightTheme = ref.watch(lightThemeColorsProvider);
    return _darkTheme;
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
    required this.accentShade,
    required this.accentTint,
  });

  final Color primary;
  final Color accentShade;
  final Color accentTint;
  final SurfaceTokens surface;
  final TextTokens textTokens;
}

@immutable
abstract class AppTheme extends BaseTheme {
  const AppTheme({
    required super.primary,
    required super.surface,
    required super.textTokens,
    required super.accentShade,
    required super.accentTint,
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
    required this.statusTodo,
    required this.statusInProgress,
    required this.statusDone,
    required this.projectCard,
    required this.textDetailOverviewTileHasValue,
    required this.textDetailOverviewTileNoValue,
    required this.l2Screen,
    required this.tabBar,
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
  final StatusTokens statusTodo;
  final StatusTokens statusInProgress;
  final StatusTokens statusDone;
  final ProjectCardTokens projectCard;
  final TextDetailOverviewTileTokens textDetailOverviewTileHasValue;
  final TextDetailOverviewTileTokens textDetailOverviewTileNoValue;
  final L2ScreenHeaderTokens l2Screen;
  final TabBarTokens tabBar;
}
