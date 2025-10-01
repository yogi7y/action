import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/entity/tasks/tasks_list.dart';
import 'package:action/src/modules/tasks/presentation/mixin/in_memory_task_operations.dart';
import 'package:action/src/modules/tasks/presentation/models/task_list_view_data.dart';
import 'package:action/src/modules/tasks/presentation/state/tasks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../utils/provider_container.dart';

class TestInMemoryTaskOperations with InMemoryTaskOperations {}

// ignore: avoid_implementing_value_types
class MockTaskListViewData extends Mock implements TaskListViewData {}

// ignore: avoid_implementing_value_types
class MockTaskList extends Mock implements TasksList {}

/// 1. task should be added to the view if it belongs.
/// 2. task should be removed from the view if it doesn't belong.
/// 3. task should be updated in the view if it belongs.
/// 4. task should be added to multiple views if it belongs to multiple views.
/// 5. task should be removed from multiple views if it doesn't belong to any view.
///

void main() {
  /// Test task
  late TaskEntity task;

  /// Test class that implements [InMemoryTaskOperations].
  late TestInMemoryTaskOperations testInMemoryTaskOperations;

  /// Mock loaded task view data.
  late MockTaskListViewData mockLoadedTaskViewData1;
  late MockTaskListViewData mockLoadedTaskViewData2;
  late MockTaskListViewData mockLoadedTaskViewData3;

  /// Tasks list
  late MockTaskList mockTaskList1;
  late MockTaskList mockTaskList2;
  late MockTaskList mockTaskList3;

  /// Set of loaded task view data.
  late Set<TaskListViewData> loadedViews;

  late ProviderContainer container;

  setUp(() {
    task = const TaskEntity(name: 'Task 1');
    testInMemoryTaskOperations = TestInMemoryTaskOperations();

    mockLoadedTaskViewData1 = MockTaskListViewData();
    mockLoadedTaskViewData2 = MockTaskListViewData();
    mockLoadedTaskViewData3 = MockTaskListViewData();

    loadedViews = {
      mockLoadedTaskViewData1,
      mockLoadedTaskViewData2,
      mockLoadedTaskViewData3,
    };

    mockTaskList1 = MockTaskList();
    mockTaskList2 = MockTaskList();
    mockTaskList3 = MockTaskList();

    container = createContainer();

    container.read(tasksProvider(mockLoadedTaskViewData1).notifier).updateState(mockTaskList1);
  });

  test(
    'task should be added to the view if it belongs to the view',
    () {
      testInMemoryTaskOperations.handleInMemoryTaskOperations(task, loadedViews);
    },
  );
}
