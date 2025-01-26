import 'package:core_y/core_y.dart';
import 'package:flutter/foundation.dart';

/// Data that is being serialized or deserialized.
typedef Payload = Map<String, Object?>;

/// Base class for all serialization-related exceptions in the application.
///
/// This abstract class implements [AppException] and provides a foundation for
/// handling errors that occur during data serialization/deserialization processes.
@immutable
abstract class SerializationException implements AppException {
  /// Creates a new [SerializationException].
  ///
  /// Parameters:
  /// - [exception]: The original exception that caused this serialization error
  /// - [stackTrace]: The stack trace associated with the exception
  /// - [userFriendlyMessage]: A human-readable message that can be displayed to users,
  ///   defaults to a generic error message
  const SerializationException({
    required this.exception,
    required this.stackTrace,
    required this.payload,
    this.userFriendlyMessage = 'Something went wrong. Please try again later.',
  });

  /// The original exception that caused this serialization error.
  @override
  final Object? exception;

  /// The stack trace where the serialization exception occurred.
  @override
  final StackTrace stackTrace;

  /// A user-friendly message that can be displayed in the UI.
  @override
  final String userFriendlyMessage;

  /// The data that is being serialized or deserialized.
  final Payload payload;
}

/// Exception thrown when a value is not of the expected type.
@immutable
class InvalidTypeException extends SerializationException {
  const InvalidTypeException({
    required super.exception,
    required super.stackTrace,
    required super.payload,
  });
}
