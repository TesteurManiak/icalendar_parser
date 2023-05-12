import 'package:icalendar_parser/src/utils/extensions.dart';
import 'package:meta/meta.dart';

/// This value type is used to identify values that specify a precise calendar
/// date and time of day.
///
/// To have access to as fully-parsed date and time you can use the package
/// [timezone](https://pub.dev/packages/timezone) which gives you access to a
/// [TimeZone aware DateTime](https://pub.dev/packages/timezone#timezone-aware-datetime)
/// object.
///
/// ```dart
/// import 'package:timezone/standalone.dart' as tz;
///
/// final icsDt = IcsDateTime(/* ... */);
/// final date = tz.TZDateTime.parse(tz.getLocation(icsDt.tzid), icsDt.dt);
/// ```
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-3-5-date-time.html
@immutable
class IcalDateTime {
  const IcalDateTime({
    this.tzid,
    required this.dt,
  });

  factory IcalDateTime.parse(String value) {
    final regex = RegExp(
      r'^(?:TZID=(?<tzid>[^:]+):)?(?<dt>\d{8}T\d{6}(?:Z|[-+]\d{4})?)$',
    );

    final match = regex.firstMatch(value);

    if (match == null) {
      throw FormatException('Invalid date time format: $value');
    }

    final tzid = match.namedGroup('tzid');
    final dt = match.namedGroup('dt');

    if (dt == null || DateTime.tryParse(dt) == null) {
      throw FormatException('Invalid date time format: $value');
    }

    return IcalDateTime(
      tzid: tzid,
      dt: dt,
    );
  }

  /// This property specifies the text value that uniquely identifies the
  /// "VTIMEZONE" calendar component.
  ///
  /// See doc: https://www.kanzaki.com/docs/ical/tzid.html
  final String? tzid;

  /// Datetime value parsed from the ics file.
  final String dt;

  static IcalDateTime? tryParse(String? value) {
    if (value == null) {
      return null;
    }

    try {
      return IcalDateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  /// Use [DateTime.parse] to parse the `dt` property.
  ///
  /// **Warning:** This method does not use the `tzid` as [DateTime] does not
  /// support timezones.
  DateTime toDateTime() => DateTime.parse(dt);

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'tzid': tzid,
    }.toValidMap();
  }

  /// Compare this object with another [IcalDateTime] object.
  @override
  bool operator ==(Object other) {
    return other is IcalDateTime && (other.dt == dt && other.tzid == tzid);
  }

  @override
  int get hashCode => Object.hash(dt, tzid);

  @override
  String toString() {
    final buffer = StringBuffer();

    if (tzid != null) {
      buffer.write('TZID=$tzid:');
    }
    buffer.write(dt);

    return buffer.toString();
  }

  bool isBefore(IcalDateTime other) {
    final otherDt = other.toDateTime();
    final thisDt = toDateTime();

    return thisDt.isBefore(otherDt);
  }

  bool isAfter(IcalDateTime other) {
    final otherDt = other.toDateTime();
    final thisDt = toDateTime();

    return thisDt.isAfter(otherDt);
  }
}
