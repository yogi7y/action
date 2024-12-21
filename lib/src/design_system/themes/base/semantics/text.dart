import 'package:flutter/material.dart';

@immutable
abstract class TextTokens {
  const TextTokens({
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  final Color primary;
  final Color secondary;
  final Color tertiary;
}
