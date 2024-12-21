import 'package:flutter/foundation.dart';

import '../../../colors/primitive_tokens.dart';
import '../../base/semantics/text.dart';

@immutable
class LightTextTokens extends TextTokens {
  LightTextTokens(this._tokens)
      : super(
          primary: _tokens.neutral.shade700,
          secondary: _tokens.neutral.shade500,
          tertiary: _tokens.neutral.shade400,
        );

  // ignore: unused_field
  final PrimitiveColorTokens _tokens;
}
