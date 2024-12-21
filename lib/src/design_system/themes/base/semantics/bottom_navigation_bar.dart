import 'package:flutter/material.dart';

@immutable
abstract class BottomNavigationBarTokens {
  const BottomNavigationBarTokens({
    required this.background,
    required this.text,
  });

  final Color background;
  final Color text;
}
