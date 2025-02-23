import 'package:action/src/modules/filter/domain/entity/composite/and_filter.dart';
import 'package:action/src/modules/filter/domain/entity/composite/or_filter.dart';
import 'package:action/src/modules/filter/domain/entity/filter.dart';
import 'package:action/src/modules/filter/domain/entity/filter_operations.dart';
import 'package:action/src/modules/tasks/domain/entity/filters/task_filter_operations.dart';
import 'package:action/src/modules/tasks/domain/entity/task_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFilter extends Mock implements Filter {}

// ignore: avoid_implementing_value_types
class FakeTaskEntity extends Fake implements TaskEntity {}

void main() {
  late InMemoryFilterOperations<TaskEntity> operations;
  late MockFilter mockFilter;

  setUpAll(() {
    registerFallbackValue(FakeTaskEntity());
  });

  setUp(() {
    mockFilter = MockFilter();
    operations = InMemoryTaskFilterOperations(FakeTaskEntity());
  });

  group('InMemoryFilterOperations.visitAnd', () {
    test('should return true when all filters return true', () {
      when(() => mockFilter.accept(operations)).thenReturn(true);

      final andFilter = AndFilter([mockFilter, mockFilter]);
      final result = operations.visitAnd(andFilter);

      expect(result, isTrue);
      verify(() => mockFilter.accept(operations)).called(2);
    });

    test('should return false when any filter returns false', () {
      when(() => mockFilter.accept(operations)).thenReturn(true);
      final failingFilter = MockFilter();
      when(() => failingFilter.accept(operations)).thenReturn(false);

      final andFilter = AndFilter([mockFilter, failingFilter]);
      final result = operations.visitAnd(andFilter);

      expect(result, isFalse);
      verify(() => mockFilter.accept(operations)).called(1);
      verify(() => failingFilter.accept(operations)).called(1);
    });

    test('should return true for empty filter list', () {
      const andFilter = AndFilter([]);
      final result = operations.visitAnd(andFilter);
      expect(result, isTrue);
    });
  });

  group('InMemoryFilterOperations.visitOr', () {
    test('should return true when any filter returns true', () {
      when(() => mockFilter.accept(operations)).thenReturn(false);
      final passingFilter = MockFilter();
      when(() => passingFilter.accept(operations)).thenReturn(true);

      final orFilter = OrFilter([mockFilter, passingFilter]);
      final result = operations.visitOr(orFilter);

      expect(result, isTrue);
      verify(() => mockFilter.accept(operations)).called(1);
      verify(() => passingFilter.accept(operations)).called(1);
    });

    test('should return false when all filters return false', () {
      when(() => mockFilter.accept(operations)).thenReturn(false);

      final orFilter = OrFilter([mockFilter, mockFilter]);
      final result = operations.visitOr(orFilter);

      expect(result, isFalse);
      verify(() => mockFilter.accept(operations)).called(2);
    });

    test('should return false for empty filter list', () {
      const orFilter = OrFilter([]);
      final result = operations.visitOr(orFilter);
      expect(result, isFalse);
    });
  });
}
