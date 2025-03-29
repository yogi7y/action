// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../base/semantics/overlay_tokens.dart';
import '../light_theme.dart';

@immutable
class LightOverlayTokens extends LightBaseTheme implements OverlayTokens {
  LightOverlayTokens({required super.primitiveTokens})
      : background = primitiveTokens.neutral.shade50,
        borderStroke = primitiveTokens.neutral.shade100,
        shadow = const Color(0xFFE2E8F0).withValues(alpha: 0.9);

  @override
  final Color background;

  @override
  final Color borderStroke;

  @override
  final Color shadow;
}
