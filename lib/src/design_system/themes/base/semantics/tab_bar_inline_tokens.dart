import 'package:flutter/material.dart';

@immutable
abstract class TabBarTokens {
  const TabBarTokens({
    required this.underlineBorder,
    required this.indicator,
    required this.selectedTextColor,
    required this.unselectedTextColor,
  });

  final Color underlineBorder;
  final Color indicator;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  @override
  String toString() =>
      'TabBarTokens(underlineBorder: $underlineBorder, indicator: $indicator, selectedTextColor: $selectedTextColor, unselectedTextColor: $unselectedTextColor)';
}
