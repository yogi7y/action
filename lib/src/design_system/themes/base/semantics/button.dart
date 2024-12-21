import 'package:flutter/material.dart';

@immutable
abstract class ButtonTokens {
  const ButtonTokens({
    required this.background,
    required this.text,
  });

  final Color background;
  final Color text;
}
