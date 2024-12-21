import 'package:flutter/material.dart';

import '../../../colors/primitive_tokens.dart';
import '../../base/semantics/text.dart';

@immutable
class DarkTextTokens implements TextTokens {
  const DarkTextTokens(this._tokens);

  final PrimitiveColorTokens _tokens;

  @override
  Color get primary => _tokens.neutral.shade100;

  @override
  Color get secondary => _tokens.neutral.shade400;

  @override
  Color get tertiary => _tokens.neutral.shade500;
}
