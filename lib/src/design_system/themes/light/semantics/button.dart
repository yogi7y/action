import 'package:flutter/material.dart';

import '../../base/semantics/button.dart';
import '../light_theme.dart';

@immutable
class LightPrimaryButtonTokens extends LightBaseTheme implements ButtonTokens {
  LightPrimaryButtonTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.rose.shade300;

  @override
  Color get text => primitiveTokens.white;

  @override
  Color get shadow => primitiveTokens.dark;
}

@immutable
class LightSecondaryButtonTokens extends LightBaseTheme implements ButtonTokens {
  LightSecondaryButtonTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.neutral.shade200;

  @override
  Color get text => textTokens.secondary;

  @override
  Color get shadow => primitiveTokens.dark;
}
