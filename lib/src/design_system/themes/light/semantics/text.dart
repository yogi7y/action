import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../../colors/primitive_tokens.dart';
import '../../base/semantics/text.dart';

@immutable
class LightTextTokens implements TextTokens {
  const LightTextTokens(this.primitiveTokens);

  final PrimitiveColorTokens primitiveTokens;

  @override
  Color get primary => primitiveTokens.neutral.shade700;

  @override
  Color get secondary => primitiveTokens.neutral.shade500;

  @override
  Color get tertiary => primitiveTokens.neutral.shade400;
}
