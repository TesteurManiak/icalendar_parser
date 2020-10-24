/// Exception thrown when there is a formatting error while parsing the
/// [ICalendar] object.
class ICalendarFormatException implements Exception {
  final String msg;

  const ICalendarFormatException(this.msg);

  @override
  String toString() => 'ICalendarFormatException: $msg';
}

/// Exception thrown when there is an issue with the `BEGIN:VCALENDAR`.
class ICalendarBeginException extends ICalendarFormatException {
  const ICalendarBeginException(String msg) : super(msg);
}

/// Exception thrown when there is an issue with the `END:VCALENDAR`.
class ICalendarEndException extends ICalendarFormatException {
  const ICalendarEndException(String msg) : super(msg);
}

/// Exception thrown when there is an empty line.
class EmptyLineException extends ICalendarFormatException {
  const EmptyLineException(String msg) : super(msg);
}

/// Exception thrown when `VERSION` is missing.
class ICalendarNoVersionException extends ICalendarFormatException {
  const ICalendarNoVersionException(String msg) : super(msg);
}

/// Exception thrown when `PRODID` is missing.
class ICalendarNoProdidException extends ICalendarFormatException {
  const ICalendarNoProdidException(String msg) : super(msg);
}
