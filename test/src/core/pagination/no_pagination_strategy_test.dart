import 'package:action/src/core/pagination/pagination_strategy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NoPaginationStrategy', () {
    test('should fetch all items when limit is 0', () {
      const strategy = NoPaginationStrategy(limit: 0);
      expect(strategy.fetchAll, true);
    });

    test('should not fetch all items when limit is greater than 0', () {
      const strategy = NoPaginationStrategy(limit: 10);
      expect(strategy.fetchAll, false);
    });

    test('should update limit through copyWith', () {
      const initialStrategy = NoPaginationStrategy(limit: 10);
      final updatedStrategy = initialStrategy.copyWith(limit: 20);

      expect(updatedStrategy.limit, 20);
      expect(updatedStrategy.fetchAll, false);
    });

    test('should maintain same limit when copyWith is called without parameters', () {
      const initialStrategy = NoPaginationStrategy(limit: 10);
      final updatedStrategy = initialStrategy.copyWith();

      expect(updatedStrategy.limit, 10);
      expect(updatedStrategy.fetchAll, false);
    });
  });
}
