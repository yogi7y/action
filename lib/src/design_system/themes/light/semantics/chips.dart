import 'package:flutter/material.dart';

import '../../base/semantics/chips.dart';
import '../light_theme.dart';

@immutable
class LightUnselectedChipsTokens extends LightTheme implements ChipsTokens {
  const LightUnselectedChipsTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.neutral.shade200;

  @override
  Color get text => primitiveTokens.neutral.shade600;
}

@immutable
class LightSelectedChipsTokens extends LightTheme implements ChipsTokens {
  const LightSelectedChipsTokens({required super.primitiveTokens});

  @override
  Color get background => primary;

  @override
  Color get text => primitiveTokens.white;
}

@immutable
class LightSelectableChipsSelectedTokens extends LightTheme implements SelectableChipsTokens {
  const LightSelectableChipsSelectedTokens({required super.primitiveTokens});

  @override
  Color get border => primitiveTokens.neutral.shade200;

  @override
  Color get foregroundColor => textTokens.secondary;
}

@immutable
class LightSelectableChipsUnselectedTokens extends LightTheme implements SelectableChipsTokens {
  const LightSelectableChipsUnselectedTokens({required super.primitiveTokens});

  @override
  Color get border => primitiveTokens.neutral.shade200;

  @override
  Color get foregroundColor => textTokens.tertiary;
}
