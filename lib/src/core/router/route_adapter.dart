import 'package:go_router/go_router.dart' hide RouteData;

import 'route_data.dart';

abstract class RouteDataAdapter<T> {
  RouteData? adapt(T data);
}

mixin GoRouterRouteDataAdapter implements RouteDataAdapter<GoRouterState> {
  @override
  RouteData? adapt(GoRouterState data) {
    final uri = data.uri.toString();
    final pathParameters = data.pathParameters;
    final queryParameters = data.uri.queryParameters;
    final extra = data.extra;

    return RouteData(
      uri: uri,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}
