import 'package:action/src/modules/filter/data/models/supabase_filter_operations.dart';
import 'package:action/src/modules/filter/domain/entity/composite/and_filter.dart';
import 'package:action/src/modules/filter/domain/entity/composite/or_filter.dart';
import 'package:action/src/modules/filter/domain/entity/variants/equals_filter.dart';
import 'package:action/src/modules/filter/domain/entity/variants/greater_than_filter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<dynamic> {}

void main() {
  group('SupabaseFilterOperations', () {
    late MockPostgrestFilterBuilder query;
    late SupabaseFilterOperations<dynamic> systemUnderTest;

    setUp(() {
      query = MockPostgrestFilterBuilder();
      systemUnderTest = SupabaseFilterOperations(query);

      // Setup default behavior for chaining
      when(() => query.eq(any(), any())).thenAnswer((_) => query);
      when(() => query.gt(any(), any())).thenAnswer((_) => query);
      when(() => query.or(any())).thenAnswer((_) => query);
    });

    test('visitEquals should call eq on query builder', () {
      const filter = EqualsFilter(key: 'test', value: 'value');
      systemUnderTest.visitEquals(filter);
      verify(() => query.eq('test', 'value')).called(1);
    });

    test('visitGreaterThan should call gt on query builder', () {
      const filter = GreaterThanFilter(key: 'test', value: 42);
      systemUnderTest.visitGreaterThan(filter);
      verify(() => query.gt('test', 42)).called(1);
    });

    group('visitAnd', () {
      test('should chain filters for AND operation', () {
        const filter = AndFilter([
          EqualsFilter(key: 'status', value: 'active'),
          EqualsFilter(key: 'type', value: 'user'),
        ]);

        systemUnderTest.visitAnd(filter);

        verifyInOrder([
          () => query.eq('status', 'active'),
          () => query.eq('type', 'user'),
        ]);
      });

      test('should handle empty AND filter', () {
        const filter = AndFilter([]);
        final result = systemUnderTest.visitAnd(filter);
        expect(result, equals(query));
        verifyNever(() => query.eq(any(), any()));
      });
    });

    group('visitOr', () {
      test('should chain filters with OR operation', () {
        const filter = OrFilter([
          EqualsFilter(key: 'status', value: 'active'),
          EqualsFilter(key: 'status', value: 'pending'),
        ]);

        systemUnderTest.visitOr(filter);

        verify(() => query.eq('status', 'active')).called(1);
        verify(() => query.or(any())).called(1);
      });

      test('should handle empty OR filter', () {
        const filter = OrFilter([]);
        final result = systemUnderTest.visitOr(filter);
        expect(result, equals(query));
        verifyNever(() => query.or(any()));
      });

      test('should not call or() for single filter', () {
        const filter = OrFilter([
          EqualsFilter(key: 'status', value: 'active'),
        ]);

        systemUnderTest.visitOr(filter);

        verify(() => query.eq('status', 'active')).called(1);
        verifyNever(() => query.or(any()));
      });
    });
  });
}
