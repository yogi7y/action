extension NarrowNoBreakSpaceExtension on String {
  /// Adds a narrow no-break space (\u202F) before AM/PM in time strings
  /// For example:
  /// - "9:00 AM" becomes "9:00\u202FAM"
  /// - "Today, 9:00 PM" becomes "Today, 9:00\u202FPM"
  /// - "The PM spoke today" remains unchanged
  String get withNarrowNoBreakSpace {
    const narrowNoBreakSpace = '\u202F';

    // Match time patterns with AM/PM
    // Looks for:
    // - Numbers (with optional leading zero)
    // - Followed by colon and numbers
    // - Followed by space and AM/PM
    final timeRegex = RegExp(r'(\d{1,2}:\d{2})\s(AM|PM|am|pm)');

    return replaceAllMapped(
        timeRegex, (match) => '${match.group(1)}$narrowNoBreakSpace${match.group(2)}');
  }
}
