// ignore_for_file: avoid_implementing_value_types

import 'package:flutter/material.dart';

import '../../base/semantics/status_tokens.dart';
import '../light_theme.dart';

@immutable
class LightStatusDoneTokens extends LightBaseTheme implements StatusTokens {
  LightStatusDoneTokens({required super.primitiveTokens})
      : background = const Color(0xFFE6FCE9),
        text = const Color(0xFF15803D),
        border = const Color(0xFF8BF7D0);

  @override
  final Color background;

  @override
  final Color text;

  @override
  final Color border;
}

@immutable
class LightStatusInProgressTokens extends LightBaseTheme implements StatusTokens {
  LightStatusInProgressTokens({required super.primitiveTokens})
      : background = primitiveTokens.rose.shade100,
        text = primitiveTokens.rose.shade600,
        border = primitiveTokens.rose.shade200;

  @override
  final Color background;

  @override
  final Color text;

  @override
  final Color border;
}

@immutable
class LightStatusTodoTokens extends LightBaseTheme implements StatusTokens {
  LightStatusTodoTokens({required super.primitiveTokens})
      : background = const Color(0xFFD7E8FE),
        text = const Color(0xFF2563EB),
        border = const Color(0xFFBFDBFE);

  @override
  final Color background;

  @override
  final Color text;

  @override
  final Color border;
}
