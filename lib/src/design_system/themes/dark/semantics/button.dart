import 'package:flutter/material.dart';

import '../../base/semantics/button.dart';
import '../dark_theme.dart';

@immutable
class DarkPrimaryButtonTokens extends DarkTheme implements ButtonTokens {
  const DarkPrimaryButtonTokens({required super.primitiveTokens});

  @override
  Color get background => primitiveTokens.rose.shade500;

  @override
  Color get text => primitiveTokens.white;
}
