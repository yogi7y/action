import 'package:action/src/modules/tasks/domain/entity/task_status.dart';
import 'package:action/src/shared/checkbox/checkbox.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskStatus', () {
    test('fromString should return correct enum value', () {
      expect(TaskStatus.fromString('todo'), TaskStatus.todo);
      expect(TaskStatus.fromString('do_next'), TaskStatus.doNext);
      expect(TaskStatus.fromString('in_progress'), TaskStatus.inProgress);
      expect(TaskStatus.fromString('done'), TaskStatus.done);
      expect(TaskStatus.fromString('discard'), TaskStatus.discard);
    });

    test('fromString should throw ArgumentError for invalid status', () {
      expect(
        () => TaskStatus.fromString('invalid_status'),
        throwsArgumentError,
      );
    });

    test('value should return correct string representation', () {
      expect(TaskStatus.todo.value, 'todo');
      expect(TaskStatus.doNext.value, 'do_next');
      expect(TaskStatus.inProgress.value, 'in_progress');
      expect(TaskStatus.done.value, 'done');
      expect(TaskStatus.discard.value, 'discard');
    });

    test('displayStatus should return correct human-readable text', () {
      expect(TaskStatus.todo.displayStatus, 'To Do');
      expect(TaskStatus.doNext.displayStatus, 'Do Next');
      expect(TaskStatus.inProgress.displayStatus, 'In Progress');
      expect(TaskStatus.done.displayStatus, 'Done');
      expect(TaskStatus.discard.displayStatus, 'Discard');
    });

    group('AppCheckboxState conversion', () {
      test('fromAppCheckboxState should return correct TaskStatus', () {
        expect(
          TaskStatus.fromAppCheckboxState(AppCheckboxState.unchecked),
          TaskStatus.todo,
        );
        expect(
          TaskStatus.fromAppCheckboxState(AppCheckboxState.intermediate),
          TaskStatus.inProgress,
        );
        expect(
          TaskStatus.fromAppCheckboxState(AppCheckboxState.checked),
          TaskStatus.done,
        );
      });

      test('toAppCheckboxState should return correct AppCheckboxState', () {
        expect(TaskStatus.todo.toAppCheckboxState(), AppCheckboxState.unchecked);
        expect(TaskStatus.doNext.toAppCheckboxState(), AppCheckboxState.unchecked);
        expect(TaskStatus.inProgress.toAppCheckboxState(), AppCheckboxState.intermediate);
        expect(TaskStatus.done.toAppCheckboxState(), AppCheckboxState.checked);
        expect(TaskStatus.discard.toAppCheckboxState(), AppCheckboxState.checked);
      });
    });
  });
}
