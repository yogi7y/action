// ignore_for_file: avoid_implementing_value_types

import 'package:action/src/core/exceptions/route_exception.dart';
import 'package:action/src/core/router/handlers/project_detail_handler.dart';
import 'package:action/src/core/router/route_data.dart';
import 'package:action/src/modules/projects/domain/entity/project.dart';
import 'package:action/src/modules/projects/presentation/screens/project_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakeBuildContext extends Fake implements BuildContext {}

class FakeProjectEntity extends Fake implements ProjectEntity {}

void main() {
  late ProjectDetailRouteHandler handler;

  setUpAll(() {
    registerFallbackValue(FakeProjectEntity());
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    handler = ProjectDetailRouteHandler();
  });

  group('ProjectDetailRouteHandler.validateAndTransform', () {
    test('throws RouteException when extra is neither ProjectEntity nor null', () {
      final data = AppRouteData(
        uri: Uri.parse('/projects/123'),
        pathParameters: const {'id': '123'},
        extra: 'invalid data',
      );

      expect(
        () => handler.validateAndTransform(data: data),
        throwsA(
          allOf(
            isA<RouteException>()
                .having(
                  (e) => e.exception,
                  'exception',
                  'Data must be of type ProjectEntity or null, but was String',
                )
                .having(
                  (e) => e.route,
                  'route',
                  '/projects/123',
                )
                .having(
              (e) => e.details,
              'details',
              {'projectData': 'invalid data', 'type': String},
            ),
          ),
        ),
      );
    });

    test('throws RouteException when both id and project are empty or null', () {
      final data = AppRouteData(
        uri: Uri.parse('/projects/new'),
        pathParameters: const {'id': ''},
      );

      expect(
        () => handler.validateAndTransform(data: data),
        throwsA(
          allOf(
            isA<RouteException>()
                .having(
                  (e) => e.exception,
                  'exception',
                  'Either of project data or ID is required',
                )
                .having(
                  (e) => e.route,
                  'route',
                  '/projects/new',
                )
                .having(
              (e) => e.details,
              'details',
              {
                'projectData': null,
                'id': '',
              },
            ),
          ),
        ),
      );
    });

    test('successfully returns projectOrId when only id is provided', () {
      final data = AppRouteData(
        uri: Uri.parse('/projects/123'),
        pathParameters: const {'id': '123'},
      );

      final result = handler.validateAndTransform(data: data);

      expect(result.id, '123');
      expect(result.value, isNull);
    });

    test('successfully returns projectOrId when only project is provided', () {
      final project = FakeProjectEntity();
      final data = AppRouteData(
        uri: Uri.parse('/projects/new'),
        pathParameters: const {'id': ''},
        extra: project,
      );

      final result = handler.validateAndTransform(data: data);

      expect(result.id, isEmpty);
      expect(result.value, project);
    });

    test('successfully returns projectOrId when both id and project are provided', () {
      final project = FakeProjectEntity();
      final data = AppRouteData(
        uri: Uri.parse('/projects/123'),
        pathParameters: const {'id': '123'},
        extra: project,
      );

      final result = handler.validateAndTransform(data: data);

      expect(result.id, '123');
      expect(result.value, project);
    });
  });

  group('ProjectDetailRouteHandler.build', () {
    test('returns ProjectDetailScreen with provided parameters', () {
      final project = FakeProjectEntity();
      final param = (id: '123', value: project);

      final result = handler.build(FakeBuildContext(), param);

      expect(result, isA<ProjectDetailScreen>());
    });
  });

  group('ProjectDetailRouteHandler.handle', () {
    test('successfully creates ProjectDetailScreen when data is valid', () {
      final project = FakeProjectEntity();
      final data = AppRouteData(
        uri: Uri.parse('/projects/123'),
        pathParameters: const {'id': '123'},
        extra: project,
      );

      final result = handler.handle(FakeBuildContext(), data);

      expect(result, isA<ProjectDetailScreen>());
    });
  });
}
