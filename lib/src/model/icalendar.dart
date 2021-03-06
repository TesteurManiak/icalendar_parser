import 'dart:convert';

import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';
import 'package:icalendar_parser/src/extensions/extensions.dart';
import 'package:icalendar_parser/src/model/ics_datetime.dart';
import 'package:icalendar_parser/src/utils/parsing_methods.dart';

/// Core object
class ICalendar {
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

  /// Default constructor.
  ICalendar({required this.data, required this.headData});

  /// Parse an [ICalendar] object from a [String]. The parameter
  /// [icsString] will be split on each [lineSeparator] occurence which is by
  /// default `\r\n`.
  ///
  /// The first line must be `BEGIN:VCALENDAR`, and the last line must be
  /// `END:VCALENDAR`.
  ///
  /// The body MUST include the "PRODID" and "VERSION" calendar properties.
  factory ICalendar.fromString(String icsString,
      {bool allowEmptyLine = true, String lineSeparator = '\r\n'}) {
    // Clean empty line end of file.
    if (allowEmptyLine) {
      while (icsString.endsWith(lineSeparator)) {
        icsString =
            icsString.substring(0, icsString.length - lineSeparator.length);
      }
    }
    final lines = icsString.split(lineSeparator);
    final parsedData = fromListToJson(lines, allowEmptyLine: allowEmptyLine);
    return ICalendar(
      headData: parsedData.first as Map<String, dynamic>,
      data: parsedData.last as List<Map<String, dynamic>>,
    );
  }

  /// Parse an [ICalendar] object from a [List<String>].
  ///
  /// The first line must be `BEGIN:CALENDAR`, and the last line must be
  /// `END:CALENDAR`.
  ///
  /// The body MUST include the "PRODID" and "VERSION" calendar properties.
  factory ICalendar.fromLines(List<String> lines,
      {bool allowEmptyLine = true}) {
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

  /// Map containing the methods used to parse each kind of fields in the file.
  static final Map<String, Function> _objects = {
    'BEGIN': (String value, Map<String, String> params, List events,
        Map<String, dynamic> lastEvent) {
      if (value == 'VCALENDAR') return null;

      lastEvent = {'type': value};
      events.add(lastEvent);

      return lastEvent;
    },
    'END': (String value, Map<String, String> params, List events,
        Map<String, dynamic>? lastEvent, List<Map<String, dynamic>?> data) {
      if (value == 'VCALENDAR') return lastEvent;

      data.add(lastEvent);

      final index = events.indexOf(lastEvent);
      if (index != -1) events.removeAt(index);

      if (events.isEmpty) {
        lastEvent = null;
      } else {
        lastEvent = events.last as Map<String, dynamic>?;
      }
      return lastEvent;
    },
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
    'ORGANIZER': (String value, Map<String, String> params, List events,
        Map<String, dynamic> lastEvent) {
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
    },
    'GEO': (String value, Map<String, String> params, List events,
        Map<String, dynamic> lastEvent) {
      final pos = value.split(';');
      if (pos.length != 2) return lastEvent;

      lastEvent['geo'] = {};
      lastEvent['geo']['latitude'] = num.parse(pos[0]);
      lastEvent['geo']['longitude'] = num.parse(pos[1]);
      return lastEvent;
    },
    'CATEGORIES': (String value, Map<String, String> params, List events,
        Map<String, dynamic> lastEvent) {
      lastEvent['categories'] = value.split(',');
      return lastEvent;
    },
    'ATTENDEE': (String value, Map<String, String> params, List _,
        Map<String, dynamic> lastEvent) {
      lastEvent['attendee'] ??= [];

      final mail = value.replaceAll('MAILTO:', '').trim();
      final elem = <String, String>{};
      if (params.containsKey('CN')) {
        elem['name'] = params['CN']!.trim();
      }
      params.forEach((key, value) {
        if (key != 'CN') {
          elem[key.toLowerCase()] = value.trim();
        }
      });
      elem['mail'] = mail;
      (lastEvent['attendee'] as List).add(elem);
      return lastEvent;
    },
    'ACTION': generateSimpleParamFunction('action'),
    'STATUS': (String value, Map<String, String> _, List __,
        Map<String, dynamic> lastEvent) {
      lastEvent['status'] = value.trim().toIcsStatus();
      return lastEvent;
    },
    'SEQUENCE': generateSimpleParamFunction('sequence'),
    'REPEAT': generateSimpleParamFunction('repeat'),
    'CLASS': generateSimpleParamFunction('class'),
    'TRANSP': (String value, Map<String, String> _, List __,
        Map<String, dynamic> lastEvent) {
      lastEvent['transp'] = value.trim().toIcsTransp();
      return lastEvent;
    },
    'VERSION': generateSimpleParamFunction('version'),
    'PRODID': generateSimpleParamFunction('prodid'),
    'CALSCALE': generateSimpleParamFunction('calscale'),
    'METHOD': generateSimpleParamFunction('method'),
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
    Function(String value, Map<String, String> params, List event,
            Map<String, dynamic> lastEvent)?
        function,
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
  static List<dynamic> fromListToJson(List<String> lines,
      {bool allowEmptyLine = true}) {
    final data = <Map<String, dynamic>>[];
    final _headData = <String, dynamic>{};
    final events = [];
    Map<String, dynamic>? lastEvent = {};
    String? currentName;

    if (lines.first.trim() != 'BEGIN:VCALENDAR') {
      throw ICalendarBeginException(
          'The first line must be BEGIN:VCALENDAR but was ${lines.first}.');
    }
    if (lines.last.trim() != 'END:VCALENDAR') {
      throw ICalendarEndException(
          'The last line must be END:VCALENDAR but was ${lines.last}.');
    }
    for (var i = 0; i < lines.length; i++) {
      final line = StringBuffer(lines[i].trim());

      if (line.isEmpty && !allowEmptyLine) {
        throw const EmptyLineException('Empty line are not allowed');
      }

      final exp = RegExp(r'^ ');
      while (i + 1 < lines.length && exp.hasMatch(lines[i + 1])) {
        i += 1;
        line.write(lines[i].trim());
      }

      final dataLine = line.toString().split(':');
      if (dataLine.length < 2 ||
          (dataLine.isNotEmpty &&
              dataLine[0].toUpperCase() != dataLine[0] &&
              !dataLine[0].contains(';'))) {
        if (line.isNotEmpty && currentName != null) {
          lastEvent![currentName] += line.toString();
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
      if (_objects.containsKey(name)) {
        currentName = name.toLowerCase();
        if (name == 'END') {
          currentName = null;
          lastEvent = _objects[name]!(value, params, events, lastEvent, data)
              as Map<String, dynamic>?;
        } else {
          lastEvent =
              _objects[name]!(value, params, events, lastEvent ?? _headData)
                  as Map<String, dynamic>?;
        }
      }
    }
    if (!_headData.containsKey('version')) {
      throw const ICalendarNoVersionException(
          'The body is missing the property VERSION');
    } else if (!_headData.containsKey('prodid')) {
      throw const ICalendarNoProdidException(
          'The body is missing the property PRODID');
    }
    return [_headData, data];
  }

  /// Convert [ICalendar] object to a `Map<String, dynamic>` containing all its data, formatted
  /// into a valid JSON `Map<String, dynamic>`.
  /// ```
  /// {
  ///   "version": ICalendar.version,
  ///   "prodid": ICalendar.prodid,
  ///   "data": ICalendar.data
  /// }
  /// ```
  Map<String, dynamic> toJson() {
    final _map = <String, dynamic>{
      'version': version,
      'prodid': prodid,
    };
    for (final entry in headData.entries) {
      _map[entry.key] = entry.value;
    }
    _map['data'] = data;
    return jsonDecode(jsonEncode(_map, toEncodable: _toEncodable))
        as Map<String, dynamic>;
  }

  static Object? _toEncodable(Object? item) {
    if (item is IcsDateTime) {
      return item.toJson();
    } else if (item is IcsTransp) {
      return item.string;
    } else if (item is IcsStatus) {
      return item.string;
    }
    return item;
  }

  @override
  String toString() =>
      'iCalendar - VERSION: $version - PRODID: $prodid - DATA: $data';
}
