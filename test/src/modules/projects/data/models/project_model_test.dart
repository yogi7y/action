import 'package:action/src/modules/projects/data/models/project_model.dart';
import 'package:action/src/modules/projects/domain/entity/project_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProjectModel', () {
    test('fromMap should create correct instance', () {
      final map = {
        'id': 'test-id',
        'name': 'Test Project',
        'status': 'not_started',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
        'due_date': '2024-01-03T00:00:00.000Z',
      };

      final model = ProjectModel.fromMap(map);

      expect(model.id, 'test-id');
      expect(model.name, 'Test Project');
      expect(model.status, ProjectStatus.notStarted);
      expect(model.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(model.updatedAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
      expect(model.dueDate, DateTime.parse('2024-01-03T00:00:00.000Z'));
    }, skip: 'due date implementation is not done yet');

    test('fromMap should handle null due_date', () {
      final map = {
        'id': 'test-id',
        'name': 'Test Project',
        'status': 'not_started',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
        'due_date': null,
      };

      final model = ProjectModel.fromMap(map);

      expect(model.dueDate, null);
    });

    test('fromMap should throw for invalid status', () {
      final map = {
        'id': 'test-id',
        'name': 'Test Project',
        'status': 'invalid_status',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      };

      expect(
        () => ProjectModel.fromMap(map),
        throwsArgumentError,
      );
    });
  });
}
