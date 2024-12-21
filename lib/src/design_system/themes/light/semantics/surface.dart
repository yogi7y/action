import 'package:flutter/foundation.dart';

import '../../../colors/primitive_tokens.dart';
import '../../base/semantics/surface.dart';

@immutable
class LightSurface extends SurfaceTokens {
  LightSurface(this._tokens)
      : super(
          background: _tokens.neutral.shade100,
          backgroundContrast: _tokens.white,
          modals: _tokens.white,
        );

  // ignore: unused_field
  final PrimitiveColorTokens _tokens;
}
