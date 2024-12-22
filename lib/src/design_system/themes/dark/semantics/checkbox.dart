import 'package:flutter/material.dart';

import '../../base/semantics/checkbox.dart';
import '../dark_theme.dart';

@immutable
class DarkCheckboxUnselectedTokens extends DarkBaseTheme implements CheckboxTokens {
  DarkCheckboxUnselectedTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.neutral.shade500;

  @override
  Color get border => primitiveTokens.neutral.shade500;
}

@immutable
class DarkCheckboxSelectedTokens extends DarkBaseTheme implements CheckboxTokens {
  DarkCheckboxSelectedTokens({required super.primitiveTokens});

  @override
  Color get background => primary;

  @override
  Color get border => primary;
}

@immutable
class DarkCheckboxIntermediateTokens extends DarkBaseTheme implements CheckboxTokens {
  DarkCheckboxIntermediateTokens({required super.primitiveTokens});

  @override
  Color get background => primary;

  @override
  Color get border => primary;
}
