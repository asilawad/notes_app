import 'package:intl/intl.dart';

import '../constants/app_strings.dart';

/// Date and time formatting helpers for the Notes App.
///
/// Absolute formats use `intl` skeletons (not hand-written patterns), so
/// they follow the active locale automatically.
abstract final class DateFormatter {
  static final DateFormat _dateFormat = DateFormat.yMMMd();
  static final DateFormat _dateTimeFormat = DateFormat.yMMMd().add_jm();

  /// Older dates are shown as an absolute date instead of "N days ago".
  static const int _relativeDaysLimit = 7;

  /// Absolute date, for example "Sep 30, 2026".
  static String date(DateTime value) => _dateFormat.format(value);

  /// Absolute date and time, for example "Sep 30, 2026 4:15 PM".
  static String dateTime(DateTime value) => _dateTimeFormat.format(value);

  /// Friendly relative time for note tiles: "Just now", "5 min ago",
  /// "3 hours ago", "Yesterday", "3 days ago", then an absolute date.
  ///
  /// [now] can be injected to make the result deterministic in tests.
  static String relative(DateTime value, {DateTime? now}) {
    final DateTime current = now ?? DateTime.now();
    final Duration elapsed = current.difference(value);

    // A negative difference happens briefly when the local clock is behind
    // the server timestamp, so it is treated as "just now".
    if (elapsed.isNegative || elapsed.inMinutes < 1) {
      return AppStrings.justNow;
    }
    if (elapsed.inHours < 1) {
      return AppStrings.minutesAgo(elapsed.inMinutes);
    }

    final int calendarDays = _calendarDaysBetween(value, current);
    if (calendarDays == 0) return AppStrings.hoursAgo(elapsed.inHours);
    if (calendarDays == 1) return AppStrings.yesterday;
    if (calendarDays < _relativeDaysLimit) {
      return AppStrings.daysAgo(calendarDays);
    }
    return date(value);
  }

  /// Number of calendar days between two moments, ignoring the time of day
  /// (and immune to daylight saving shifts).
  static int _calendarDaysBetween(DateTime from, DateTime to) {
    final DateTime fromDay = DateTime.utc(from.year, from.month, from.day);
    final DateTime toDay = DateTime.utc(to.year, to.month, to.day);
    return toDay.difference(fromDay).inDays;
  }
}
