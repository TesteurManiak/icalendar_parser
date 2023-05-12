import 'package:meta/meta.dart';

/// This value type is used to identify properties that contain a calendar user
/// address.
///
/// Example: `mailto:jane_doe@example.com`
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-3-3-calendar-user-address.html
@immutable
base class CalendarUserAddress {
  const CalendarUserAddress(this.value);

  factory CalendarUserAddress.parse(String value) {
    return CalendarUserAddress(Uri.parse(value));
  }

  final Uri value;

  static CalendarUserAddress? tryParse(String? value) {
    if (value == null) return null;

    try {
      final parsedValue = CalendarUserAddress.parse(value);
      return parsedValue;
    } on FormatException {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarUserAddress && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return value.toString();
  }
}
