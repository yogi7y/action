import 'package:action/src/core/exceptions/serialization_exception.dart';
import 'package:action/src/modules/tasks/data/models/task.dart';
import 'package:action/src/modules/tasks/domain/entity/task_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

void main() {
  group('TaskModel', () {
    test('fromMap should create correct instance with all fields', () {
      final map = createTaskMap(
        id: 'test-id',
        name: 'Test Task',
        status: 'todo',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-02T00:00:00.000Z',
        dueDate: '2024-01-03T00:00:00.000Z',
        projectId: 'project-1',
        contextId: 'context-1',
        isOrganized: true,
      );

      final model = TaskModel.fromMap(map);

      expect(model.id, 'test-id');
      expect(model.name, 'Test Task');
      expect(model.status, TaskStatus.todo);
      expect(model.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(model.updatedAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
      expect(model.dueDate, DateTime.parse('2024-01-03T00:00:00.000Z'));
      expect(model.projectId, 'project-1');
      expect(model.contextId, 'context-1');
      expect(model.isOrganized, true);
    });

    test('fromMap should handle optional fields being null', () {
      final map = createTaskMap(
        id: 'test-id',
        name: 'Test Task',
        status: 'todo',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-02T00:00:00.000Z',
      );

      final model = TaskModel.fromMap(map);

      expect(model.dueDate, null);
      expect(model.projectId, null);
      expect(model.contextId, null);
      expect(model.isOrganized, false);
    });

    test('fromMap should throw InvalidTypeException for missing required fields', () {
      final map = createTaskMap(
        id: 'test-id',
        status: 'todo',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-02T00:00:00.000Z',
        name: '', // name is missing
      )..removeWhere((key, value) => key == 'name');

      expect(
        () => TaskModel.fromMap(map),
        throwsA(isA<InvalidTypeException>()),
      );
    });

    test('fromMap should throw for invalid status', () {
      final map = createTaskMap(
        id: 'test-id',
        name: 'Test Task',
        status: 'invalid_status',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-02T00:00:00.000Z',
      );

      expect(
        () => TaskModel.fromMap(map),
        throwsArgumentError,
      );
    });

    test('fromMap should throw for invalid date format', () {
      final map = createTaskMap(
        id: 'test-id',
        name: 'Test Task',
        status: 'todo',
        createdAt: 'invalid-date',
        updatedAt: '2024-01-02T00:00:00.000Z',
      );

      expect(
        () => TaskModel.fromMap(map),
        throwsFormatException,
      );
    });
  });
}

@visibleForTesting
Map<String, Object?> createTaskMap({
  required String id,
  required String name,
  required String status,
  required String createdAt,
  required String updatedAt,
  String? dueDate,
  String? projectId,
  String? contextId,
  bool? isOrganized,
}) {
  return {
    'id': id,
    'name': name,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'due_date': dueDate,
    'project_id': projectId,
    'context_id': contextId,
    'is_organized': isOrganized,
  };
}
