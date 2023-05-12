/// This value type is used to identify properties that contain a calendar user
/// address.
///
/// Example: `mailto:jane_doe@example.com`
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-3-3-calendar-user-address.html

abstract class CalendarUserAddress {
  const CalendarUserAddress(this.value);

  final Uri value;

  Map<String, dynamic> toJson();
}
