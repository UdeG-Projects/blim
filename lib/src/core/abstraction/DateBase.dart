abstract class DateBase {
  int month;
  int year;
  int day;
  int hour;
  int seconds;
  int minutes;

  DateBase(
      {this.month,
      this.year,
      this.day,
      this.hour = 0,
      this.seconds = 0,
      this.minutes = 0});

  /// Convert to readable text.
  String toString();

  /// Check if values for the date are valid.
  bool isValid([bool throwException]);
}

class DateException {
  String message;
  DateException(this.message);
}
