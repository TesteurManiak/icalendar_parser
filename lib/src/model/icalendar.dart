import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';
import 'package:icalendar_parser/src/extensions/string_extensions.dart';

/// Core object
class ICalendar {
  /// iCalendar's components list.
  final List<Map<String, dynamic>>? data;

  /// iCalendar's fields.
  final Map<String, dynamic>? headData;

  /// `VERSION` of the object.
  String? get version => headData!['version'];

  /// `PRODID` of the object.
  String? get prodid => headData!['prodid'];

  /// `CALSCALE` of the object.
  String? get calscale => headData!['calscale'];

  /// `METHOD` of the object.
  String? get method => headData!['method'];

  /// Default constructor.
  ICalendar({this.data, this.headData});

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
      while (icsString.endsWith(lineSeparator))
        icsString =
            icsString.substring(0, icsString.length - lineSeparator.length);
    }
    final lines = icsString.split(lineSeparator);
    return _linesParser(lines, allowEmptyLine);
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
      while (lines.last.isEmpty) lines.removeLast();
    }
    return _linesParser(lines, allowEmptyLine);
  }

  /// Method to call [fromListToJson] and parse object line by line.
  static ICalendar _linesParser(List<String> lines, bool allowEmptyLine) {
    final parsedData = fromListToJson(lines, allowEmptyLine: allowEmptyLine);
    return ICalendar(
      headData: parsedData.first,
      data: parsedData.last,
    );
  }

  static Function(String, Map<String, String>, List, Map<String, dynamic>)
      _generateDateFunction(String name) {
    return (String value, Map<String, String> params, List events,
        Map<String, dynamic> lastEvent) {
      try {
        lastEvent[name] = DateTime.parse(value);
      } catch (_) {
        print('Warning: $value could not be parsed, stored as String');
        lastEvent[name] = value;
      }
      return lastEvent;
    };
  }

  /// Generate a method that return the [lastEvent] with a new entry at [name]
  /// containing the [value] as [String].
  static Function(String, Map<String, String>, List, Map<String, dynamic>)
      _generateSimpleParamFunction(String name) {
    return (String value, Map<String, String> params, List events,
        Map<String, dynamic> lastEvent) {
      lastEvent[name] = value.replaceAll(RegExp(r'/\\n/g'), '\n');
      return lastEvent;
    };
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

      int index = events.indexOf(lastEvent);
      if (index != -1) events.removeAt(index);

      if (events.isEmpty)
        lastEvent = null;
      else
        lastEvent = events.last;

      return lastEvent;
    },
    'DTSTART': _generateDateFunction('dtstart'),
    'DTEND': _generateDateFunction('dtend'),
    'DTSTAMP': _generateDateFunction('dtstamp'),
    'TRIGGER': _generateDateFunction('trigger'),
    'LAST-MODIFIED': _generateDateFunction('lastModified'),
    'COMPLETED': _generateDateFunction('completed'),
    'DUE': _generateDateFunction('due'),
    'UID': _generateSimpleParamFunction('uid'),
    'SUMMARY': _generateSimpleParamFunction('summary'),
    'DESCRIPTION': _generateSimpleParamFunction('description'),
    'LOCATION': _generateSimpleParamFunction('location'),
    'URL': _generateSimpleParamFunction('url'),
    'ORGANIZER': (String value, Map<String, String> params, List events,
        Map<String, dynamic> lastEvent) {
      final mail = value.replaceAll('MAILTO:', '').trim();

      if (params.containsKey('CN')) {
        lastEvent['organizer'] = {
          'name': params['CN'],
          'mail': mail,
        };
      } else
        lastEvent['organizer'] = {'mail': mail};

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
    'ACTION': _generateSimpleParamFunction('action'),
    'STATUS': (String value, Map<String, String> _, List __,
        Map<String, dynamic> lastEvent) {
      lastEvent['status'] = value.trim().toIcsStatus();
      return lastEvent;
    },
    'SEQUENCE': _generateDateFunction('sequence'),
    'REPEAT': _generateSimpleParamFunction('repeat'),
    'CLASS': _generateSimpleParamFunction('class'),
    'TRANSP': (String value, Map<String, String> _, List __,
        Map<String, dynamic> lastEvent) {
      lastEvent['transp'] = value.trim().toIcsTransp();
      return lastEvent;
    },
    'VERSION': _generateSimpleParamFunction('version'),
    'PRODID': _generateSimpleParamFunction('prodid'),
    'CALSCALE': _generateSimpleParamFunction('calscale'),
    'METHOD': _generateSimpleParamFunction('method'),
  };

  /// Managed parsing methods.
  static Map<String, Function> get objects => _objects;

  /// Allow to add custom field to parse.
  ///
  /// If no `function` parameter to parse the field is provided the default
  /// method `_generateSimpleParamFunction` will be used.
  ///
  /// If a field with the same name already exists the method will throw a
  /// `ICalendarFormatException`.
  static void registerField({
    required String field,
    Function(String value, Map<String, String> params, List event,
            Map<String, dynamic> lastEvent)?
        function,
  }) {
    if (_objects.containsKey(field))
      throw ICalendarFormatException('The field $field is already registered.');

    _objects[field] = function != null
        ? function
        : _generateSimpleParamFunction(field.toLowerCase());
  }

  /// Remove an existing parsing field.
  ///
  /// If there is no corresponding field the method will throw a
  /// `ICalendarFormatException`.
  static void unregisterField(String field) {
    if (!_objects.containsKey(field))
      throw ICalendarFormatException('The field $field does not exists.');
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
    List<Map<String, dynamic>> data = [];
    Map<String, dynamic> _headData = {};
    List events = [];
    Map<String, dynamic>? lastEvent = {};
    String? currentName;

    if (lines.first.trim() != 'BEGIN:VCALENDAR')
      throw ICalendarBeginException(
          'The first line must be BEGIN:VCALENDAR but was ${lines.first}.');
    if (lines.last.trim() != 'END:VCALENDAR')
      throw ICalendarEndException(
          'The last line must be END:VCALENDAR but was ${lines.last}.');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      if (line.isEmpty && !allowEmptyLine)
        throw const EmptyLineException('Empty line are not allowed');

      final exp = RegExp(r'^ ');
      while (i + 1 < lines.length && exp.hasMatch(lines[i + 1])) {
        i += 1;
        line += lines[i].trim();
      }

      List<String> dataLine = line.split(':');
      if (dataLine.length < 2 ||
          (dataLine.isNotEmpty &&
              dataLine[0].toUpperCase() != dataLine[0] &&
              !dataLine[0].contains(';'))) {
        if (line.isNotEmpty && currentName != null) {
          lastEvent![currentName] += line;
        }
        continue;
      }

      List<String> dataName = dataLine[0].split(';');

      final name = dataName[0];
      dataName.removeRange(0, 1);

      Map<String, String> params = {};
      for (String e in dataName) {
        List<String> param = e.split('=');
        if (param.length == 2) params[param[0]] = param[1];
      }

      dataLine.removeRange(0, 1);
      String value = dataLine.join(':').replaceAll(RegExp(r'\\,'), ',');
      if (_objects.containsKey(name)) {
        currentName = name.toLowerCase();
        if (name == 'END') {
          currentName = null;
          lastEvent = _objects[name]!(value, params, events, lastEvent, data);
        } else
          lastEvent =
              _objects[name]!(value, params, events, lastEvent ?? _headData);
      }
    }
    if (!_headData.containsKey('version'))
      throw const ICalendarNoVersionException(
          'The body is missing the property VERSION');
    else if (!_headData.containsKey('prodid'))
      throw const ICalendarNoProdidException(
          'The body is missing the property PRODID');
    return [_headData, data];
  }

  /// Convert [ICalendar] object to a [Map] containing all its data.
  ///
  /// ```
  /// {
  ///   "version": ICalendar.version,
  ///   "prodid": ICalendar.prodid,
  ///   "data": ICalendar.data
  /// }
  /// ```
  Map<String, dynamic> toJson() => {
        'version': version,
        'prodid': prodid,
        'data': data,
      };

  @override
  String toString() =>
      'iCalendar - VERSION: $version - PRODID: $prodid - DATA: $data';
}
