import 'package:flutter/foundation.dart';

import '../../../colors/primitive_tokens.dart';
import '../../base/semantics/text.dart';

@immutable
class DarkTextTokens extends TextTokens {
  DarkTextTokens(this._tokens)
      : super(
          primary: _tokens.neutral.shade100,
          secondary: _tokens.neutral.shade400,
          tertiary: _tokens.neutral.shade500,
        );

  // ignore: unused_field
  final PrimitiveColorTokens _tokens;
}
