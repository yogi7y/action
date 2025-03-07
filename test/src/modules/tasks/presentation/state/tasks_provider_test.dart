import 'package:action/src/core/network/paginated_response.dart';
import 'package:action/src/modules/filter/domain/entity/filter.dart';
import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/entity/task_status.dart';
import 'package:action/src/modules/tasks/domain/use_case/task_use_case.dart';
import 'package:action/src/modules/tasks/presentation/models/task_view.dart';
import 'package:action/src/modules/tasks/presentation/state/task_view_provider.dart';
import 'package:action/src/modules/tasks/presentation/state/tasks_provider.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskUseCase extends Mock implements TaskUseCase {}

class MockFilter extends Mock implements Filter {}

class MockTaskViewOperations extends Mock implements TaskViewOperations {
  MockTaskViewOperations(this.filter);

  @override
  final Filter filter;
}

ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

void main() {
  late MockTaskUseCase mockTaskUseCase;
  late TaskView testTaskView;
  late MockFilter mockFilter;

  setUp(() {
    mockTaskUseCase = MockTaskUseCase();
    mockFilter = MockFilter();

    // Create a test TaskView with mock operations
    testTaskView = TaskView(
      operations: MockTaskViewOperations(mockFilter),
      ui: const TaskViewUI(label: 'Test View'),
      id: 'test_view',
    );

    // Register the fallback values
    registerFallbackValue(MockFilter());
  });

  group('TasksNotifier Tests', () {
    test('should call fetchTasks with correct filter when provider is read', () async {
      // Setup mock response
      final mockTasks = [
        TaskEntity(
          id: '1',
          name: 'Test Task',
          status: TaskStatus.todo,
          createdAt: DateTime.now(),
        ),
      ];

      final mockPaginatedResponse = PaginatedResponse<TaskEntity>(
        results: mockTasks,
        total: 1,
      );

      // Setup the mock to return a successful result
      when(() => mockTaskUseCase.fetchTasks(any()))
          .thenAnswer((_) async => Success(mockPaginatedResponse));

      // Create a container with overridden providers
      final container = createContainer(
        overrides: [
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ],
      );

      // Read the provider to trigger the build method
      final asyncValue = await container.read(tasksNotifierProvider(testTaskView).future);

      // Verify that fetchTasks was called with the correct filter
      verify(() => mockTaskUseCase.fetchTasks(mockFilter)).called(1);

      // Verify the result matches expected data
      expect(asyncValue, equals(mockTasks));
    });

    test('should handle failure when fetching tasks', () async {
      // Setup mock response for failure
      final exception = AppException(
        exception: Exception('Failed to fetch tasks'),
        stackTrace: StackTrace.current,
      );

      // Setup the mock to return a failure result
      when(() => mockTaskUseCase.fetchTasks(any())).thenAnswer((_) async => Failure(exception));

      // Create a container with overridden providers
      final container = createContainer(
        overrides: [
          taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
        ],
      );

      // Read the provider to trigger the build method
      final asyncValue = await container.read(tasksNotifierProvider(testTaskView).future);

      // Verify that fetchTasks was called with the correct filter
      verify(() => mockTaskUseCase.fetchTasks(mockFilter)).called(1);

      // Verify the result is an empty list on failure
      expect(asyncValue, equals([]));
    });
  });
}
