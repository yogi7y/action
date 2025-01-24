import 'package:action/src/modules/projects/domain/entity/project.dart';
import 'package:action/src/modules/projects/domain/entity/project_status.dart';
import 'package:action/src/modules/projects/domain/use_case/project_use_case.dart';
import 'package:action/src/modules/projects/presentation/state/project_detail_provider.dart';
import 'package:action/src/modules/projects/presentation/view_models/project_view_model.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProjectUseCase extends Mock implements ProjectUseCase {}

class FakeAppException extends Fake implements AppException {}

// ignore: avoid_implementing_value_types
class FakeDateTime extends Fake implements DateTime {}

void main() {
  late ProviderContainer container;
  late MockProjectUseCase mockUseCase;
  late ProjectEntity testProject;
  late ProjectViewModel testViewModel;

  setUpAll(() {
    registerFallbackValue(FakeAppException());
    registerFallbackValue(FakeDateTime());
  });

  setUp(() {
    mockUseCase = MockProjectUseCase();
    testProject = ProjectEntity(
      id: '1',
      name: 'Test Project',
      createdAt: FakeDateTime(),
      updatedAt: FakeDateTime(),
      status: ProjectStatus.notStarted,
    );
    testViewModel = ProjectViewModel(
      project: testProject,
      totalTasks: 0,
      totalPages: 0,
    );

    container = ProviderContainer(
      overrides: [
        projectUseCaseProvider.overrideWithValue(mockUseCase),
        projectNotifierProvider.overrideWith(() => ProjectNotifier(testViewModel)),
      ],
    );

    addTearDown(container.dispose);
  });

  group('ProjectNotifier', () {
    test('initial state should match provided view model', () {
      final notifier = container.read(projectNotifierProvider.notifier);
      expect(notifier.state, equals(testViewModel));
    });

    group('updateProject', () {
      test('should update state optimistically and keep new state on success', () async {
        final updatedProject = testProject.copyWith(name: 'Updated Name');
        when(() => mockUseCase.updateProject(updatedProject)).thenAnswer(
          (_) async => Success(updatedProject),
        );

        await container.read(projectNotifierProvider.notifier).updateProject(
              (project) => project.copyWith(name: 'Updated Name'),
            );

        verify(() => mockUseCase.updateProject(updatedProject)).called(1);
        expect(
          container.read(projectNotifierProvider).project.name,
          equals('Updated Name'),
        );
      });

      test('should revert to previous state on failure', () async {
        final previousState = container.read(projectNotifierProvider);
        final updatedProject = testProject.copyWith(name: 'Updated Name');
        when(() => mockUseCase.updateProject(updatedProject)).thenAnswer(
          (_) async {
            await Future<void>.delayed(const Duration(milliseconds: 1));
            return Failure(FakeAppException());
          },
        );

        await expectLater(
          container.read(projectNotifierProvider.notifier).updateProject(
                (project) => project.copyWith(name: 'Updated Name'),
              ),
          throwsA(isA<AppException>()),
        );

        expect(
          container.read(projectNotifierProvider),
          equals(previousState),
        );
      });

      test('should revert to previous state on exception', () async {
        final previousState = container.read(projectNotifierProvider);
        final updatedProject = testProject.copyWith(name: 'Updated Name');
        when(() => mockUseCase.updateProject(updatedProject))
            .thenThrow(Exception('Unexpected error'));

        expect(
          () => container.read(projectNotifierProvider.notifier).updateProject(
                (project) => project.copyWith(name: 'Updated Name'),
              ),
          throwsA(isA<Exception>()),
        );

        expect(
          container.read(projectNotifierProvider),
          equals(previousState),
        );
      });
    });

    group('updateTaskCount', () {
      test('should update total tasks count', () {
        container.read(projectNotifierProvider.notifier).updateTaskCount(
              (current) => current + 1,
            );

        expect(container.read(projectNotifierProvider).totalTasks, equals(1));
      }, skip: "don't recall why I added this");
    });

    group('updatePageCount', () {
      test('should update total pages count', () {
        container.read(projectNotifierProvider.notifier).updatePageCount(
              (current) => current + 1,
            );

        expect(container.read(projectNotifierProvider).totalPages, equals(1));
      }, skip: "don't recall why I added this");
    });
  });
}
