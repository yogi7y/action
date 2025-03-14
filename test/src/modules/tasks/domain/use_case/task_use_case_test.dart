import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/repository/task_repository.dart';
import 'package:action/src/modules/tasks/domain/use_case/task_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Import your necessary dependencies

class FakeTaskEntity extends Fake implements TaskEntity {
  FakeTaskEntity({
    required this.createdAt,
  });

  @override
  final DateTime createdAt;
}

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late TaskUseCase systemUnderTest;
  late MockTaskRepository mockTaskRepository;
  setUp(() {
    mockTaskRepository = MockTaskRepository();
    systemUnderTest = TaskUseCase(mockTaskRepository);
  });

  // Tests for TaskUseCase will go here
}
