import 'package:action/src/modules/filter/domain/entity/filter_visitor.dart';
import 'package:action/src/modules/filter/domain/entity/variants/equals_filter.dart';
import 'package:action/src/modules/filter/domain/entity/variants/greater_than_filter.dart';
import 'package:action/src/modules/tasks/domain/entity/filters/task_filter_operations.dart';
import 'package:action/src/modules/tasks/domain/entity/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEqualsFilter extends Mock implements EqualsFilter {}

class MockGreaterThanFilter extends Mock implements GreaterThanFilter {}

class FakeTaskEntity extends Fake implements TaskEntity {}

void main() {
  late InMemoryFilterOperations<TaskEntity> operations;
  late MockEqualsFilter equalsFilter;
  late MockGreaterThanFilter greaterThanFilter;

  setUpAll(() {
    registerFallbackValue(FakeTaskEntity());
  });

  setUp(() {
    equalsFilter = MockEqualsFilter();
    greaterThanFilter = MockGreaterThanFilter();
    operations = InMemoryTaskFilterOperations(FakeTaskEntity());
  });

  group(
    'InMemoryFilterOperations.validateAll',
    () {
      test('return true if all the filters are valid', () {
        when(() => equalsFilter.accept(operations)).thenReturn(true);
        when(() => greaterThanFilter.accept(operations)).thenReturn(true);

        final result = operations.validateAll([equalsFilter, greaterThanFilter]);
        expect(result, isTrue);
        verify(() => equalsFilter.accept(operations)).called(1);
        verify(() => greaterThanFilter.accept(operations)).called(1);
      });

      test('return false if any of the filters are invalid', () {
        when(() => equalsFilter.accept(operations)).thenReturn(true);
        when(() => greaterThanFilter.accept(operations)).thenReturn(false);

        final result = operations.validateAll([equalsFilter, greaterThanFilter]);
        expect(result, isFalse);
        verify(() => equalsFilter.accept(operations)).called(1);
        verify(() => greaterThanFilter.accept(operations)).called(1);
      });
    },
  );
}
