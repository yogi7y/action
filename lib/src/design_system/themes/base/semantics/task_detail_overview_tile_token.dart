import 'package:flutter/material.dart';

@immutable
abstract class TextDetailOverviewTileTokens {
  const TextDetailOverviewTileTokens({
    required this.valueForeground,
    required this.labelForeground,
    required this.border,
  });

  final Color valueForeground;
  final Color labelForeground;
  final Color border;

  @override
  String toString() =>
      'TextDetailOverviewTileTokens(valueForeground: $valueForeground, labelForeground: $labelForeground, border: $border)';
}
