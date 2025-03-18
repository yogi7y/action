import 'package:action/src/modules/filter/domain/entity/composite/or_filter.dart';
import 'package:action/src/modules/filter/domain/entity/filter.dart';
import 'package:action/src/modules/filter/domain/entity/filter_operations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFilter extends Mock implements Filter {}

class MockFilterOperations extends Mock implements FilterOperations<bool> {}

void main() {
  group('OrFilter', () {
    late List<Filter> filters;
    late OrFilter systemUnderTest;
    late MockFilterOperations operations;

    setUp(() {
      filters = [MockFilter(), MockFilter()];
      systemUnderTest = OrFilter(filters);
      operations = MockFilterOperations();
    });

    test('constructor should store the provided filters', () {
      expect(systemUnderTest.filters, equals(filters));
    });

    test('accept should call visitOr on the visitor', () {
      when(() => operations.visitOr(systemUnderTest)).thenReturn(true);

      final result = systemUnderTest.accept(operations);

      expect(result, isTrue);
      verify(() => operations.visitOr(systemUnderTest)).called(1);
    });

    test('empty filter list should be allowed', () {
      const emptyFilter = OrFilter([]);
      expect(emptyFilter.filters, isEmpty);
    });
  });
}
