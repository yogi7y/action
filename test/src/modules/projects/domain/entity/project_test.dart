import 'package:action/src/modules/projects/domain/entity/project.dart';
import 'package:action/src/modules/projects/domain/entity/project_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProjectPropertiesEntity', () {
    const name = 'Test Project';
    final dueDate = DateTime(2024);
    const status = ProjectStatus.notStarted;

    test('should create instance with required fields', () {
      const project = ProjectPropertiesEntity(
        name: name,
        status: status,
      );

      expect(project.name, name);
      expect(project.status, status);
      expect(project.dueDate, null);
    });

    test('should create instance with all fields', () {
      final project = ProjectPropertiesEntity(
        name: name,
        status: status,
        dueDate: dueDate,
      );

      expect(project.name, name);
      expect(project.status, status);
      expect(project.dueDate, dueDate);
    });

    test('copyWith should create new instance with updated fields', () {
      final project = ProjectPropertiesEntity(
        name: name,
        status: status,
        dueDate: dueDate,
      );

      final updated = project.copyWith(
        name: 'New Name',
        status: ProjectStatus.inProgress,
      );

      expect(updated.name, 'New Name');
      expect(updated.status, ProjectStatus.inProgress);
      expect(updated.dueDate, dueDate);
    });

    test('toMap should return correct map representation', () {
      final project = ProjectPropertiesEntity(
        name: name,
        status: status,
        dueDate: dueDate,
      );

      final map = project.toMap();

      expect(map['name'], name);
      expect(map['status'], status.value);
      expect(map['due_date'], dueDate.toIso8601String());
    });
  });

  group('ProjectEntity', () {
    const id = 'test-id';
    const name = 'Test Project';
    const status = ProjectStatus.notStarted;
    final createdAt = DateTime(2024);
    final updatedAt = DateTime(2024, 1, 2);
    final dueDate = DateTime(2024, 1, 3);

    test('should create instance with required fields', () {
      final project = ProjectEntity(
        id: id,
        name: name,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(project.id, id);
      expect(project.name, name);
      expect(project.status, status);
      expect(project.createdAt, createdAt);
      expect(project.updatedAt, updatedAt);
      expect(project.dueDate, null);
    });

    test('fromProjectProperties should create correct instance', () {
      final properties = ProjectPropertiesEntity(
        name: name,
        status: status,
        dueDate: dueDate,
      );

      final project = ProjectEntity.fromProjectProperties(
        project: properties,
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(project.id, id);
      expect(project.name, name);
      expect(project.status, status);
      expect(project.dueDate, dueDate);
      expect(project.createdAt, createdAt);
      expect(project.updatedAt, updatedAt);
    });
  });
}
