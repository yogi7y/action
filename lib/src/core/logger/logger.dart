import 'dart:developer' as developer;

void logger(
  String text, {
  String name = 'Logger',
  Object? error,
  StackTrace? stackTrace,
}) =>
    developer.log(
      text,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
