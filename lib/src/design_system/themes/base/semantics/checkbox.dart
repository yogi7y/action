import 'package:flutter/material.dart';

@immutable
abstract class CheckboxTokens {
  const CheckboxTokens({
    required this.background,
    required this.border,
  });

  final Color background;
  final Color border;
}
