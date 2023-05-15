part of 'ical_component.dart';

/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-6-2-to-do-component.html
class VTodo extends ICalComponent {
  VTodo() : super('VTODO');

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
    }.toValidMap();
  }
}
