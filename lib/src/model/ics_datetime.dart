/// This value type is used to identify values that specify a precise calendar
/// date and time of day.
///
/// See doc: https://www.kanzaki.com/docs/ical/dateTime.html
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
}
