import 'package:flutter/material.dart';

import '../../base/semantics/chips.dart';
import '../dark_theme.dart';

@immutable
class DarkUnselectedChipsTokens extends DarkTheme implements ChipsTokens {
  const DarkUnselectedChipsTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.neutral.shade800;

  @override
  Color get text => primitiveTokens.neutral.shade200;
}

@immutable
class DarkSelectedChipsTokens extends DarkTheme implements ChipsTokens {
  const DarkSelectedChipsTokens({required super.primitiveTokens});

  @override
  Color get background => primary;

  @override
  Color get text => primitiveTokens.white;
}

@immutable
class DarkSelectableChipsSelectedTokens extends DarkTheme implements SelectableChipsTokens {
  const DarkSelectableChipsSelectedTokens({required super.primitiveTokens});

  @override
  Color get border => primitiveTokens.neutral.shade700;

  @override
  Color get foregroundColor => textTokens.primary;
}

@immutable
class DarkSelectableChipsUnselectedTokens extends DarkTheme implements SelectableChipsTokens {
  const DarkSelectableChipsUnselectedTokens({required super.primitiveTokens});

  @override
  Color get border => primitiveTokens.neutral.shade700;

  @override
  Color get foregroundColor => textTokens.tertiary;
}
