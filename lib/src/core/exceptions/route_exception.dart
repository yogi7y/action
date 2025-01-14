import 'package:core_y/core_y.dart';
import 'package:flutter/foundation.dart';

import '../constants/strings.dart';

@immutable
class RouteException implements AppException {
  const RouteException({
    required this.exception,
    required this.stackTrace,
    required this.route,
    required this.uri,
    this.userFriendlyMessage = AppStrings.somethingWentWrong,
    this.details = const {},
  });

  @override
  final Object? exception;

  @override
  final StackTrace stackTrace;

  @override
  final String userFriendlyMessage;

  final String route;

  /// Full URI along with query parameters, path parameters, etc.
  final Uri uri;

  /// Any additional details that may be useful for debugging, like data, etc.
  final Map<String, Object?> details;

  @override
  String toString() =>
      'RouteException{route: $route, uri: $uri, details: $details, message: $userFriendlyMessage}';

  @override
  bool operator ==(covariant RouteException other) {
    if (identical(this, other)) return true;

    return other.exception == exception &&
        other.stackTrace == stackTrace &&
        other.userFriendlyMessage == userFriendlyMessage &&
        other.route == route &&
        other.uri == uri &&
        mapEquals(other.details, details);
  }

  @override
  int get hashCode =>
      exception.hashCode ^
      stackTrace.hashCode ^
      userFriendlyMessage.hashCode ^
      route.hashCode ^
      uri.hashCode ^
      details.hashCode;
}
