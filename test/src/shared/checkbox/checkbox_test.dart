import 'package:action/src/modules/projects/domain/entity/project_status.dart';
import 'package:action/src/shared/checkbox/checkbox.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCheckboxState', () {
    group('fromProjectStatus', () {
      test('should return checked for done and archive status', () {
        expect(
          AppCheckboxState.fromProjectStatus(status: ProjectStatus.done),
          AppCheckboxState.checked,
        );
        expect(
          AppCheckboxState.fromProjectStatus(status: ProjectStatus.archive),
          AppCheckboxState.checked,
        );
      });

      test('should return intermediate for in_progress status', () {
        expect(
          AppCheckboxState.fromProjectStatus(status: ProjectStatus.inProgress),
          AppCheckboxState.intermediate,
        );
      });

      test('should return unchecked for notStarted, doNext and onHold status', () {
        expect(
          AppCheckboxState.fromProjectStatus(status: ProjectStatus.notStarted),
          AppCheckboxState.unchecked,
        );
        expect(
          AppCheckboxState.fromProjectStatus(status: ProjectStatus.doNext),
          AppCheckboxState.unchecked,
        );
        expect(
          AppCheckboxState.fromProjectStatus(status: ProjectStatus.onHold),
          AppCheckboxState.unchecked,
        );
      });
    });

    group('toProjectStatus', () {
      test('should return correct ProjectStatus', () {
        expect(AppCheckboxState.checked.toProjectStatus(), ProjectStatus.done);
        expect(AppCheckboxState.intermediate.toProjectStatus(), ProjectStatus.inProgress);
        expect(AppCheckboxState.unchecked.toProjectStatus(), ProjectStatus.notStarted);
      });
    });
  });
}
