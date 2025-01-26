import 'package:action/src/core/network/paginated_response.dart';
import 'package:action/src/modules/projects/domain/entity/project.dart';
import 'package:action/src/modules/projects/domain/entity/project_relation_metadata.dart';
import 'package:action/src/modules/projects/domain/repository/project_repository.dart';
import 'package:action/src/modules/projects/domain/use_case/project_use_case.dart';
import 'package:action/src/modules/tasks/domain/entity/task.dart';
import 'package:action/src/modules/tasks/domain/entity/task_status.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProjectRepository extends Mock implements ProjectRepository {}

// ignore: avoid_implementing_value_types
class FakeProject extends Fake implements ProjectEntity {}

// ignore: avoid_implementing_value_types
class FakeProjectRelationMetadata extends Fake implements ProjectRelationMetadata {}

class FakeAppException extends Fake implements AppException {}

void main() {
  late ProjectUseCase systemUnderTest;
  late MockProjectRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeProject());
    registerFallbackValue(FakeProjectRelationMetadata());
    registerFallbackValue(FakeAppException());
  });

  setUp(() {
    mockRepository = MockProjectRepository();
    systemUnderTest = ProjectUseCase(mockRepository);
  });

  group('ProjectUseCase', () {
    test('fetchProjects calls repository.fetchProjects', () async {
      when(() => mockRepository.fetchProjects()).thenAnswer((_) => Future.value(const Success([])));

      await systemUnderTest.fetchProjects();

      verify(() => mockRepository.fetchProjects()).called(1);
    });

    test('getProjectById calls repository.getProjectById with correct id', () async {
      const projectId = 'test-id';
      when(() => mockRepository.getProjectById(projectId))
          .thenAnswer((_) => Future.value(Success(FakeProject())));

      await systemUnderTest.getProjectById(projectId);

      verify(() => mockRepository.getProjectById(projectId)).called(1);
    });

    test('updateProject calls repository.updateProject with correct project', () async {
      final project = FakeProject();
      when(() => mockRepository.updateProject(project))
          .thenAnswer((_) => Future.value(Success(project)));

      await systemUnderTest.updateProject(project);

      verify(() => mockRepository.updateProject(project)).called(1);
    });

    test(
        'getProjectRelationMetadata calls repository.getProjectRelationMetadata with correct projectId',
        () async {
      const projectId = 'test-project-id';
      when(() => mockRepository.getProjectRelationMetadata(projectId))
          .thenAnswer((_) => Future.value(Success(FakeProjectRelationMetadata())));

      await systemUnderTest.getProjectRelationMetadata(projectId);

      verify(() => mockRepository.getProjectRelationMetadata(projectId)).called(1);
    });
  });

  group('getProjectTasks', () {
    const projectId = 'test-project-id';
    final tasks = [
      TaskEntity(
        id: '1',
        name: 'Task 1',
        projectId: 'test-project-id',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
        status: TaskStatus.todo,
      ),
    ];

    test('returns Success with paginated tasks when repository call succeeds', () async {
      final paginatedResponse = PaginatedResponse(results: tasks);

      when(() => mockRepository.getProjectTasks(
            projectId,
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => Success(paginatedResponse));

      final result = await systemUnderTest.getProjectTasks(
        projectId,
        limit: 20,
      );

      expect(result, isA<Success<PaginatedResponse<TaskEntity>, AppException>>());
      expect((result as Success<PaginatedResponse<TaskEntity>, AppException>).value.results, tasks);
      verify(() => mockRepository.getProjectTasks(
            projectId,
            cursor: null,
            limit: 20,
          )).called(1);
    });

    test('returns Failure when repository call fails', () async {
      when(() => mockRepository.getProjectTasks(
            projectId,
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => Failure(FakeAppException()));

      final result = await systemUnderTest.getProjectTasks(
        projectId,
        limit: 20,
      );

      expect(result, isA<Failure<PaginatedResponse<TaskEntity>, AppException>>());
      verify(() => mockRepository.getProjectTasks(
            projectId,
            cursor: null,
            limit: 20,
          )).called(1);
    });
  });
}
