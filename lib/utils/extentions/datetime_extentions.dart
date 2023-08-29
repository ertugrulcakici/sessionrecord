extension DateTimeHelper on DateTime {
  String toHourMinuteString() {
    String _hour = hour.toString();
    if (_hour.length == 1) {
      _hour = "0" + _hour;
    }
    String _minute = minute.toString();
    if (_minute.length == 1) {
      _minute = "0" + _minute;
    }
    return _hour + ":" + _minute;
  }

  String toDayMonthYearString() {
    String _day = day.toString();
    String _month = month.toString();
    return _day + "." + _month + "." + year.toString();
  }

  DateTime onlyDate() {
    return DateTime(year, month, day);
  }
}
