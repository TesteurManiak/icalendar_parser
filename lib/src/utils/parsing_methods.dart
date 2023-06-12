import 'package:icalendar_parser/icalendar_parser.dart';

typedef SimpleParamFunction = Map<String, dynamic>? Function(
  String value,
  Map<String, String> params,
  List<Object?> events,
  Map<String, dynamic> lastEvent,
);

SimpleParamFunction parseDateFunction(String name) {
  return (
    String value,
    Map<String, String> params,
    List<Object?> events,
    Map<String, dynamic> lastEvent,
  ) {
    lastEvent[name] = IcalDateTime(dt: value, tzid: params['TZID']);
    return lastEvent;
  };
}

SimpleParamFunction parseTriggerFunction() {
  return (
    String value,
    Map<String, String> params,
    List<Object?> _,
    Map<String, dynamic> lastEvent,
  ) {
    lastEvent['trigger'] = IcalDuration.parse(value);
    return lastEvent;
  };
}

/// Generate a method that return the [lastEvent] with a new entry at [name]
/// containing the [value] as [String].
SimpleParamFunction generateSimpleParamFunction(String name) {
  return (
    String value,
    Map<String, String> params,
    List<Object?> events,
    Map<String, dynamic> lastEvent,
  ) {
    lastEvent[name] = value.replaceAll(RegExp(r'/\\n/g'), '\n');
    return lastEvent;
  };
}

Map<String, dynamic>? parseEndField(
  String value,
  Map<String, String> params,
  List<Object?> events,
  Map<String, dynamic>? lastEvent,
  List<Map<String, dynamic>?> data,
) {
  if (value == 'VCALENDAR') return lastEvent;

  data.add(lastEvent);

  final index = events.indexOf(lastEvent);
  if (index != -1) events.removeAt(index);

  final localLastEvent = events.lastOrNull;
  if (localLastEvent is! Map<String, dynamic>?) return null;

  return localLastEvent;
}

Map<String, dynamic> parseOrganizerField(
  String value,
  Map<String, String> params,
  List<Object?> events,
  Map<String, dynamic> lastEvent,
) {
  final organizer = ICalOrganizer(
    cn: params['CN'],
    value: Uri.tryParse(value),
  );
  lastEvent['organizer'] = organizer;
  return lastEvent;
}
