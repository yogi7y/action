import 'package:action/src/core/exceptions/in_memory_filter_exception.dart';
import 'package:action/src/modules/filter/domain/entity/variants/equals_filter.dart';
import 'package:action/src/modules/filter/domain/entity/variants/greater_than_filter.dart';
import 'package:action/src/modules/tasks/domain/entity/filters/task_filter_operations.dart';
import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:action/src/modules/tasks/domain/entity/task_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ignore: avoid_implementing_value_types
class MockTaskEntity extends Mock implements TaskEntity {}

void main() {
  late InMemoryTaskFilterOperations systemUnderTest;
  late MockTaskEntity mockTask;

  setUp(() {
    mockTask = MockTaskEntity();
    systemUnderTest = InMemoryTaskFilterOperations(mockTask);
  });

  group('visitEquals', () {
    test('should return true if the task status matches the filter value', () {
      when(() => mockTask.status).thenReturn(TaskStatus.todo);

      final result = systemUnderTest.visitEquals(EqualsFilter(
        key: InMemoryTaskFilterOperations.statusKey,
        value: TaskStatus.todo.value,
      ));

      expect(result, isTrue);
    });

    test('should return true if the task isOrganized matches the filter value', () {
      when(() => mockTask.isOrganized).thenReturn(true);

      final result = systemUnderTest.visitEquals(const EqualsFilter(
        key: InMemoryTaskFilterOperations.isOrganizedKey,
        value: true,
      ));

      expect(result, isTrue);
    });

    test(
      'should return false when if the task is not organized but the filter is passed in as true',
      () {
        when(() => mockTask.isOrganized).thenReturn(false);

        final result = systemUnderTest.visitEquals(const EqualsFilter(
          key: InMemoryTaskFilterOperations.isOrganizedKey,
          value: true,
        ));

        expect(result, isFalse);
      },
    );

    test('should return true if the task projectId matches the filter value', () {
      when(() => mockTask.projectId).thenReturn('project-123');

      final result = systemUnderTest.visitEquals(const EqualsFilter(
        key: InMemoryTaskFilterOperations.projectIdKey,
        value: 'project-123',
      ));

      expect(result, isTrue);
    });

    test('should return true if the task contextId matches the filter value', () {
      when(() => mockTask.contextId).thenReturn('context-123');

      final result = systemUnderTest.visitEquals(const EqualsFilter(
        key: InMemoryTaskFilterOperations.contextIdKey,
        value: 'context-123',
      ));

      expect(result, isTrue);
    });

    test('should return true if the task id matches the filter value', () {
      when(() => mockTask.id).thenReturn('task-123');

      final result = systemUnderTest.visitEquals(const EqualsFilter(
        key: InMemoryTaskFilterOperations.idKey,
        value: 'task-123',
      ));

      expect(result, isTrue);
    });

    test('should throw InMemoryFilterException when key does not exist', () {
      const invalidKey = 'invalid_key';
      const filter = EqualsFilter(key: invalidKey, value: 'some_value');

      expect(
        () => systemUnderTest.visitEquals(filter),
        throwsA(
          isA<InMemoryFilterException>().having(
            (e) => e.exception,
            'exception',
            'Either the key $invalidKey does not exist or the value some_value (String) is not of the expected type.',
          ),
        ),
      );
    });

    test(
        'should throw InMemoryFilterException when key exists but value is not of the expected type',
        () {
      const filter = EqualsFilter(key: InMemoryTaskFilterOperations.statusKey, value: 123);

      expect(
        () => systemUnderTest.visitEquals(filter),
        throwsA(
          isA<InMemoryFilterException>().having(
            (e) => e.exception,
            'exception',
            'Either the key ${InMemoryTaskFilterOperations.statusKey} does not exist or the value 123 (int) is not of the expected type.',
          ),
        ),
      );
    });
  });

  group('visitGreaterThan', () {
    test('should return true when task due date is after filter date', () {
      final filterDate = DateTime(2024);
      final taskDate = DateTime(2024, 1, 2);

      when(() => mockTask.dueDate).thenReturn(taskDate);

      final result = systemUnderTest.visitGreaterThan(GreaterThanFilter(
        key: InMemoryTaskFilterOperations.dueDateKey,
        value: filterDate,
      ));

      expect(result, isTrue);
    });

    test('should return false when task due date is before filter date', () {
      final filterDate = DateTime(2024, 1, 2);
      final taskDate = DateTime(2024);

      when(() => mockTask.dueDate).thenReturn(taskDate);

      final result = systemUnderTest.visitGreaterThan(GreaterThanFilter(
        key: InMemoryTaskFilterOperations.dueDateKey,
        value: filterDate,
      ));

      expect(result, isFalse);
    });

    test('should return false when task due date is equal to filter date', () {
      final date = DateTime(2024);

      when(() => mockTask.dueDate).thenReturn(date);

      final result = systemUnderTest.visitGreaterThan(GreaterThanFilter(
        key: InMemoryTaskFilterOperations.dueDateKey,
        value: date,
      ));

      expect(result, isFalse);
    });

    test('should return false when task due date is null', () {
      when(() => mockTask.dueDate).thenReturn(null);

      final result = systemUnderTest.visitGreaterThan(GreaterThanFilter(
        key: InMemoryTaskFilterOperations.dueDateKey,
        value: DateTime(2024),
      ));

      expect(result, isFalse);
    });

    test('should throw InMemoryFilterException when key does not exist', () {
      const invalidKey = 'invalid_key';
      final filter = GreaterThanFilter(
        key: invalidKey,
        value: DateTime(2024),
      );

      expect(
        () => systemUnderTest.visitGreaterThan(filter),
        throwsA(
          isA<InMemoryFilterException>().having(
            (e) => e.exception,
            'exception',
            'Either the key $invalidKey does not exist or the value ${filter.value} (DateTime) is not of the expected type.',
          ),
        ),
      );
    });

    test('should throw InMemoryFilterException when value is not DateTime', () {
      const filter = GreaterThanFilter(
        key: InMemoryTaskFilterOperations.dueDateKey,
        value: 'not-a-date',
      );

      expect(
        () => systemUnderTest.visitGreaterThan(filter),
        throwsA(
          isA<InMemoryFilterException>().having(
            (e) => e.exception,
            'exception',
            'Either the key ${filter.key} does not exist or the value ${filter.value} (String) is not of the expected type.',
          ),
        ),
      );
    });
  });
}
