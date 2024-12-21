import 'package:flutter/material.dart';

@immutable
abstract class ChipsTokens {
  const ChipsTokens({
    required this.background,
    required this.text,
  });

  final Color background;
  final Color text;
}

@immutable
abstract class SelectableChipsTokens {
  const SelectableChipsTokens({
    required this.border,
    required this.foregroundColor,
  });

  final Color border;
  final Color foregroundColor;
}
