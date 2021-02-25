# icalendar_parser

[![Issues](https://img.shields.io/github/issues/TesteurManiak/icalendar_parser)](https://github.com/TesteurManiak/icalendar_parser/issues)
[![Forks](https://img.shields.io/github/forks/TesteurManiak/icalendar_parser)](https://github.com/TesteurManiak/icalendar_parser/network/members)
[![Stars](https://img.shields.io/github/stars/TesteurManiak/icalendar_parser)](https://github.com/TesteurManiak/icalendar_parser/stargazers)
[![Pub Version](https://img.shields.io/pub/v/icalendar_parser?color=blue&logo=dart)](https://pub.dev/packages/icalendar_parser)
<img src="./coverage_badge.svg">

Package to parse iCalendar (.ics) files written in pure Dart.

Implementation of [AnyFetch's ics-parser](https://github.com/AnyFetch/ics-parser) in JavaScript.

## Getting Started

Add `icalendar_parser` to your pubspec.yaml:

``` bash
icalendar_parser: any
```

## How to use

You can refer to the `example/` folder for a complete example implemented in Flutter.

### ICalendar.fromString

``` dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:icalendar_parser/icalendar_parser.dart';

final icsString = await rootBundle.loadString('assets/your_file.ics');
final iCalendar = ICalendar.fromString(icsString);
```

### ICalendar.fromLines

``` dart
final icsLines = await File('your_file.ics').readAsLines();
final iCalendar = ICalendar.fromLines(lines);
```

## Supported Properties

* VERSION
* PRODID
* CALSCALE
* METHOD
* COMPONENT:BEGIN
* COMPONENT:END
* DTSTART
* DTEND
* DTSTAMP
* TRIGGER
* LAST-MODIFIED
* COMPLETED
* DUE
* UID
* SUMMARY
* DESCRIPTION
* LOCATION
* URL
* ORGANIZER
* GEO
* CATEGORIES
* ATTENDEE
* ACTION
* STATUS
* SEQUENCE
* REPEAT
* REPEAT
