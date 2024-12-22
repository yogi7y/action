import 'package:flutter/material.dart';

import '../../base/semantics/chips.dart';
import '../light_theme.dart';

@immutable
class LightUnselectedChipsTokens extends LightBaseTheme implements ChipsTokens {
  LightUnselectedChipsTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.neutral.shade200;

  @override
  Color get text => primitiveTokens.neutral.shade600;
}

@immutable
class LightSelectedChipsTokens extends LightBaseTheme implements ChipsTokens {
  LightSelectedChipsTokens({required super.primitiveTokens});

  @override
  Color get background => primary;

  @override
  Color get text => primitiveTokens.white;
}

@immutable
class LightSelectableChipsSelectedTokens extends LightBaseTheme implements SelectableChipsTokens {
  LightSelectableChipsSelectedTokens({required super.primitiveTokens});

  @override
  Color get border => primitiveTokens.neutral.shade200;

  @override
  Color get foregroundColor => textTokens.secondary;
}

@immutable
class LightSelectableChipsUnselectedTokens extends LightBaseTheme implements SelectableChipsTokens {
  LightSelectableChipsUnselectedTokens({required super.primitiveTokens});

  @override
  Color get border => primitiveTokens.neutral.shade200;

  @override
  Color get foregroundColor => textTokens.tertiary;
}
