import 'package:flutter/material.dart';

@immutable
abstract class L2ScreenHeaderTokens {
  const L2ScreenHeaderTokens({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;

  @override
  String toString() => 'L2ScreenTokens(background: $background, foreground: $foreground)';
}
