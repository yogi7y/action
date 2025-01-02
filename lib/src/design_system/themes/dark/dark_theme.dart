import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors/primitive_tokens.dart';
import '../base/semantics/bottom_navigation_bar.dart';
import '../base/semantics/button.dart';
import '../base/semantics/checkbox.dart';
import '../base/semantics/chips.dart';
import '../base/semantics/l2_screen_header_tokens.dart';
import '../base/semantics/project_card_tokens.dart';
import '../base/semantics/status_tokens.dart';
import '../base/semantics/surface.dart';
import '../base/semantics/tab_bar_inline_tokens.dart';
import '../base/semantics/task_detail_overview_tile_token.dart';
import '../base/semantics/text.dart';
import '../base/theme.dart';
import '../light/semantics/project_card_tokens.dart';
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

final darkThemeColorsProvider = Provider<DarkTheme>((ref) {
  final _primitiveTokens = ref.watch(primitiveTokensProvider);
  return DarkTheme(primitiveTokens: _primitiveTokens);
});

@immutable
class DarkBaseTheme implements BaseTheme {
  DarkBaseTheme({
    required this.primitiveTokens,
  })  : primary = primitiveTokens.rose.shade500,
        accentTint = const Color(0xFF283344),
        accentShade = primitiveTokens.dark,
        surface = DarkSurface(primitiveTokens),
        textTokens = DarkTextTokens(primitiveTokens);

  final PrimitiveColorTokens primitiveTokens;

  @override
  final Color primary;
  @override
  final Color accentTint;

  @override
  final Color accentShade;

  @override
  final SurfaceTokens surface;

  @override
  final TextTokens textTokens;
}

@immutable
class DarkTheme extends DarkBaseTheme implements AppTheme {
  DarkTheme({required super.primitiveTokens})
      : selectedBottomNavigationItem =
            DarkBottomNavigationSelectedTokens(primitiveTokens: primitiveTokens),
        unselectedBottomNavigationItem =
            DarkBottomNavigationUnSelectedTokens(primitiveTokens: primitiveTokens),
        selectedCheckbox = DarkCheckboxSelectedTokens(primitiveTokens: primitiveTokens),
        unselectedCheckbox = DarkCheckboxUnselectedTokens(primitiveTokens: primitiveTokens),
        intermediateCheckbox = DarkCheckboxIntermediateTokens(primitiveTokens: primitiveTokens),
        primaryButton = DarkPrimaryButtonTokens(primitiveTokens: primitiveTokens),
        secondaryButton = DarkSecondaryButtonTokens(primitiveTokens: primitiveTokens),
        unselectedChips = DarkUnselectedChipsTokens(primitiveTokens: primitiveTokens),
        selectedChips = DarkSelectedChipsTokens(primitiveTokens: primitiveTokens),
        selectableChipsSelected =
            DarkSelectableChipsSelectedTokens(primitiveTokens: primitiveTokens),
        selectableChipsUnselected =
            DarkSelectableChipsUnselectedTokens(primitiveTokens: primitiveTokens),
        statusTodo = DarkStatusTodoTokens(primitiveTokens: primitiveTokens),
        statusInProgress = DarkStatusInProgressTokens(primitiveTokens: primitiveTokens),
        statusDone = DarkStatusDoneTokens(primitiveTokens: primitiveTokens),
        projectCard = DarkProjectCardTokens(primitiveTokens: primitiveTokens),
        textDetailOverviewTileHasValue =
            DarkTextDetailOverviewTileHasValueTokens(primitiveTokens: primitiveTokens),
        textDetailOverviewTileNoValue =
            DarkTextDetailOverviewTileNoValueTokens(primitiveTokens: primitiveTokens),
        l2Screen = DarkL2ScreenHeaderTokens(primitiveTokens: primitiveTokens),
        tabBar = DarkTabBarTokens(primitiveTokens: primitiveTokens);

  @override
  final BottomNavigationBarTokens selectedBottomNavigationItem;

  @override
  final BottomNavigationBarTokens unselectedBottomNavigationItem;

  @override
  final CheckboxTokens selectedCheckbox;

  @override
  final CheckboxTokens unselectedCheckbox;

  @override
  final CheckboxTokens intermediateCheckbox;

  @override
  final ButtonTokens primaryButton;

  @override
  final ButtonTokens secondaryButton;

  @override
  final ChipsTokens unselectedChips;

  @override
  final ChipsTokens selectedChips;

  @override
  final SelectableChipsTokens selectableChipsSelected;

  @override
  final SelectableChipsTokens selectableChipsUnselected;

  @override
  final StatusTokens statusTodo;

  @override
  final StatusTokens statusInProgress;

  @override
  final StatusTokens statusDone;

  @override
  final ProjectCardTokens projectCard;

  @override
  final TextDetailOverviewTileTokens textDetailOverviewTileHasValue;

  @override
  final TextDetailOverviewTileTokens textDetailOverviewTileNoValue;

  @override
  final L2ScreenHeaderTokens l2Screen;

  @override
  final TabBarTokens tabBar;
}
