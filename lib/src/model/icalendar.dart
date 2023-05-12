import 'dart:convert';

import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/utils/parsing_methods.dart';
import 'package:meta/meta.dart';

typedef ClosureFunction = Map<String, dynamic>? Function(
  String value,
  Map<String, String> params,
  List<Object?> events,
  Map<String, dynamic>? lastEvent,
  List<Map<String, dynamic>>,
);

/// Core object
@immutable
class ICalendar {
  /// Default constructor.
  const ICalendar({
    required this.data,
    required this.headData,
  });

  /// Parse an [ICalendar] object from a [String]. The parameter
  /// [icsString] will be split using [LineSplitter] then calling
  /// `ICalendar.fromLines`.
  ///
  /// The first line must be `BEGIN:VCALENDAR`, and the last line must be
  /// `END:VCALENDAR`.
  ///
  /// The body MUST include the "PRODID" and "VERSION" calendar properties.
  factory ICalendar.fromString(String icsString, {bool allowEmptyLine = true}) {
    final strBuffer = StringBuffer(icsString);
    const lineSplitter = LineSplitter();
    final lines = lineSplitter.convert(strBuffer.toString());
    return ICalendar.fromLines(lines, allowEmptyLine: allowEmptyLine);
  }

  /// Parse an [ICalendar] object from a [List<String>].
  ///
  /// The first line must be `BEGIN:CALENDAR`, and the last line must be
  /// `END:CALENDAR`.
  ///
  /// The body MUST include the "PRODID" and "VERSION" calendar properties.
  factory ICalendar.fromLines(
    List<String> lines, {
    bool allowEmptyLine = true,
  }) {
    if (allowEmptyLine) {
      while (lines.last.isEmpty) {
        lines.removeLast();
      }
    }
    final parsedData = fromListToJson(lines, allowEmptyLine: allowEmptyLine);
    return ICalendar(
      headData: parsedData.first as Map<String, dynamic>,
      data: parsedData.last as List<Map<String, dynamic>>,
    );
  }

  /// iCalendar's components list.
  final List<Map<String, dynamic>> data;

  /// iCalendar's fields.
  final Map<String, dynamic> headData;

  /// `VERSION` of the object.
  String get version => headData['version'] as String;

  /// `PRODID` of the object.
  String get prodid => headData['prodid'] as String;

  /// `CALSCALE` of the object.
  String? get calscale => headData['calscale'] as String?;

  /// `METHOD` of the object.
  String? get method => headData['method'] as String?;

  /// Map containing the methods used to parse each kind of fields in the file.
  static final _objects = <String, Function>{
    'BEGIN': (
      String value,
      Map<String, String> params,
      List<Object?> events,
      Map<String, dynamic> lastEvent,
    ) {
      if (value == 'VCALENDAR') return null;

      lastEvent = {'type': value};
      events.add(lastEvent);

      return lastEvent;
    },
    'END': parseEndField,
    'DTSTART': generateDateFunction('dtstart'),
    'DTEND': generateDateFunction('dtend'),
    'DTSTAMP': generateDateFunction('dtstamp'),
    'TRIGGER': generateSimpleParamFunction('trigger'),
    'LAST-MODIFIED': generateDateFunction('lastModified'),
    'COMPLETED': generateDateFunction('completed'),
    'DUE': generateDateFunction('due'),
    'UID': generateSimpleParamFunction('uid'),
    'SUMMARY': generateSimpleParamFunction('summary'),
    'DESCRIPTION': generateSimpleParamFunction('description'),
    'LOCATION': generateSimpleParamFunction('location'),
    'URL': generateSimpleParamFunction('url'),
    'ORGANIZER': parseOrganizerField,
    'GEO': (
      String value,
      Map<String, String> params,
      List<Object?> events,
      Map<String, dynamic> lastEvent,
    ) {
      final pos = value.split(';');
      if (pos.length != 2) return lastEvent;

      final geo = <String, dynamic>{};
      geo['latitude'] = num.parse(pos[0]);
      geo['longitude'] = num.parse(pos[1]);
      lastEvent['geo'] = geo;
      return lastEvent;
    },
    'CATEGORIES': (
      String value,
      Map<String, String> params,
      List<Object?> events,
      Map<String, dynamic> lastEvent,
    ) {
      lastEvent['categories'] = value.split(',');
      return lastEvent;
    },
    'ATTENDEE': (
      String value,
      Map<String, String> params,
      _,
      Map<String, dynamic> lastEvent,
    ) {
      lastEvent['attendee'] ??= <Map<String, String>>[];

      final mail = value.replaceAll('MAILTO:', '').trim();
      final cn = params['CN'];

      final elem = <String, String>{
        if (cn != null) 'name': cn.trim(),
        for (final entry in params.entries)
          if (entry.key != 'CN') entry.key.toLowerCase(): entry.value.trim(),
        'mail': mail,
      };

      final attendee = lastEvent['attendee'];
      if (attendee is List) {
        attendee.add(elem);
      }

      return lastEvent;
    },
    'ACTION': generateSimpleParamFunction('action'),
    'STATUS': (String value, _, __, Map<String, dynamic> lastEvent) {
      lastEvent['status'] = value.trim().toIcsStatus();
      return lastEvent;
    },
    'SEQUENCE': generateSimpleParamFunction('sequence'),
    'REPEAT': generateSimpleParamFunction('repeat'),
    'CLASS': generateSimpleParamFunction('class'),
    'TRANSP': (String value, _, __, Map<String, dynamic> lastEvent) {
      lastEvent['transp'] = value.trim().toIcsTransp();
      return lastEvent;
    },
    'VERSION': generateSimpleParamFunction('version'),
    'PRODID': generateSimpleParamFunction('prodid'),
    'CALSCALE': generateSimpleParamFunction('calscale'),
    'METHOD': generateSimpleParamFunction('method'),
    'RRULE': generateSimpleParamFunction('rrule'),
    'EXDATE': (
      String value,
      Map<String, String> params,
      List<Object?> events,
      Map<String, dynamic> lastEvent,
    ) {
      final dates = value
          .split(',')
          .map((e) => IcsDateTime(dt: e, tzid: params['TZID']))
          .toList();

      final exdate = lastEvent['exdate'];
      if (exdate != null && exdate is List<IcsDateTime>) {
        exdate.addAll(dates);
      } else {
        lastEvent['exdate'] = dates;
      }

      return lastEvent;
    },
    'CREATED': generateDateFunction('created'),
  };

  /// Managed parsing methods.
  static Map<String, Function> get objects => _objects;

  /// Allow to add custom field to parse.
  ///
  /// If no `function` parameter to parse the field is provided the default
  /// method `generateSimpleParamFunction` will be used.
  ///
  /// If a field with the same name already exists the method will throw a
  /// `ICalendarFormatException`.
  static void registerField({
    required String field,
    SimpleParamFunction? function,
  }) {
    if (_objects.containsKey(field)) {
      throw ICalendarFormatException('The field $field is already registered.');
    }

    _objects[field] =
        function ?? generateSimpleParamFunction(field.toLowerCase());
  }

  /// Remove an existing parsing field.
  ///
  /// If there is no corresponding field the method will throw a
  /// `ICalendarFormatException`.
  static void unregisterField(String field) {
    if (!_objects.containsKey(field)) {
      throw ICalendarFormatException('The field $field does not exists.');
    }
    _objects.remove(field);
  }

  /// Parse a list of icalendar object from a [List<String>].
  ///
  /// It will return a list containing at `first` the
  /// `Map<String, dynamic> headData` and at `last` the
  /// `List<Map<String, dynamic>> data`.
  ///
  /// If [allowEmptyLine] is false the method will throw [EmptyLineException].
  static List<dynamic> fromListToJson(
    List<String> lines, {
    bool allowEmptyLine = true,
  }) {
    final data = <Map<String, dynamic>>[];
    final headData = <String, dynamic>{};
    final events = <Object?>[];
    Map<String, dynamic>? lastEvent = {};
    String? currentName;

    // Ensure first line is BEGIN:VCALENDAR
    if (lines.first.trim() != 'BEGIN:VCALENDAR') {
      throw ICalendarBeginException(
        'The first line must be BEGIN:VCALENDAR but was ${lines.first}.',
      );
    }

    // Ensure last line is END:VCALENDAR
    if (lines.last.trim() != 'END:VCALENDAR') {
      throw ICalendarEndException(
        'The last line must be END:VCALENDAR but was ${lines.last}.',
      );
    }

    for (var i = 0; i < lines.length; i++) {
      final line = StringBuffer(lines[i].trim());

      if (line.isEmpty && !allowEmptyLine) {
        throw const EmptyLineException();
      }

      final exp = RegExp('^ ');
      while (i + 1 < lines.length && exp.hasMatch(lines[i + 1])) {
        i += 1;
        line.write(lines[i].trim());
      }

      final dataLine = line.toString().split(':');
      if ((dataLine.length < 2 && !dataLine[0].contains(';')) ||
          (dataLine.isNotEmpty &&
              dataLine[0].toUpperCase() != dataLine[0] &&
              !dataLine[0].contains(';'))) {
        if (lastEvent != null && line.isNotEmpty && currentName != null) {
          final buffer = StringBuffer(lastEvent[currentName] as String)
            ..write(line.toString());
          lastEvent[currentName] = buffer.toString();
        }
        continue;
      }

      final dataName = dataLine[0].split(';');
      final name = dataName[0];
      dataName.removeRange(0, 1);

      final params = <String, String>{};
      for (final e in dataName) {
        final param = e.split('=');
        if (param.length == 2) params[param[0]] = param[1];
      }

      dataLine.removeRange(0, 1);
      final value = dataLine.join(':').replaceAll(RegExp(r'\\,'), ',');
      final nameFunc = _objects[name];
      if (_objects.containsKey(name) && nameFunc != null) {
        currentName = name.toLowerCase();
        if (name == 'END') {
          final func = nameFunc as ClosureFunction;
          currentName = null;
          lastEvent = func(value, params, events, lastEvent, data);
        } else {
          final func = nameFunc as SimpleParamFunction;
          lastEvent = func(value, params, events, lastEvent ?? headData);
        }
      }
    }
    if (!headData.containsKey('version')) {
      throw const ICalendarNoVersionException(
        'The body is missing the property VERSION',
      );
    } else if (!headData.containsKey('prodid')) {
      throw const ICalendarNoProdidException(
        'The body is missing the property PRODID',
      );
    }
    return [headData, data];
  }

  /// Convert [ICalendar] object to a `Map<String, dynamic>` containing all its
  /// data, formatted into a valid JSON `Map<String, dynamic>`.
  /// ```json
  /// {
  ///   "version": "2.0",
  ///   "prodid": "-//hacksw/handcal//NONSGML v1.0//EN",
  ///   "data": []
  /// }
  /// ```
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'version': version,
      'prodid': prodid,
      for (final entry in headData.entries) entry.key: entry.value,
      'data': data,
    };
    return jsonDecode(jsonEncode(map, toEncodable: jsonEncodable))
        as Map<String, dynamic>;
  }

  static Object? jsonEncodable(Object? item) {
    if (item is IcsDateTime) {
      return item.toJson();
    } else if (item is IcsTransp) {
      return item.key;
    } else if (item is IcsStatus) {
      return item.key;
    }
    return item;
  }

  @override
  String toString() => jsonEncode(toJson());
}

extension IcsStringModifier on String {
  IcsStatus toIcsStatus() => IcsStatus.fromString(this);
  IcsTransp toIcsTransp() => IcsTransp.fromString(this);
}
