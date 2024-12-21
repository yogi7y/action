import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../../colors/primitive_tokens.dart';
import '../../base/semantics/surface.dart';

@immutable
class LightSurfaceTokens implements SurfaceTokens {
  const LightSurfaceTokens(this.tokens);

  final PrimitiveColorTokens tokens;

  @override
  Color get background => tokens.neutral.shade100;

  @override
  Color get backgroundContrast => tokens.white;

  @override
  Color get modals => tokens.white;
}
