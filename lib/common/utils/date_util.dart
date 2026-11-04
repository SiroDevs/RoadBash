// Package imports:
import 'package:intl/intl.dart';

/// Formats a date with a pattern, falling back if the locale is missing.
String formatDate(String pattern, String locale, DateTime time) {
  try {
    return DateFormat(pattern, locale).format(time);
  } catch (_) {
    return DateFormat(pattern).format(time);
  }
}
