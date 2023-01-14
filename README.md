# icalendar_parser

[![Pub Version](https://img.shields.io/pub/v/icalendar_parser?color=blue&logo=dart)](https://pub.dev/packages/icalendar_parser)
[![Stars](https://img.shields.io/github/stars/TesteurManiak/icalendar_parser)](https://github.com/TesteurManiak/icalendar_parser/stargazers)
[![Dart](https://github.com/TesteurManiak/icalendar_parser/actions/workflows/dart.yml/badge.svg)](https://github.com/TesteurManiak/icalendar_parser/actions/workflows/dart.yml)
[![Coverage Status](https://coveralls.io/repos/github/TesteurManiak/icalendar_parser/badge.svg?branch=main)](https://coveralls.io/github/TesteurManiak/icalendar_parser?branch=main)

Package to parse iCalendar (.ics) files written in pure Dart.

Implementation of [AnyFetch's ics-parser](https://github.com/AnyFetch/ics-parser) in JavaScript.

## Getting Started

Add `icalendar_parser` to your pubspec.yaml:

```bash
icalendar_parser: any
```

## How to use

You can refer to the `example/` folder for a complete example implemented in Flutter.

## Constructor

### ICalendar.fromString

```dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:icalendar_parser/icalendar_parser.dart';

final icsString = await rootBundle.loadString('assets/your_file.ics');
final iCalendar = ICalendar.fromString(icsString);
```

### ICalendar.fromLines

```dart
final icsLines = await File('your_file.ics').readAsLines();
final iCalendar = ICalendar.fromLines(lines);
```

## Other methods

### ICalendar.registerField

With this method you can add fields that are not already supported (check [Supported Properties](#supported-properties)) to the parsing and you can specify a custom `function` to parse its content :

```dart
ICalendar.registerField(field: 'TEST');

ICalendar.registerField(
    field: 'TEST2',
    function: (value, params, event, lastEvent) {
        lastEvent['test2'] = 'test';
        return lastEvent;
    },
);
```

### ICalendar.unregisterField

With this method you can remove parsed fields to ignore them in your file :

```dart
ICalendar.unregisterField('TEST');
```

### ICalendar.toJson

Convert [ICalendar] object to a `Map<String, dynamic>` containing all its data, formatted into a valid JSON `Map<String, dynamic>` .

```dart
final icsObj = ICalendar.fromLines(File('assets/my_file.ics').readAsLinesSync());
print(jsonEncode(icsObj.toJson()));
```

**Input**

```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VEVENT
UID:uid1@example.com
DTSTAMP:19970714T170000Z
ORGANIZER;CN=John Doe:MAILTO:john.doe@example.com
DTSTART:19970714T170000Z
DTEND:19970715T035959Z
SUMMARY:Bastille Day Party
GEO:48.85299;2.36885
END:VEVENT
END:VCALENDAR
```

**Output**

```json
{
    "version": "2.0",
    "prodid": "-//hacksw/handcal//NONSGML v1.0//EN",
    "calscale": "GREGORIAN",
    "method": "PUBLISH",
    "data": [
        {
            "type": "VEVENT",
            "uid": "uid1@example.com",
            "dtstamp": "1997-07-14T17:00:00.000Z",
            "organizer": {
                "name": "John Doe",
                "mail": "john.doe@example.com"
            },
            "dtstart": "1997-07-14T17:00:00.000Z",
            "dtend": "1997-07-15T03:59:59.000Z",
            "summary": "Bastille Day Party",
            "geo": {
                "latitude": 48.85299,
                "longitude": 2.36885
            }
        }
    ]
}
```

## Supported Properties

-   VERSION
-   PRODID
-   CALSCALE
-   METHOD
-   COMPONENT: BEGIN
-   COMPONENT: END
-   DTSTART
-   DTEND
-   DTSTAMP
-   TRIGGER
-   LAST-MODIFIED
-   COMPLETED
-   DUE
-   UID
-   SUMMARY
-   DESCRIPTION
-   LOCATION
-   URL
-   ORGANIZER
-   GEO
-   CATEGORIES
-   ATTENDEE
-   ACTION
-   STATUS
-   SEQUENCE
-   REPEAT
-   RRULE
-   EXDATE
-   CREATED

## Contributors

<!-- readme: contributors -start -->
<table>
<tr>
    <td align="center">
        <a href="https://github.com/TesteurManiak">
            <img src="https://avatars.githubusercontent.com/u/14369698?v=4" width="100;" alt="TesteurManiak"/>
            <br />
            <sub><b>Guillaume Roux</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/LucaCoduriV">
            <img src="https://avatars.githubusercontent.com/u/43602144?v=4" width="100;" alt="LucaCoduriV"/>
            <br />
            <sub><b>Luca</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/simonbengtsson">
            <img src="https://avatars.githubusercontent.com/u/3586691?v=4" width="100;" alt="simonbengtsson"/>
            <br />
            <sub><b>Simon Bengtsson</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/Levi-Lesches">
            <img src="https://avatars.githubusercontent.com/u/20747538?v=4" width="100;" alt="Levi-Lesches"/>
            <br />
            <sub><b>Levi Lesches</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/jjchiw">
            <img src="https://avatars.githubusercontent.com/u/642319?v=4" width="100;" alt="jjchiw"/>
            <br />
            <sub><b>Null</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/stevenboeckmans">
            <img src="https://avatars.githubusercontent.com/u/10263529?v=4" width="100;" alt="stevenboeckmans"/>
            <br />
            <sub><b>Null</b></sub>
        </a>
    </td></tr>
</table>
<!-- readme: contributors -end -->