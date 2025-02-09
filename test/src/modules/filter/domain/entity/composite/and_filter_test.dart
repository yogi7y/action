import 'package:action/src/modules/filter/domain/entity/composite/and_filter.dart';
import 'package:action/src/modules/filter/domain/entity/filter.dart';
import 'package:action/src/modules/filter/domain/entity/filter_operations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFilter extends Mock implements Filter {}

class MockFilterOperations extends Mock implements FilterOperations<bool> {}

void main() {
  group('AndFilter', () {
    late List<Filter> filters;
    late AndFilter systemUnderTest;
    late MockFilterOperations operations;

    setUp(() {
      filters = [MockFilter(), MockFilter()];
      systemUnderTest = AndFilter(filters);
      operations = MockFilterOperations();
    });

    test('constructor should store the provided filters', () {
      expect(systemUnderTest.filters, equals(filters));
    });

    test('accept should call visitAnd on the visitor', () {
      when(() => operations.visitAnd(systemUnderTest)).thenReturn(true);

      final result = systemUnderTest.accept(operations);

      expect(result, isTrue);
      verify(() => operations.visitAnd(systemUnderTest)).called(1);
    });

    test('empty filter list should be allowed', () {
      const emptyFilter = AndFilter([]);
      expect(emptyFilter.filters, isEmpty);
    });
  });
}
