import 'package:call_center/src/core/abstraction/DateBase.dart';

class Date extends DateBase {
  Date(
      {int month,
      int year,
      int day,
      int hour = 0,
      int seconds = 0,
      int minutes = 0})
      : super(
            month: month,
            year: year,
            day: day,
            hour: hour,
            seconds: seconds,
            minutes: minutes) {
    if (!isValid()) throw DateException("Invalid date foramt");
  }

  @override
  bool isValid([bool throwException = false]) {
    if (day < 1 || day > 31) return false;
    if (hour < 0 || hour > 24) return false;
    if (seconds < 0 || seconds > 59) return false;
    if (minutes < 0 || minutes > 59) return false;
    if (month < 0 || month > 12) return false;

    if (throwException) throw DateException("Invalid date foramt");
    return true;
  }

  @override
  String toString() => "$day/$month/$year $hour:$minutes";

  /// Get the actual date.
  static Date now() {
    DateTime now = DateTime.now();

    return Date(
        year: now.year,
        day: now.day,
        month: now.month,
        hour: now.hour,
        minutes: now.minute);
  }

  /// Convert Date from Map
  static Date fromMap(Map<String, dynamic> map) => Date(
        month: map['month'] as int,
        year: map['year'] as int,
        day: map['day'] as int,
        hour: map['hour'] as int,
        seconds: map['seconds'] as int,
      );

  /// Convert Date to Map
  Map<String, dynamic> toMap() => {
        'month': month,
        'year': year,
        'day': day,
        'hour': hour,
        'seconds': seconds,
      };
}

///  Class to throw exceptions from Date
class DateException implements Exception {
  String message;
  DateException(this.message);
}
