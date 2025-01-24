import 'package:action/src/core/exceptions/serialization_exception.dart';
import 'package:action/src/modules/projects/data/models/project_relation_metadata_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const projectId = 'test-project-id';

  final payload = {
    'total_tasks': 10,
    'completed_tasks': 5,
    'total_pages': 2,
    'project_id': projectId,
  };

  group('ProjectRelationMetadataModel', () {
    test('fromMap should correctly parse valid map', () {
      final result = ProjectRelationMetadataModel.fromMap(payload);

      expect(result.totalTasks, equals(10));
      expect(result.completedTasks, equals(5));
      expect(result.totalPages, equals(2));
      expect(result.projectId, equals(projectId));
    });

    test('fromMap should throw InvalidTypeException when required field is missing', () {
      final invalidMap = Map<String, Object?>.from(payload)..remove('total_tasks');

      expect(
        () => ProjectRelationMetadataModel.fromMap(invalidMap),
        throwsA(
          isA<InvalidTypeException>().having(
            (e) => e.exception,
            'exception message',
            'total_tasks must be of type int, but got Null',
          ),
        ),
      );
    });

    test('completion percentage should be calculated correctly', () {
      final model = ProjectRelationMetadataModel.fromMap(payload);
      expect(model.completionPercentage, equals(50.0));
    });

    test('completion percentage should be 0 when no tasks', () {
      final mapWithNoTasks = Map<String, Object?>.from(payload)
        ..['total_tasks'] = 0
        ..['completed_tasks'] = 0;

      final model = ProjectRelationMetadataModel.fromMap(mapWithNoTasks);
      expect(model.completionPercentage, equals(0.0));
    });
  });
}
