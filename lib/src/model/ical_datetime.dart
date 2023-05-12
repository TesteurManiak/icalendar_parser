import 'package:icalendar_parser/src/utils/extensions.dart';
import 'package:meta/meta.dart';

/// This value type is used to identify values that specify a precise calendar
/// date and time of day.
///
/// See doc: https://www.kanzaki.com/docs/ical/dateTime.html
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
      throw ArgumentError.value(value, 'value', 'Invalid date time');
    }

    final tzid = match.namedGroup('tzid');
    final dt = match.namedGroup('dt');

    if (dt == null) {
      throw ArgumentError.value(value, 'value', 'Invalid date time');
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

  /// Use [DateTime.tryParse] to parse the `dt` property.
  ///
  /// **Warning:** This method does not use the `tzid` as [DateTime] does not
  /// support timezones.
  DateTime? toDateTime() => DateTime.tryParse(dt);

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

  bool isBefore(IcalDateTime other) {
    final otherDt = other.toDateTime() ?? DateTime(0);
    final thisDt = toDateTime() ?? DateTime(0);

    return thisDt.isBefore(otherDt);
  }

  bool isAfter(IcalDateTime other) {
    final otherDt = other.toDateTime() ?? DateTime(0);
    final thisDt = toDateTime() ?? DateTime(0);

    return thisDt.isAfter(otherDt);
  }
}
