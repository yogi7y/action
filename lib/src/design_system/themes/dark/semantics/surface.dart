import 'package:flutter/foundation.dart';

import '../../../colors/primitive_tokens.dart';
import '../../base/semantics/surface.dart';

@immutable
class DarkSurface extends SurfaceTokens {
  DarkSurface(this._tokens)
      : super(
          background: _tokens.neutral.shade900,
          backgroundContrast: _tokens.dark,
          modals: _tokens.neutral.shade800,
        );

  // ignore: unused_field
  final PrimitiveColorTokens _tokens;
}
