import 'package:action/src/modules/projects/domain/entity/project.dart';
import 'package:action/src/modules/projects/domain/entity/project_relation_metadata.dart';
import 'package:action/src/modules/projects/domain/repository/project_repository.dart';
import 'package:action/src/modules/projects/domain/use_case/project_use_case.dart';
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
}
