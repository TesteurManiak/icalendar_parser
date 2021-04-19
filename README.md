# icalendar_parser

[![Pub Version](https://img.shields.io/pub/v/icalendar_parser?color=blue&logo=dart)](https://pub.dev/packages/icalendar_parser)
[![Stars](https://img.shields.io/github/stars/TesteurManiak/icalendar_parser)](https://github.com/TesteurManiak/icalendar_parser/stargazers)
[![Dart](https://github.com/TesteurManiak/icalendar_parser/actions/workflows/dart.yml/badge.svg)](https://github.com/TesteurManiak/icalendar_parser/actions/workflows/dart.yml)
[![Issues](https://img.shields.io/github/issues/TesteurManiak/icalendar_parser)](https://github.com/TesteurManiak/icalendar_parser/issues)

Package to parse iCalendar (.ics) files written in pure Dart.

Implementation of [AnyFetch's ics-parser](https://github.com/AnyFetch/ics-parser) in JavaScript.

## Getting Started

Add `icalendar_parser` to your pubspec.yaml:

``` bash
icalendar_parser: any
```

## How to use

You can refer to the `example/` folder for a complete example implemented in Flutter.

## Constructor

### ICalendar.fromString

**Warning: For unknown reason the command `dart test` on GitHub Actions will generate errors so try to prefer using `ICalendar.fromLines` in your unit tests.**

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

## Other methods

### ICalendar.registerField

With this method you can add custom fields to the parsing and you can specify a custom `function` to parse its content :

``` dart
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

``` dart
ICalendar.unregisterField('TEST');
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
