// date_time_extension.dart
import 'package:intl/intl.dart';

import 'string_extension.dart';

extension DateTimeExtension on DateTime {
  String get relativeDate {
    final baseDate = DateTime(2024, 12, 23); // A Monday

    // Create dates without time for comparison
    final todayStart = DateTime(baseDate.year, baseDate.month, baseDate.day);
    final dateStart = DateTime(year, month, day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    String getFormattedTime() {
      return DateFormat.jm('en_US').format(this).withNarrowNoBreakSpace;
    }

    // Today
    if (dateStart == todayStart) {
      return 'Today, ${getFormattedTime()}';
    }

    // Tomorrow
    if (dateStart == tomorrowStart) {
      return 'Tomorrow, ${getFormattedTime()}';
    }

    // Within next 6 days
    final difference = dateStart.difference(todayStart).inDays;
    if (difference > 0 && difference < 6) {
      return '${DateFormat.EEEE().format(this)}, ${getFormattedTime()}';
    }

    // Beyond 6 days
    return '${DateFormat('MMM d').format(this)}, ${getFormattedTime()}';
  }
}
