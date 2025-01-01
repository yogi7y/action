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
import '../base/semantics/task_detail_overview_tile_token.dart';
import '../base/semantics/text.dart';
import '../base/theme.dart';
import 'semantics/bottom_navigation_bar.dart';
import 'semantics/button.dart';
import 'semantics/checkbox.dart';
import 'semantics/chips.dart';
import 'semantics/l2_screen_header_tokens.dart';
import 'semantics/project_card_tokens.dart';
import 'semantics/status_tokens.dart';
import 'semantics/surface.dart';
import 'semantics/task_detail_overview_tile_token.dart';
import 'semantics/text.dart';

final lightThemeColorsProvider = Provider<LightTheme>((ref) {
  final _primitiveTokens = ref.watch(primitiveTokensProvider);
  return LightTheme(primitiveTokens: _primitiveTokens);
});

@immutable
class LightBaseTheme implements BaseTheme {
  LightBaseTheme({
    required this.primitiveTokens,
  })  : primary = primitiveTokens.rose.shade400,
        accentShade = primitiveTokens.neutral.shade50,
        accentTint = primitiveTokens.rose.shade50,
        surface = LightSurfaceTokens(primitiveTokens),
        textTokens = LightTextTokens(primitiveTokens);

  final PrimitiveColorTokens primitiveTokens;

  @override
  final Color primary;

  @override
  final SurfaceTokens surface;

  @override
  final TextTokens textTokens;

  @override
  final Color accentShade;

  @override
  final Color accentTint;
}

@immutable
class LightTheme extends LightBaseTheme implements AppTheme {
  LightTheme({required super.primitiveTokens})
      : selectedBottomNavigationItem =
            LightBottomNavigationSelectedTokens(primitiveTokens: primitiveTokens),
        unselectedBottomNavigationItem =
            LightBottomNavigationUnSelectedTokens(primitiveTokens: primitiveTokens),
        selectedCheckbox = LightCheckboxSelectedTokens(primitiveTokens: primitiveTokens),
        unselectedCheckbox = LightCheckboxUnselectedTokens(primitiveTokens: primitiveTokens),
        intermediateCheckbox = LightCheckboxIntermediateTokens(primitiveTokens: primitiveTokens),
        primaryButton = LightPrimaryButtonTokens(primitiveTokens: primitiveTokens),
        secondaryButton = LightSecondaryButtonTokens(primitiveTokens: primitiveTokens),
        unselectedChips = LightUnselectedChipsTokens(primitiveTokens: primitiveTokens),
        selectedChips = LightSelectedChipsTokens(primitiveTokens: primitiveTokens),
        selectableChipsSelected =
            LightSelectableChipsSelectedTokens(primitiveTokens: primitiveTokens),
        selectableChipsUnselected =
            LightSelectableChipsUnselectedTokens(primitiveTokens: primitiveTokens),
        statusTodo = LightStatusTodoTokens(primitiveTokens: primitiveTokens),
        statusInProgress = LightStatusInProgressTokens(primitiveTokens: primitiveTokens),
        statusDone = LightStatusDoneTokens(primitiveTokens: primitiveTokens),
        projectCard = LightProjectCardTokens(primitiveTokens: primitiveTokens),
        textDetailOverviewTileHasValue =
            LightTextDetailOverviewTileHasValueTokens(primitiveTokens: primitiveTokens),
        textDetailOverviewTileNoValue =
            LightTextDetailOverviewTileNoValueTokens(primitiveTokens: primitiveTokens),
        l2Screen = LightL2ScreenHeaderTokens(primitiveTokens: primitiveTokens);

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
}
