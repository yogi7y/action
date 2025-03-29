// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
abstract class OverlayTokens {
  const OverlayTokens({
    required this.background,
    required this.borderStroke,
    required this.shadow,
  });

  final Color background;
  final Color borderStroke;
  final Color shadow;

  @override
  String toString() =>
      'OverlayTokens(background: $background, borderStroke: $borderStroke, shadow: $shadow)';
}
