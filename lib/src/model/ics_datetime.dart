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
class IcsDateTime {
  /// This property specifies the text value that uniquely identifies the
  /// "VTIMEZONE" calendar component.
  ///
  /// See doc: https://www.kanzaki.com/docs/ical/tzid.html
  final String? tzid;

  /// Datetime value parsed from the ics file.
  final String dt;

  IcsDateTime({this.tzid, required this.dt});

  /// Use [DateTime.tryParse] to parse the `dt` property.
  ///
  /// **Warning:** This method does not use the `tzid` as [DateTime] does not
  /// support timezones.
  DateTime? toDateTime() => DateTime.tryParse(dt);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'dt': dt};
    if (tzid != null) json['tzid'] = tzid;
    return json;
  }

  /// Compare this object with another [IcsDateTime] object.
  @override
  bool operator ==(Object other) =>
      other is IcsDateTime && (other.dt == dt && other.tzid == tzid);

  @override
  int get hashCode => Object.hash(dt, tzid);

  @override
  String toString() {
    return 'IcsDateTime{tzid: $tzid, dt: $dt}';
  }
}
