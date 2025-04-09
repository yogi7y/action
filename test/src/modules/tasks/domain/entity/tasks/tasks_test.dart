import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/entity/tasks/tasks.dart';
import 'package:action/src/modules/tasks/domain/entity/tasks/tasks_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tasks', () {
    late Tasks tasksListOne;
    late Tasks tasksListTwo;
    late TaskEntity taskOne;
    late TaskEntity taskTwo;
    late TaskEntity taskThree;

    setUp(() {
      taskOne = TaskEntity(
        id: '1',
        name: 'Task One',
        createdAt: DateTime(2024, 3, 1, 14), // 2:00 PM
      );
      taskTwo = TaskEntity(
        id: '2',
        name: 'Task Two',
        createdAt: DateTime(2024, 3, 1, 15), // 3:00 PM
      );
      taskThree = TaskEntity(
        id: '3',
        name: 'Task Three',
        createdAt: DateTime(2024, 3, 1, 16), // 4:00 PM
      );
    });

    test('should be equal when containing same tasks in same order', () {
      tasksListOne = TasksList([taskOne, taskTwo]);
      tasksListTwo = TasksList([taskOne, taskTwo]);

      expect(tasksListOne, equals(tasksListTwo));
      expect(tasksListOne.hashCode, equals(tasksListTwo.hashCode));
    });

    test('should not be equal when containing same tasks in different order', () {
      tasksListOne = TasksList([taskOne, taskTwo]);
      tasksListTwo = TasksList([taskTwo, taskOne]);

      expect(tasksListOne, isNot(equals(tasksListTwo)));
      expect(tasksListOne.hashCode, isNot(equals(tasksListTwo.hashCode)));
    });

    test('should not be equal when containing different tasks', () {
      tasksListOne = TasksList([taskOne, taskTwo]);
      tasksListTwo = TasksList([taskOne, taskThree]);

      expect(tasksListOne, isNot(equals(tasksListTwo)));
      expect(tasksListOne.hashCode, isNot(equals(tasksListTwo.hashCode)));
    });

    test('should not be equal when containing different number of tasks', () {
      tasksListOne = TasksList([taskOne, taskTwo]);
      tasksListTwo = TasksList([taskOne, taskTwo, taskThree]);

      expect(tasksListOne, isNot(equals(tasksListTwo)));
      expect(tasksListOne.hashCode, isNot(equals(tasksListTwo.hashCode)));
    });

    test('should be equal when both are empty', () {
      tasksListOne = TasksList(const []);
      tasksListTwo = TasksList(const []);

      expect(tasksListOne, equals(tasksListTwo));
      expect(tasksListOne.hashCode, equals(tasksListTwo.hashCode));
    });

    test('should not be equal to null', () {
      tasksListOne = TasksList([taskOne, taskTwo]);

      expect(tasksListOne, isNot(equals(null)));
    });

    test('should not be equal to non-Tasks object', () {
      tasksListOne = TasksList([taskOne, taskTwo]);

      expect(tasksListOne, isNot(equals('not a Tasks object')));
    });
  });

  group('copyWith', () {
    late TasksList tasks;
    late TaskEntity taskOne;
    late TaskEntity taskTwo;
    late TaskEntity taskThree;

    setUp(() {
      taskOne = TaskEntity(
        id: '1',
        name: 'Task One',
        createdAt: DateTime(2024, 3, 1, 14), // 2:00 PM
      );
      taskTwo = TaskEntity(
        id: '2',
        name: 'Task Two',
        createdAt: DateTime(2024, 3, 1, 15), // 3:00 PM
      );
      taskThree = TaskEntity(
        id: '3',
        name: 'Task Three',
        createdAt: DateTime(2024, 3, 1, 16), // 4:00 PM
      );
      tasks = TasksList([taskOne, taskTwo]);
    });

    test('should create new instance with appended tasks', () {
      // Act
      final result = tasks.copyWith((currentTasks) => [...currentTasks, taskThree]);

      // Assert
      expect(result.value, equals([taskOne, taskTwo, taskThree]));
      expect(result, isA<TasksList>());
    });

    test('should create new instance with prepended tasks', () {
      // Act
      final result = tasks.copyWith((currentTasks) => [taskThree, ...currentTasks]);

      // Assert
      expect(result.value, equals([taskThree, taskOne, taskTwo]));
      expect(result, isA<TasksList>());
    });

    test('should create new instance with filtered tasks', () {
      // Act
      final result = tasks.copyWith((currentTasks) => [currentTasks.first]);

      // Assert
      expect(result.value, equals([taskOne]));
      expect(result, isA<TasksList>());
    });

    test('should not modify original tasks', () {
      // Act
      final result = tasks.copyWith((currentTasks) => [...currentTasks, taskThree]);

      // Assert
      expect(tasks.value, equals([taskOne, taskTwo]));
      expect(result.value, equals([taskOne, taskTwo, taskThree]));
    });
  });
}
