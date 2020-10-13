import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';

/// Calendaring and Scheduling core object, a collection of calendar and
/// scheduling information.
class ICalendar {
  final String version;
  final String prodid;
  final List<CalendarProperty> calendarProperties;
  final List<CalendarComponent> calendarComponents;

  ICalendar({
    this.version,
    this.prodid,
    this.calendarProperties = const [],
    this.calendarComponents = const [],
  });

  /// Parse an [ICalendar] object from a [String]. The line from the parameter
  /// must be separated with a `\n`.
  ///
  /// The first line must be `BEGIN:CALENDAR`, and the last line must be
  /// `END:CALENDAR`.
  ///
  /// The body MUST include the "PRODID" and "VERSION" calendar properties.
  factory ICalendar.parseFromString(String icString,
      {bool allowEmptyLine = true}) {
    String prodid;
    String version;

    if (!icString.startsWith('BEGIN:VCALENDAR'))
      throw ICalendarBeginException('The first line must be BEGIN:VCALENDAR');
    else if (!icString.endsWith('END:VCALENDAR'))
      throw ICalendarEndException('The last line must be END:VCALENDAR');

    // check for "PRODID" and "VERSION"
    final dataList = icString.split('\n');
    for (final e in dataList) {
      if (e.isEmpty && !allowEmptyLine)
        throw EmptyLineException('Empty line are not allowed');
      if (prodid == null && e.contains('PRODID') && e.contains(':')) {
        final parsed = e.split(':');
        prodid = parsed.sublist(1).join(':');
      } else if (version == null && e.contains('VERSION') && e.contains(':')) {
        final parsed = e.split(':');
        version = parsed.sublist(1).join(':');
      }
    }

    if (version == null)
      throw ICalendarNoVersionException(
          'The body is missing the property VERSION');
    if (prodid == null)
      throw ICalendarNoProdidException(
          'The body is missing the property PRODID');

    return ICalendar(
      version: version,
      prodid: prodid,
    );
  }
}

abstract class CalendarProperty {}

abstract class CalendarComponent {}
