import 'package:flutter/foundation.dart';

@immutable
class AppRouteData {
  const AppRouteData({
    required this.uri,
    this.pathParameters,
    this.queryParameters,
    this.extra,
  });

  final Uri uri;
  final Map<String, String>? pathParameters;
  final Map<String, String>? queryParameters;
  final Object? extra;

  @override
  String toString() =>
      'RouteData(uri: $uri, pathParameters: $pathParameters, queryParameters: $queryParameters, extra: $extra)';

  @override
  bool operator ==(covariant AppRouteData other) {
    if (identical(this, other)) return true;

    return other.uri == uri &&
        mapEquals(other.pathParameters, pathParameters) &&
        mapEquals(other.queryParameters, queryParameters) &&
        other.extra == extra;
  }

  @override
  int get hashCode =>
      uri.hashCode ^ pathParameters.hashCode ^ queryParameters.hashCode ^ extra.hashCode;
}
