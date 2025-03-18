import 'package:action/src/core/exceptions/validation_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:action/src/modules/tasks/domain/entity/checklist.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('ChecklistStatus', () {
    group('fromString', () {
      test('should return ChecklistStatus.todo when given "todo"', () {
        // Arrange
        const expectedStatus = ChecklistStatus.todo;
        const statusString = 'todo';

        // Act
        final result = ChecklistStatus.fromString(statusString);

        // Assert
        expect(result, equals(expectedStatus));
      });

      test('should return ChecklistStatus.done when given "done"', () {
        // Arrange
        const expectedStatus = ChecklistStatus.done;
        const statusString = 'done';

        // Act
        final result = ChecklistStatus.fromString(statusString);

        // Assert
        expect(result, equals(expectedStatus));
      });

      test('should throw ArgumentError when given invalid status string', () {
        // Arrange
        const invalidStatusString = 'invalid';

        // Act & Assert
        expect(
          () => ChecklistStatus.fromString(invalidStatusString),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Invalid checklist status: $invalidStatusString',
          )),
        );
      });
    });

    group('value', () {
      test('should return "todo" for ChecklistStatus.todo', () {
        // Arrange
        const status = ChecklistStatus.todo;
        const expectedValue = 'todo';

        // Act
        final result = status.value;

        // Assert
        expect(result, equals(expectedValue));
      });

      test('should return "done" for ChecklistStatus.done', () {
        // Arrange
        const status = ChecklistStatus.done;
        const expectedValue = 'done';

        // Act
        final result = status.value;

        // Assert
        expect(result, equals(expectedValue));
      });
    });
  });

  group('ChecklistEntity.newChecklist', () {
    test('should create a new checklist with default values', () {
      // Arrange
      const title = 'Test Checklist';

      // Act
      final checklist = ChecklistEntity.newChecklist(title);

      // Assert
      expect(checklist.title, equals(title));
      expect(checklist.taskId, isEmpty);
      expect(checklist.status, equals(ChecklistStatus.todo));
      expect(checklist.id, isNull);
      expect(checklist.createdAt, isNull);
      expect(checklist.updatedAt, isNull);
    });

    test('should throw ValidationException when title is empty', () {
      // Arrange
      const emptyTitle = '';

      // Act & Assert
      expect(
        () => ChecklistEntity.newChecklist(emptyTitle),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.userFriendlyMessage,
            'userFriendlyMessage',
            'Title cannot be empty',
          ),
        ),
      );
    });
  });
}
