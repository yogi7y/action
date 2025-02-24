import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/repository/task_repository.dart';
import 'package:action/src/modules/tasks/domain/use_case/task_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Import your necessary dependencies

class FakeTaskEntity extends Fake implements TaskEntity {
  FakeTaskEntity({
    required this.createdAt,
  });

  @override
  final DateTime createdAt;
}

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late TaskUseCase systemUnderTest;
  late MockTaskRepository mockTaskRepository;
  setUp(() {
    mockTaskRepository = MockTaskRepository();
    systemUnderTest = TaskUseCase(mockTaskRepository);
  });

  group('getInsertIndexForTask', () {
    test('should return correct index for task that should go at the beginning', () {
      final tasks = [
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14)), // 2:00 PM
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 15)), // 3:00 PM
      ];

      final newTask = FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 13)); // 1:00 PM

      final result = systemUnderTest.getInsertIndexForTask(tasks, newTask);
      expect(result, 0);
    });

    test('should return correct index for task that should go at the end', () {
      final tasks = [
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 13)), // 1:00 PM
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14)), // 2:00 PM
      ];

      final newTask = FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 15)); // 3:00 PM

      final result = systemUnderTest.getInsertIndexForTask(tasks, newTask);
      expect(result, 2);
    });

    test('should return correct index for task that should go in the middle', () {
      final tasks = [
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 13)), // 1:00 PM
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14)), // 2:00 PM
      ];

      final newTask = FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 13, 30)); // 1:30 PM

      final result = systemUnderTest.getInsertIndexForTask(tasks, newTask);
      expect(result, 1);
    });

    test('should return correct index for task with same timestamp (should be placed after)', () {
      final tasks = [
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 13)), // 1:00 PM
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14)), // 2:00 PM
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 15)), // 3:00 PM
      ];

      final newTask = FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14)); // 2:00 PM

      final result = systemUnderTest.getInsertIndexForTask(tasks, newTask);
      expect(result, 1);
    });

    test('should handle empty list', () {
      final tasks = <FakeTaskEntity>[];
      final newTask = FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14));

      final result = systemUnderTest.getInsertIndexForTask(tasks, newTask);
      expect(result, 0);
    });

    test('should handle list with single item', () {
      final tasks = [
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14)), // 2:00 PM
      ];

      final newTask = FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 13)); // 1:00 PM

      final result = systemUnderTest.getInsertIndexForTask(tasks, newTask);
      expect(result, 0);
    });

    test('should maintain order with multiple tasks having same timestamp', () {
      final tasks = [
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14)), // 2:00 PM
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14)), // 2:00 PM
        FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14)), // 2:00 PM
      ];

      final newTask = FakeTaskEntity(createdAt: DateTime(2024, 3, 1, 14)); // 2:00 PM

      final result = systemUnderTest.getInsertIndexForTask(tasks, newTask);
      expect(result, 0); // Should insert at the beginning of the same-timestamp group
    });
  });
}
