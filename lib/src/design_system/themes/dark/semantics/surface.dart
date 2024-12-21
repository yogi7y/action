import 'package:flutter/material.dart';

import '../../../colors/primitive_tokens.dart';
import '../../base/semantics/surface.dart';

@immutable
class DarkSurface implements SurfaceTokens {
  const DarkSurface(this._tokens);

  final PrimitiveColorTokens _tokens;

  @override
  Color get background => _tokens.neutral.shade900;

  @override
  Color get backgroundContrast => _tokens.dark;

  @override
  Color get modals => _tokens.neutral.shade800;
}
