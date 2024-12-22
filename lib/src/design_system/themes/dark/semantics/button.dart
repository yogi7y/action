import 'package:flutter/material.dart';

import '../../base/semantics/button.dart';
import '../dark_theme.dart';

@immutable
class DarkPrimaryButtonTokens extends DarkBaseTheme implements ButtonTokens {
  DarkPrimaryButtonTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.rose.shade500;

  @override
  Color get text => primitiveTokens.white;

  @override
  Color get shadow => primitiveTokens.dark;
}

@immutable
class DarkSecondaryButtonTokens extends DarkBaseTheme implements ButtonTokens {
  DarkSecondaryButtonTokens({required super.primitiveTokens});

  @override
  Color get background => surface.modals;

  @override
  Color get text => textTokens.primary;

  @override
  Color get shadow => primitiveTokens.dark;
}
