import 'package:action/src/core/constants/strings.dart';
import 'package:action/src/core/exceptions/no_internet_exception.dart';
import 'package:action/src/modules/projects/data/data_source/project_remote_data_source.dart';
import 'package:action/src/modules/projects/data/models/project_model.dart';
import 'package:action/src/modules/projects/data/models/project_relation_metadata_model.dart';
import 'package:action/src/modules/projects/data/repository/supabase_project_repository.dart';
import 'package:action/src/modules/projects/domain/entity/project.dart';
import 'package:action/src/modules/projects/domain/entity/project_relation_metadata.dart';
import 'package:action/src/services/connectivity/connectivity_checker.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivityChecker extends Mock implements ConnectivityChecker {}

class MockProjectRemoteDataSource extends Mock implements ProjectRemoteDataSource {}

// ignore: avoid_implementing_value_types
class MockProjectModel extends Mock implements ProjectModel {}

// ignore: avoid_implementing_value_types
class MockProjectRelationMetadataModel extends Mock implements ProjectRelationMetadataModel {}

void main() {
  late SupabaseProjectRepository repository;
  late MockConnectivityChecker connectivityChecker;
  late MockProjectRemoteDataSource remoteDataSource;
  late MockProjectModel mockProject;
  late MockProjectRelationMetadataModel mockProjectRelationMetadata;
  setUp(() {
    connectivityChecker = MockConnectivityChecker();
    remoteDataSource = MockProjectRemoteDataSource();
    mockProject = MockProjectModel();
    repository = SupabaseProjectRepository(
      connectivityChecker: connectivityChecker,
      remoteDataSource: remoteDataSource,
    );
    mockProjectRelationMetadata = MockProjectRelationMetadataModel();
  });

  group('fetchProjects', () {
    test('should return Success with projects when online and fetch successful', () async {
      when(() => connectivityChecker.currentStatus).thenReturn(ConnectivityStatus.connected);
      when(() => remoteDataSource.fetchProjects()).thenAnswer((_) async => [mockProject]);

      final result = await repository.fetchProjects();

      expect(result, isA<Success<List<ProjectEntity>, AppException>>());
      expect((result as Success<List<ProjectEntity>, AppException>).value, [mockProject]);
      verify(() => connectivityChecker.currentStatus).called(1);
      verify(() => remoteDataSource.fetchProjects()).called(1);
    });

    test('should return Failure when offline', () async {
      when(() => connectivityChecker.currentStatus).thenReturn(ConnectivityStatus.disconnected);

      final result = await repository.fetchProjects();

      expect(result, isA<Failure<List<ProjectEntity>, AppException>>());
      expect(
          (result as Failure<List<ProjectEntity>, AppException>).error, isA<NoInternetException>());

      expect(result.error.userFriendlyMessage, equals(AppStrings.noInternetConnection));
      verify(() => connectivityChecker.currentStatus).called(1);
      verifyNever(() => remoteDataSource.fetchProjects());
    });
  });

  group('getProjectById', () {
    const projectId = 'test-id';

    test('should return Success with project when online and fetch successful', () async {
      when(() => connectivityChecker.currentStatus).thenReturn(ConnectivityStatus.connected);
      when(() => remoteDataSource.getProjectById(projectId)).thenAnswer((_) async => mockProject);

      final result = await repository.getProjectById(projectId);

      expect(result, isA<Success<ProjectEntity, AppException>>());
      expect((result as Success<ProjectEntity, AppException>).value, mockProject);
      verify(() => connectivityChecker.currentStatus).called(1);
      verify(() => remoteDataSource.getProjectById(projectId)).called(1);
    });

    test('should return Failure when offline', () async {
      when(() => connectivityChecker.currentStatus).thenReturn(ConnectivityStatus.disconnected);

      final result = await repository.getProjectById(projectId);

      expect(result, isA<Failure<ProjectEntity, AppException>>());
      expect((result as Failure<ProjectEntity, AppException>).error, isA<NoInternetException>());
      verify(() => connectivityChecker.currentStatus).called(1);
      verifyNever(() => remoteDataSource.getProjectById(projectId));
    });
  });

  group('updateProject', () {
    test('should return Success with updated project when online and update successful', () async {
      when(() => connectivityChecker.currentStatus).thenReturn(ConnectivityStatus.connected);
      when(() => mockProject.id).thenReturn('test-id');
      when(() => mockProject.toMap()).thenReturn({'id': 'test-id'});
      when(() => remoteDataSource.updateProject(any(), any())).thenAnswer((_) async => mockProject);

      final result = await repository.updateProject(mockProject);

      expect(result, isA<Success<ProjectEntity, AppException>>());
      expect((result as Success<ProjectEntity, AppException>).value, mockProject);
      verify(() => connectivityChecker.currentStatus).called(1);
      verify(() => remoteDataSource.updateProject(any(), any())).called(1);
    });

    test('should return Failure when offline', () async {
      when(() => connectivityChecker.currentStatus).thenReturn(ConnectivityStatus.disconnected);

      final result = await repository.updateProject(mockProject);

      expect(result, isA<Failure<ProjectEntity, AppException>>());
      expect((result as Failure<ProjectEntity, AppException>).error, isA<NoInternetException>());
      verify(() => connectivityChecker.currentStatus).called(1);
      verifyNever(() => remoteDataSource.updateProject(any(), any()));
    });

    test('should return Failure with AppException when error occurs', () async {
      when(() => connectivityChecker.currentStatus).thenReturn(ConnectivityStatus.connected);
      when(() => repository.updateProject(mockProject)).thenThrow(Exception('Test error'));

      final result = await repository.updateProject(mockProject);

      expect(result, isA<Failure<ProjectEntity, AppException>>());
      final failure = result as Failure<ProjectEntity, AppException>;
      expect(failure.error, isA<AppException>());
    });
  });

  group('getProjectRelationMetadata', () {
    test('should return Success with project relation metadata when online and fetch successful',
        () async {
      when(() => connectivityChecker.currentStatus).thenReturn(ConnectivityStatus.connected);
      when(() => remoteDataSource.getProjectRelationMetadata(any()))
          .thenAnswer((_) async => mockProjectRelationMetadata);

      final result = await repository.getProjectRelationMetadata('test-id');

      expect(result, isA<Success<ProjectRelationMetadata, AppException>>());
      expect((result as Success<ProjectRelationMetadata, AppException>).value,
          mockProjectRelationMetadata);
    });

    test('should return Failure when offline', () async {
      when(() => connectivityChecker.currentStatus).thenReturn(ConnectivityStatus.disconnected);

      final result = await repository.getProjectRelationMetadata('test-id');

      expect(result, isA<Failure<ProjectRelationMetadata, AppException>>());
      expect((result as Failure<ProjectRelationMetadata, AppException>).error,
          isA<NoInternetException>());
      verify(() => connectivityChecker.currentStatus).called(1);
      verifyNever(() => remoteDataSource.getProjectRelationMetadata(any()));
    });
  });
}
