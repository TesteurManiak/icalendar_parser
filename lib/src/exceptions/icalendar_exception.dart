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
  const ICalendarBeginException(super.msg);
}

/// Exception thrown when there is an issue with the `END:VCALENDAR`.
class ICalendarEndException extends ICalendarFormatException {
  const ICalendarEndException(super.msg);
}

/// Exception thrown when there is an empty line.
class EmptyLineException extends ICalendarFormatException {
  const EmptyLineException() : super('Empty line are not allowed');
}

/// Exception thrown when `VERSION` is missing.
class ICalendarNoVersionException extends ICalendarFormatException {
  const ICalendarNoVersionException(super.msg);
}

/// Exception thrown when `PRODID` is missing.
class ICalendarNoProdidException extends ICalendarFormatException {
  const ICalendarNoProdidException(super.msg);
}

/// Exception thrown when parsed [IcsStatus] is unknown.
class ICalendarStatusParseException extends ICalendarFormatException {
  const ICalendarStatusParseException(super.msg);
}

/// Exception thrown when parsed [IcsTransp] is unknown.
class ICalendarTranspParseException extends ICalendarFormatException {
  const ICalendarTranspParseException(super.msg);
}
