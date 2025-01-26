import 'package:go_router/go_router.dart' hide RouteData;

import 'route_data.dart';

abstract class RouteDataAdapter<T> {
  AppRouteData adapt(T data);
}

class GoRouterRouteDataAdapter implements RouteDataAdapter<GoRouterState> {
  @override
  AppRouteData adapt(GoRouterState data) {
    final uri = data.uri;
    final pathParameters = data.pathParameters;
    final queryParameters = data.uri.queryParameters;
    final extra = data.extra;

    return AppRouteData(
      uri: uri,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}
