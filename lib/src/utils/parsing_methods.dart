import 'package:icalendar_parser/src/model/ics_datetime.dart';

typedef SimpleParamFunction = Map<String, dynamic>? Function(
  String value,
  Map<String, String> params,
  List<Object?> events,
  Map<String, dynamic> lastEvent,
);

SimpleParamFunction generateDateFunction(String name) {
  return (
    String value,
    Map<String, String> params,
    List<Object?> events,
    Map<String, dynamic> lastEvent,
  ) {
    lastEvent[name] = IcsDateTime(dt: value, tzid: params['TZID']);
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
  final mail = value.replaceAll('MAILTO:', '').trim();

  if (params.containsKey('CN')) {
    lastEvent['organizer'] = {
      'name': params['CN'],
      'mail': mail,
    };
  } else {
    lastEvent['organizer'] = {'mail': mail};
  }

  return lastEvent;
}
