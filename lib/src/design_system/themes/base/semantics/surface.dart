import 'package:flutter/material.dart';

@immutable
abstract class SurfaceTokens {
  const SurfaceTokens({
    required this.background,
    required this.backgroundContrast,
    required this.modals,
  });

  final Color background;
  final Color backgroundContrast;
  final Color modals;
}
