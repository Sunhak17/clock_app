import '../models/timezone_model.dart';

/// Timezone conversion utilities
class TimezoneConverter {
  /// Parse UTC offset string to hours and minutes
  /// Example: "UTC+05:30" returns (5, 30)
  /// Example: "UTC-03:00" returns (-3, 0)
  static (int hours, int minutes) parseUtcOffset(String offset) {
    final sign = offset.contains('-') ? -1 : 1;
    final parts = offset
        .replaceAll('UTC', '')
        .replaceAll('+', '')
        .replaceAll('-', '')
        .split(':');
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    return (sign * hours, sign * minutes);
  }

  /// Convert DateTime to specific timezone
  /// Takes current time and converts it to the selected timezone
  static DateTime convertToTimezone(DateTime currentTime, TimezoneData timezone) {
    final (hours, minutes) = parseUtcOffset(timezone.offset);
    final offset = Duration(hours: hours, minutes: minutes);

    // Get UTC time and add the timezone offset
    final utcTime = currentTime.toUtc();
    final timezoneTime = utcTime.add(offset);

    return timezoneTime;
  }
}
