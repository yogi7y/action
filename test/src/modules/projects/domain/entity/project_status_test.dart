import 'package:action/src/modules/projects/domain/entity/project_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProjectStatus', () {
    test('fromString should return correct enum value', () {
      expect(ProjectStatus.fromString('not_started'), ProjectStatus.notStarted);
      expect(ProjectStatus.fromString('on_hold'), ProjectStatus.onHold);
      expect(ProjectStatus.fromString('do_next'), ProjectStatus.doNext);
      expect(ProjectStatus.fromString('in_progress'), ProjectStatus.inProgress);
      expect(ProjectStatus.fromString('done'), ProjectStatus.done);
      expect(ProjectStatus.fromString('archive'), ProjectStatus.archive);
    });

    test('fromString should throw ArgumentError for invalid status', () {
      expect(
        () => ProjectStatus.fromString('invalid_status'),
        throwsArgumentError,
      );
    });

    test('value should return correct string representation', () {
      expect(ProjectStatus.notStarted.value, 'not_started');
      expect(ProjectStatus.onHold.value, 'on_hold');
      expect(ProjectStatus.doNext.value, 'do_next');
      expect(ProjectStatus.inProgress.value, 'in_progress');
      expect(ProjectStatus.done.value, 'done');
      expect(ProjectStatus.archive.value, 'archive');
    });
  });
}
