import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/entity/tasks/tasks_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tasks', () {
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

    test('should return true when both are empty', () {
      final tasksListOne = TasksList([]);
      final tasksListTwo = TasksList([]);

      expect(tasksListOne, equals(tasksListTwo));
    });

    test('should be equal when containing same tasks in same order', () {
      final tasksListOne = TasksList([taskOne, taskTwo]);
      final tasksListTwo = TasksList([taskOne, taskTwo]);

      expect(tasksListOne, equals(tasksListTwo));
    });

    test('should not be equal when containing same tasks in different order', () {
      final tasksListOne = TasksList([taskOne, taskTwo]);
      final tasksListTwo = TasksList([taskTwo, taskOne]);

      expect(tasksListOne, isNot(equals(tasksListTwo)));
    });

    test('should not be equal when containing different tasks', () {
      final tasksListOne = TasksList([taskOne, taskTwo]);
      final tasksListTwo = TasksList([taskOne, taskThree]);

      expect(tasksListOne, isNot(equals(tasksListTwo)));
    });

    test('should not be equal when containing different number of tasks', () {
      final tasksListOne = TasksList([taskOne, taskTwo]);
      final tasksListTwo = TasksList([taskOne, taskTwo, taskThree]);

      expect(tasksListOne, isNot(equals(tasksListTwo)));
    });

    test('should be equal when both are empty', () {
      final tasksListOne = TasksList(const []);
      final tasksListTwo = TasksList(const []);

      expect(tasksListOne, equals(tasksListTwo));
    });

    test('should not be equal to null', () {
      final tasksListOne = TasksList([taskOne, taskTwo]);

      expect(tasksListOne, isNot(equals(null)));
    });

    test('should not be equal to non-Tasks object', () {
      final tasksListOne = TasksList([taskOne, taskTwo]);

      expect(tasksListOne, isNot(equals('not a Tasks object')));
    });
  });
}
