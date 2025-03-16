import 'package:flutter_test/flutter_test.dart';
import 'package:action/src/modules/tasks/domain/entity/checklist.dart';

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
}
