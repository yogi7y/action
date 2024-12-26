import 'package:flutter/material.dart';

import '../../base/semantics/chips.dart';
import '../dark_theme.dart';

@immutable
class DarkUnselectedChipsTokens extends DarkBaseTheme implements ChipsTokens {
  DarkUnselectedChipsTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.neutral.shade800;

  @override
  Color get text => primitiveTokens.neutral.shade200;
}

@immutable
class DarkSelectedChipsTokens extends DarkBaseTheme implements ChipsTokens {
  DarkSelectedChipsTokens({required super.primitiveTokens});

  @override
  Color get background => primary;

  @override
  Color get text => primitiveTokens.white;
}

@immutable
class DarkSelectableChipsSelectedTokens extends DarkBaseTheme implements SelectableChipsTokens {
  DarkSelectableChipsSelectedTokens({required super.primitiveTokens});

  @override
  Color get border => primitiveTokens.neutral.shade600;

  @override
  Color get foregroundColor => primitiveTokens.neutral.shade50;

  @override
  Color get fillColor => surface.background;
}

@immutable
class DarkSelectableChipsUnselectedTokens extends DarkBaseTheme implements SelectableChipsTokens {
  DarkSelectableChipsUnselectedTokens({required super.primitiveTokens});

  @override
  Color get border => primitiveTokens.neutral.shade800;

  @override
  Color get foregroundColor => primitiveTokens.neutral.shade400;

  @override
  Color get fillColor => surface.backgroundContrast;
}
