// ignore_for_file: avoid_implementing_value_types

import 'package:action/src/core/router/handlers/route_handler.dart';
import 'package:action/src/core/router/route_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHandler extends Mock implements RouteHandler<String> {}

class FakeAppRouteData extends Fake implements AppRouteData {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockHandler mockHandler;

  setUpAll(() {
    registerFallbackValue(FakeAppRouteData());
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockHandler = MockHandler();

    when(() => mockHandler.validateAndTransform(data: any(named: 'data'))).thenReturn('mocked');
    when(() => mockHandler.build(any(), any())).thenReturn(Container());
    when(() => mockHandler.handle(any(), any())).thenAnswer((invocation) {
      final context = invocation.positionalArguments[0] as BuildContext;
      final data = invocation.positionalArguments[1] as AppRouteData;

      final param = mockHandler.validateAndTransform(data: data);

      return mockHandler.build(context, param);
    });
  });

  test(
    'verify that the handler validates and transforms the data before building the widget',
    () async {
      mockHandler.handle(FakeBuildContext(), FakeAppRouteData());

      verifyInOrder([
        () => mockHandler.validateAndTransform(data: any(named: 'data')),
        () => mockHandler.build(any(), any()),
      ]);
    },
  );
  test('should pass transformed parameter to build method', () {
    const expectedParam = 'transformed_value';
    when(() => mockHandler.validateAndTransform(data: any(named: 'data')))
        .thenReturn(expectedParam);

    mockHandler.handle(FakeBuildContext(), FakeAppRouteData());

    verify(() => mockHandler.build(any(), expectedParam));
  });
}
