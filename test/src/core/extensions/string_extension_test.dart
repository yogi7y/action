import 'package:action/src/core/extensions/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtension.withNarrowNoBreakSpace', () {
    const narrowNoBreakSpace = '\u202F';

    test('adds narrow no-break space before AM/PM in simple time strings', () {
      expect('9:00 AM'.withNarrowNoBreakSpace, '9:00${narrowNoBreakSpace}AM');
      expect('9:00 PM'.withNarrowNoBreakSpace, '9:00${narrowNoBreakSpace}PM');
      expect('9:00 am'.withNarrowNoBreakSpace, '9:00${narrowNoBreakSpace}am');
      expect('9:00 pm'.withNarrowNoBreakSpace, '9:00${narrowNoBreakSpace}pm');
    });

    test('adds narrow no-break space before AM/PM in sentences', () {
      expect('Today, 9:00 AM'.withNarrowNoBreakSpace, 'Today, 9:00${narrowNoBreakSpace}AM');
      expect('Meeting at 11:30 PM tomorrow'.withNarrowNoBreakSpace,
          'Meeting at 11:30${narrowNoBreakSpace}PM tomorrow');
    });

    test('handles multiple AM/PM occurrences in a string', () {
      expect('From 9:00 AM to 5:00 PM'.withNarrowNoBreakSpace,
          'From 9:00${narrowNoBreakSpace}AM to 5:00${narrowNoBreakSpace}PM');
    });

    test('leaves strings without AM/PM unchanged', () {
      const testStrings = [
        'Hello World',
        '9:00',
        'Sample text',
        'A meeting',
        'The PM spoke today', // "PM" not referring to time
      ];

      for (final str in testStrings) {
        expect(str.withNarrowNoBreakSpace, str);
      }
    });
  });
}
