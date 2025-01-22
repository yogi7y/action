import 'package:action/src/core/router/route_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class TestGoRouterAdapter with GoRouterRouteDataAdapter {}

class MockRouteConfiguration extends Mock implements RouteConfiguration {}

void main() {
  late TestGoRouterAdapter adapter;

  setUp(() {
    adapter = TestGoRouterAdapter();
  });

  group('GoRouterRouteDataAdapter', () {
    test('adapts basic route without parameters', () {
      final state = createGoRouterState(path: '/home');

      final result = adapter.adapt(state);

      expect(result?.uri, Uri(path: '/home'));
      expect(result?.pathParameters, isEmpty);
      expect(result?.queryParameters, isEmpty);
    });

    test('adapts route with path parameters', () {
      final state = createGoRouterState(
        path: '/users/:id',
        pathParameters: {'id': '123'},
      );

      final result = adapter.adapt(state);

      expect(result?.uri, Uri(path: '/users/123'));
      expect(result?.pathParameters, {'id': '123'});
      expect(result?.queryParameters, isEmpty);
    });

    test('adapts route with query parameters', () {
      final state = createGoRouterState(
        path: '/search',
        queryParameters: {'q': 'flutter', 'page': '1'},
      );

      final result = adapter.adapt(state);

      expect(
          result?.uri,
          Uri(
            path: '/search',
            queryParameters: {'q': 'flutter', 'page': '1'},
          ));
      expect(result?.pathParameters, isEmpty);
      expect(result?.queryParameters, {'q': 'flutter', 'page': '1'});
    });

    test('adapts route with both path and query parameters', () {
      final state = createGoRouterState(
        path: '/users/:id/posts/:postId',
        pathParameters: {
          'id': '123',
          'postId': '456',
        },
        queryParameters: {'sort': 'date'},
      );

      final result = adapter.adapt(state);

      expect(
        result?.uri,
        Uri(
          path: '/users/123/posts/456',
          queryParameters: {'sort': 'date'},
        ),
      );
      expect(result?.pathParameters, {'id': '123', 'postId': '456'});
      expect(result?.queryParameters, {'sort': 'date'});
    });
  });
}

GoRouterState createGoRouterState({
  required String path,
  Map<String, String> pathParameters = const {},
  Map<String, String> queryParameters = const {},
  Object? extra,
}) {
  // Build actual path by replacing parameters
  var actualPath = path;
  for (final entry in pathParameters.entries) {
    actualPath = actualPath.replaceAll(':${entry.key}', entry.value);
  }

  // Construct URI with query parameters
  final uri = Uri(
    path: actualPath,
    queryParameters: queryParameters.isEmpty ? null : queryParameters,
  );

  return GoRouterState(
    MockRouteConfiguration(),
    uri: uri,
    matchedLocation: actualPath,
    path: path,
    fullPath: path,
    pathParameters: pathParameters,
    pageKey: const ValueKey('test'),
    extra: extra,
  );
}
