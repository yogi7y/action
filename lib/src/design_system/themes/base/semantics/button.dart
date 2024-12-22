import 'package:flutter/material.dart';

@immutable
abstract class ButtonTokens {
  const ButtonTokens({
    required this.background,
    required this.text,
    required this.shadow,
  });

  final Color background;
  final Color text;
  final Color shadow;
}
