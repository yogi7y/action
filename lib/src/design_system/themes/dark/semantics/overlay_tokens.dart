// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../base/semantics/overlay_tokens.dart';
import '../dark_theme.dart';

@immutable
class DarkOverlayTokens extends DarkBaseTheme implements OverlayTokens {
  DarkOverlayTokens({required super.primitiveTokens})
      : background = primitiveTokens.dark,
        borderStroke = primitiveTokens.neutral.shade800,
        shadow = const Color(0xFF283344);

  @override
  final Color background;

  @override
  final Color borderStroke;

  @override
  final Color shadow;
}
