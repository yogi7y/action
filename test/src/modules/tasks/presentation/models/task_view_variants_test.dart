import 'package:action/src/modules/filter/domain/entity/composite/and_filter.dart';
import 'package:action/src/modules/filter/domain/entity/variants/select_filter.dart';
import 'package:action/src/modules/tasks/domain/entity/task_status.dart';
import 'package:action/src/modules/tasks/presentation/models/task_filters.dart';
import 'package:action/src/modules/tasks/presentation/models/task_view.dart';
import 'package:action/src/modules/tasks/presentation/models/task_view_variants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ignore: avoid_implementing_value_types
class FakeTaskViewUI extends Fake implements TaskViewUI {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeTaskViewUI());
  });

  group('StatusTaskView', () {
    test('in progress: has filter that checks if task is organized and status is in progress', () {
      final inProgressTaskView = StatusTaskView(
        status: TaskStatus.inProgress,
        ui: FakeTaskViewUI(),
        id: '',
      );

      final expectedFilter = AndFilter([
        const OrganizedFilter(),
        StatusFilter(TaskStatus.inProgress),
      ]);

      expect(inProgressTaskView.operations.filter, expectedFilter);
    });

    test('todo: has filter that checks if task is organized and status is todo', () {
      final todoTaskView = StatusTaskView(
        status: TaskStatus.todo,
        ui: FakeTaskViewUI(),
        id: '',
      );

      final expectedFilter = AndFilter([
        const OrganizedFilter(),
        StatusFilter(TaskStatus.todo),
      ]);

      expect(todoTaskView.operations.filter, expectedFilter);
    });
  });

  group('AllTasksView', () {
    test('has filter that selects all tasks without any filtering', () {
      final allTasksView = AllTasksView(
        ui: FakeTaskViewUI(),
        id: '',
      );

      const expectedFilter = SelectFilter();

      expect(allTasksView.operations.filter, expectedFilter);
    });
  });

  group('UnorganizedTaskView', () {
    test('has filter that checks if task is not organized', () {
      final unorganizedTaskView = UnorganizedTaskView(
        ui: FakeTaskViewUI(),
        id: '',
      );

      const expectedFilter = OrganizedFilter(isOrganized: false);

      expect(unorganizedTaskView.operations.filter, expectedFilter);
    });
  });
}
