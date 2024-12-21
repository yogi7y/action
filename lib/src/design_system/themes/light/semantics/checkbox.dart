import 'package:flutter/material.dart';

import '../../base/semantics/checkbox.dart';
import '../light_theme.dart';

@immutable
class LightCheckboxUnselectedTokens extends LightTheme implements CheckboxTokens {
  const LightCheckboxUnselectedTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.neutral.shade400;

  @override
  Color get border => primitiveTokens.neutral.shade400;
}

@immutable
class LightCheckboxSelectedTokens extends LightTheme implements CheckboxTokens {
  const LightCheckboxSelectedTokens({required super.primitiveTokens});

  @override
  Color get background => primary;

  @override
  Color get border => primary;
}

@immutable
class LightCheckboxIntermediateTokens extends LightTheme implements CheckboxTokens {
  const LightCheckboxIntermediateTokens({required super.primitiveTokens});

  @override
  Color get background => primary;

  @override
  Color get border => primary;
}
