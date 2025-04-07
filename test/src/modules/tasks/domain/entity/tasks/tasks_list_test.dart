import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/entity/tasks/tasks_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TasksList', () {
    late TasksList tasksList;
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

    test('should be empty by default', () {
      tasksList = TasksList([]);
      expect(tasksList.value, isEmpty);
    });

    test('should have values when populated via constructor', () {
      tasksList = TasksList([taskOne, taskTwo]);
      expect(tasksList.value.length, 2);
      expect(tasksList.value.first, taskOne);
      expect(tasksList.value.last, taskTwo);
    });

    group('insert', () {
      test('should insert task at specified index', () {
        tasksList = TasksList([taskOne, taskTwo])..insert(1, taskThree);
        expect(tasksList.value.length, 3);
        expect(tasksList.value.elementAt(1), taskThree);
      });
    });

    group('insertAtStart', () {
      test('should insert task at the beginning of the list', () {
        tasksList = TasksList([taskOne, taskTwo])..insertAtStart(taskThree);
        expect(tasksList.value.length, 3);
        expect(tasksList.value.first, taskThree);
      });
    });

    group('indexOf', () {
      test('should return correct index of task', () {
        tasksList = TasksList([taskOne, taskTwo]);
        expect(tasksList.indexOf(taskOne), 0);
        expect(tasksList.indexOf(taskTwo), 1);
      });

      test('should return -1 when task is not found', () {
        tasksList = TasksList([taskOne, taskTwo]);
        expect(tasksList.indexOf(taskThree), -1);
      });
    });

    group('getInsertIndex', () {
      test('should return correct index for task that should go at the beginning (newest task)',
          () {
        tasksList = TasksList([taskOne, taskTwo]);
        final newTask = TaskEntity(
          id: '4',
          name: 'New Task',
          createdAt: DateTime(2024, 3, 1, 17), // 5:00 PM (newest)
        );
        expect(tasksList.getInsertIndex(newTask), 0);
      });

      test('should return correct index for task that should go in the middle', () {
        tasksList = TasksList([taskThree, taskOne]); // Sorted by createdAt descending
        final newTask = TaskEntity(
          id: '4',
          name: 'New Task',
          createdAt: DateTime(2024, 3, 1, 15), // 3:00 PM (between taskThree and taskOne)
        );
        expect(tasksList.getInsertIndex(newTask), 1);
      });

      test('should return correct index for task that should go at the end (oldest task)', () {
        tasksList = TasksList([taskThree, taskTwo]); // Sorted by createdAt descending
        final newTask = TaskEntity(
          id: '4',
          name: 'New Task',
          createdAt: DateTime(2024, 3, 1, 13), // 1:00 PM (oldest)
        );
        expect(tasksList.getInsertIndex(newTask), 2);
      });

      test('should handle empty list', () {
        tasksList = TasksList([]);
        final newTask = TaskEntity(
          id: '4',
          name: 'New Task',
          createdAt: DateTime(2024, 3, 1, 14),
        );
        expect(tasksList.getInsertIndex(newTask), 0);
      });

      test('should handle task with same timestamp (should be placed after)', () {
        tasksList = TasksList([taskThree, taskTwo, taskOne]);
        final newTask = TaskEntity(
          id: '4',
          name: 'New Task',
          createdAt: DateTime(2024, 3, 1, 15), // Same as taskTwo
        );
        expect(tasksList.getInsertIndex(newTask), 2);
      });
    });
  });
}
