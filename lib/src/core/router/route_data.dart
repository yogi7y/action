import 'package:flutter/foundation.dart';

@immutable
class RouteData {
  const RouteData({
    required this.uri,
    required this.pathParameters,
    required this.queryParameters,
    this.extra,
  });

  final String uri;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final Object? extra;

  @override
  String toString() =>
      'RouteData(uri: $uri, pathParameters: $pathParameters, queryParameters: $queryParameters, extra: $extra)';

  @override
  bool operator ==(covariant RouteData other) {
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
