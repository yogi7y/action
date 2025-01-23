import 'package:flutter/foundation.dart';

import '../exceptions/serialization_exception.dart';

/// A validator class that checks if fields in a payload map are of the expected type.
///
/// Usage:
/// ```dart
/// final validator = FieldTypeValidator(payload);
/// final name = validator.validateField<String>('name');
/// ```
@immutable
class FieldTypeValidator {
  /// Creates a new [FieldTypeValidator] with the given payload map.
  ///
  /// The [_payload] parameter is the map containing the data to validate.
  const FieldTypeValidator(this._payload, this._stackTrace);

  /// The payload map containing the data to validate.
  final Payload _payload;
  final StackTrace _stackTrace;

  /// Validates that the value at the given [key] is of type [T].
  ///
  /// Returns the value if it is of type [T].
  /// Throws an [InvalidTypeException] if the value is not of type [T].
  ///
  /// Parameters:
  /// - [key]: The key to look up in the payload map
  /// - [T]: The expected type of the value
  /// - [stackTrace]: The stack trace to use in the exception. If not provided, the stack trace from the constructor will be used.
  T isOfType<T>(
    String key, {
    StackTrace? stackTrace,
  }) {
    final value = _payload[key];
    if (value is! T) {
      throw InvalidTypeException(
        exception: '$key must be of type $T, but got ${value.runtimeType}',
        stackTrace: stackTrace ?? _stackTrace,
        payload: _payload,
      );
    }
    return value;
  }
}
