class MDuration {
  int hours;
  int minutes;
  MDuration({this.hours, this.minutes});

  @override
  String toString() => "$hours:$minutes";

  static MDuration fromString(String durationStr) => MDuration(
      hours: durationStr.split(":")[0] as int,
      minutes: durationStr.split(":")[1] as int);

  Map<String, dynamic> toMap() => {
        "hours": hours,
        "minutes": minutes,
      };

  static MDuration fromMap(Map<String, dynamic> map) => MDuration(
        hours: map["hours"],
        minutes: map["minutes"],
      );

  bool _isValid({bool throwException = false}) {
    if (hours < 0 || hours > 23) return false;
    if (minutes < 0 || minutes > 59) return false;

    if (throwException) throw MDurationException("Invalid duration foramt");
    return true;
  }
}

class MDurationException implements Exception {
  String message;

  MDurationException(this.message);

  @override
  String toString() => message;
}
