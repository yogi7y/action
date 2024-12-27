import 'package:flutter/material.dart';

@immutable
abstract class StatusTokens {
  const StatusTokens({
    required this.background,
    required this.text,
    required this.border,
  });

  final Color background;
  final Color text;
  final Color border;

  @override
  String toString() => 'StatusTokens(background: $background, text: $text, border: $border)';

  @override
  bool operator ==(covariant StatusTokens other) {
    if (identical(this, other)) return true;

    return other.background == background && other.text == text && other.border == border;
  }

  @override
  int get hashCode => background.hashCode ^ text.hashCode ^ border.hashCode;
}
