// ignore_for_file: avoid_implementing_value_types

import 'package:flutter/material.dart';

import '../../base/semantics/status_tokens.dart';
import '../dark_theme.dart';

@immutable
class DarkStatusDoneTokens extends DarkBaseTheme implements StatusTokens {
  DarkStatusDoneTokens({required super.primitiveTokens})
      : background = const Color(0xFF052E16),
        text = const Color(0xFF4ADE80),
        border = const Color(0xFF14532D);

  @override
  final Color background;

  @override
  final Color text;

  @override
  final Color border;
}

@immutable
class DarkStatusInProgressTokens extends DarkBaseTheme implements StatusTokens {
  DarkStatusInProgressTokens({required super.primitiveTokens})
      : background = primitiveTokens.rose.shade900,
        text = primitiveTokens.rose.shade400,
        border = primitiveTokens.rose.shade800;

  @override
  final Color background;

  @override
  final Color text;

  @override
  final Color border;
}

@immutable
class DarkStatusTodoTokens extends DarkBaseTheme implements StatusTokens {
  DarkStatusTodoTokens({required super.primitiveTokens})
      : background = const Color(0xFF172554),
        text = const Color(0xFF60A5FA),
        border = const Color(0xFF1E3A8A);

  @override
  final Color background;

  @override
  final Color text;

  @override
  final Color border;
}
