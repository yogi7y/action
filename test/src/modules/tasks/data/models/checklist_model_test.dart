import 'package:action/src/core/exceptions/serialization_exception.dart';
import 'package:action/src/modules/tasks/data/models/checklist_model.dart';
import 'package:action/src/modules/tasks/domain/entity/checklist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

class ChecklistModelTest with ChecklistModelMixin {}

void main() {
  group('ChecklistModelMixin', () {
    test('fromMapToChecklistEntity should create correct instance with all fields', () {
      final map = createChecklistMap(
        id: 'checklist-id',
        taskId: 'task-id',
        title: 'Test Checklist',
        status: 'todo',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-02T00:00:00.000Z',
      );

      final model = ChecklistModelTest().fromMapToChecklistEntity(map);

      expect(model.id, 'checklist-id');
      expect(model.taskId, 'task-id');
      expect(model.title, 'Test Checklist');
      expect(model.status, ChecklistStatus.todo);
      expect(model.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(model.updatedAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
    });

    test('fromMapToChecklistEntity should throw InvalidTypeException for missing required fields',
        () {
      final map = createChecklistMap(
        id: 'checklist-id',
        taskId: 'task-id',
        title: 'Test Checklist',
        status: 'todo',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-02T00:00:00.000Z',
      )..removeWhere((key, value) => key == 'title');

      expect(
        () => ChecklistModelTest().fromMapToChecklistEntity(map),
        throwsA(isA<InvalidTypeException>()),
      );
    });

    test('fromMapToChecklistEntity should throw for invalid status', () {
      final map = createChecklistMap(
        id: 'checklist-id',
        taskId: 'task-id',
        title: 'Test Checklist',
        status: 'invalid_status',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-02T00:00:00.000Z',
      );

      expect(
        () => ChecklistModelTest().fromMapToChecklistEntity(map),
        throwsArgumentError,
      );
    });

    test('fromMapToChecklistEntity should throw for invalid date format', () {
      final map = createChecklistMap(
        id: 'checklist-id',
        taskId: 'task-id',
        title: 'Test Checklist',
        status: 'todo',
        createdAt: 'invalid-date',
        updatedAt: '2024-01-02T00:00:00.000Z',
      );

      expect(
        () => ChecklistModelTest().fromMapToChecklistEntity(map),
        throwsFormatException,
      );
    });
  });

  group('ChecklistModel', () {
    test('fromMap should create correct instance with all fields', () {
      final map = createChecklistMap(
        id: 'checklist-id',
        taskId: 'task-id',
        title: 'Test Checklist',
        status: 'todo',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-02T00:00:00.000Z',
      );

      final model = ChecklistModelTest().fromMapToChecklistEntity(map);

      expect(model.id, 'checklist-id');
      expect(model.taskId, 'task-id');
      expect(model.title, 'Test Checklist');
      expect(model.status, ChecklistStatus.todo);
      expect(model.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(model.updatedAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
      expect(model, isA<ChecklistEntity>());
    });

    test('fromMap should throw InvalidTypeException for missing required fields', () {
      final map = createChecklistMap(
        id: 'checklist-id',
        taskId: 'task-id',
        title: 'Test Checklist',
        status: 'todo',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-02T00:00:00.000Z',
      )..removeWhere((key, value) => key == 'title');

      expect(
        () => ChecklistModelTest().fromMapToChecklistEntity(map),
        throwsA(isA<InvalidTypeException>()),
      );
    });
  });
}

@visibleForTesting
Map<String, Object?> createChecklistMap({
  required String id,
  required String taskId,
  required String title,
  required String status,
  required String createdAt,
  required String updatedAt,
}) {
  return {
    'id': id,
    'task_id': taskId,
    'title': title,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
