// ignore_for_file: avoid_implementing_value_types

import 'package:action/src/modules/tasks/presentation/models/task_view.dart';
import 'package:action/src/modules/tasks/presentation/state/task_view_provider.old.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../utils/provider_container.dart';
import 'tasks_provider_test.dart';

class FakeTaskOperation extends Fake implements TaskViewOperations {}

class FakeTaskViewUI extends Fake implements TaskViewUI {}

void main() {
  late FakeTaskOperation fakeTaskOperation;
  late FakeTaskViewUI fakeTaskViewUI;
  late List<TaskView> fakeTaskViews;

  setUpAll(() {
    registerFallbackValue(FakeTaskOperation());
    registerFallbackValue(FakeTaskViewUI());
  });

  setUp(() {
    fakeTaskOperation = FakeTaskOperation();
    fakeTaskViewUI = FakeTaskViewUI();
    fakeTaskViews = [
      TaskView(operations: fakeTaskOperation, ui: fakeTaskViewUI, id: 'fake_id_01'),
      TaskView(operations: fakeTaskOperation, ui: fakeTaskViewUI, id: 'fake_id_02'),
      TaskView(operations: fakeTaskOperation, ui: fakeTaskViewUI, id: 'fake_id_03'),
      TaskView(operations: fakeTaskOperation, ui: fakeTaskViewUI, id: 'fake_id_04'),
    ];
  });

  group(
    'loadedTaskViewsProvider',
    () {
      test(
        'should return an empty set when no task views are selected',
        () {
          final container = createContainer();

          final loadedTaskViews = container.read(loadedTaskViewsProvider);

          expect(loadedTaskViews, isEmpty);
        },
      );

      test(
        'selecting a task view using selectedTaskViewProvider should add it to the loadedTaskViewsProvider',
        () {
          final container = createContainer(overrides: [
            taskViewProvider.overrideWithValue(fakeTaskViews),
            ...overrideTasksProvider,
          ])
            ..read(loadedTaskViewsProvider);

          container.read(selectedTaskViewProvider.notifier).selectByIndex(1);

          final loadedTaskViews = container.read(loadedTaskViewsProvider);

          expect(loadedTaskViews, contains(fakeTaskViews[1]));
        },
      );

      test(
        'selecting a single task view multiple times does not result in duplicate items in the loadedTaskViewsProvider',
        () {
          final container = createContainer(overrides: [
            taskViewProvider.overrideWithValue(fakeTaskViews),
            ...overrideTasksProvider,
          ])
            ..read(loadedTaskViewsProvider);

          container.read(selectedTaskViewProvider.notifier).selectByIndex(1);
          container.read(selectedTaskViewProvider.notifier).selectByIndex(2);

          container.read(selectedTaskViewProvider.notifier).selectByIndex(1);
          container.read(selectedTaskViewProvider.notifier).selectByIndex(1);
          container.read(selectedTaskViewProvider.notifier).selectByIndex(2);
          container.read(selectedTaskViewProvider.notifier).selectByIndex(1);

          final loadedTaskViews = container.read(loadedTaskViewsProvider);

          expect(loadedTaskViews.length, 2);
          expect(loadedTaskViews, contains(fakeTaskViews[1]));
          expect(loadedTaskViews, contains(fakeTaskViews[2]));
        },
      );
    },
  );
}
