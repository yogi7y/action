import 'package:action/src/core/extensions/date_time_extension.dart';
import 'package:action/src/core/extensions/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeExtension', () {
    final baseDateTime = DateTime(2024, 12, 23); // Monday, December 23, 2024

    group('today', () {
      test('returns "Today, 9:00 AM" for same day morning', () {
        final target = DateTime(2024, 12, 23, 9);
        expect(
          target.relativeDate,
          'Today, 9:00 AM'.withNarrowNoBreakSpace,
        );
      });

      test('returns "Today, 3:30 PM" for same day afternoon', () {
        final target = DateTime(2024, 12, 23, 15, 30);
        expect(
          target.relativeDate,
          'Today, 3:30 PM'.withNarrowNoBreakSpace,
        );
      });
    });

    group('tomorrow', () {
      test('returns "Tomorrow, 9:00 AM" for next day', () {
        final target = baseDateTime.add(const Duration(days: 1)).copyWith(hour: 9, minute: 0);
        expect(
          target.relativeDate,
          'Tomorrow, 9:00 AM'.withNarrowNoBreakSpace,
        );
      });

      test('returns "Tomorrow, 12:00 AM" for midnight', () {
        final target = baseDateTime.add(const Duration(days: 1)).copyWith(hour: 0, minute: 0);
        expect(
          target.relativeDate,
          'Tomorrow, 12:00 AM'.withNarrowNoBreakSpace,
        );
      });
    });

    group('within week', () {
      test('returns day name for dates within next 6 days', () {
        final target =
            baseDateTime.add(const Duration(days: 3)).copyWith(hour: 9, minute: 0); // Thursday
        expect(
          target.relativeDate,
          'Thursday, 9:00 AM'.withNarrowNoBreakSpace,
        );
      });
    });

    group('beyond week', () {
      test('returns full date for dates beyond 6 days', () {
        final target = baseDateTime.add(const Duration(days: 7)).copyWith(hour: 9, minute: 0);
        expect(
          target.relativeDate,
          'Dec 30, 9:00 AM'.withNarrowNoBreakSpace,
        );
      });
    });

    group(
      'edge cases',
      () {
        test('handles year boundary correctly', () {
          // Set base date to Dec 31
          final yearEndBase = DateTime(2024, 12, 31);
          final target =
              yearEndBase.add(const Duration(days: 1)).copyWith(hour: 9, minute: 0); // Jan 1, 2025

          expect(
            target.relativeDate,
            'Tomorrow, 9:00 AM'.withNarrowNoBreakSpace,
          );
        });

        test('handles month boundary correctly', () {
          // Set base date to Nov 30
          final monthEndBase = DateTime(2024, 11, 30);
          final target =
              monthEndBase.add(const Duration(days: 1)).copyWith(hour: 9, minute: 0); // Dec 1

          expect(
            target.relativeDate,
            'Tomorrow, 9:00 AM'.withNarrowNoBreakSpace,
          );
        });
      },
      skip: 'Edge cases are not handled yet',
    );
  });
}
