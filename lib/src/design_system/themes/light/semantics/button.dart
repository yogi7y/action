import 'package:flutter/material.dart';

import '../../base/semantics/button.dart';
import '../light_theme.dart';

@immutable
class LightPrimaryButtonTokens extends LightTheme implements ButtonTokens {
  const LightPrimaryButtonTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.rose.shade300;

  @override
  Color get text => primitiveTokens.white;
}
