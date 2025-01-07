import 'package:core_y/core_y.dart';
import 'package:flutter/widgets.dart';

@immutable
class ValidationException implements AppException {
  const ValidationException({
    required this.exception,
    required this.stackTrace,
    required this.userFriendlyMessage,
  });

  @override
  final Object? exception;
  @override
  final StackTrace stackTrace;
  @override
  final String userFriendlyMessage;
}
