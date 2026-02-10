import 'package:intl/intl.dart';

class DateTimeHelper {
  DateTimeHelper._();

  static DateTime? parseToLocal(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value.isUtc ? value.toLocal() : value;
    }

    final parsed = DateTime.tryParse(value.toString());
    if (parsed == null) return null;
    return parsed.toLocal();
  }

  static String formatLocal(
    dynamic value,
    String pattern, {
    String fallback = '-',
  }) {
    final localDateTime = parseToLocal(value);
    if (localDateTime == null) return fallback;
    return DateFormat(pattern).format(localDateTime);
  }

  static String formatLocalDate(dynamic value, {String fallback = '-'}) {
    return formatLocal(value, 'yyyy-MM-dd', fallback: fallback);
  }

  static String formatLocalDateTime(dynamic value, {String fallback = '-'}) {
    return formatLocal(value, 'yyyy-MM-dd HH:mm', fallback: fallback);
  }
}
