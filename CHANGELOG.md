# Changelog

## [2.1.0]

* Bump fd_lints from 1.0.2 to 1.1.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/58
* Bump collection from 1.17.1 to 1.17.2 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/57
* Bump fd_lints from 1.1.0 to 1.1.1 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/60
* Bump test from 1.24.2 to 1.24.3 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/59
* Bump fd_lints from 1.1.1 to 2.0.1 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/62
* Bump fd_lints from 2.0.1 to 2.1.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/64
* Bump test from 1.24.3 to 1.24.4 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/63
* Bump test from 1.24.4 to 1.24.5 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/66
* Bump test from 1.24.5 to 1.24.6 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/68
* Bump collection from 1.17.2 to 1.18.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/65
* chore: bump dependencies by @TesteurManiak in https://github.com/TesteurManiak/icalendar_parser/pull/76
* Bump coverage from 1.7.1 to 1.7.2 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/78
* Bump test from 1.24.9 to 1.25.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/77
* Bump test from 1.25.0 to 1.25.1 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/79
* Bump test from 1.25.1 to 1.25.2 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/80
* Bump meta from 1.11.0 to 1.12.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/81
* Bump meta from 1.12.0 to 1.14.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/82
* Bump test from 1.25.2 to 1.25.3 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/83
* Bump test from 1.25.3 to 1.25.4 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/84
* Bump fd_lints from 2.2.0 to 2.2.1 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/85
* Bump test from 1.25.4 to 1.25.5 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/88
* Bump meta from 1.14.0 to 1.15.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/87
* Bump coverage from 1.7.2 to 1.8.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/86
* Bump fd_lints from 2.2.1 to 2.3.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/90
* Bump test from 1.25.5 to 1.25.6 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/89
* Bump test from 1.25.6 to 1.25.7 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/91
* Bump collection from 1.18.0 to 1.19.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/92
* Bump test from 1.25.7 to 1.25.8 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/93
* Bump coverage from 1.8.0 to 1.9.0 by @dependabot in https://github.com/TesteurManiak/icalendar_parser/pull/94
* chore: bump dependencies by @TesteurManiak in https://github.com/TesteurManiak/icalendar_parser/pull/97


**Full Changelog**: https://github.com/TesteurManiak/icalendar_parser/compare/2.0.0...2.1.0

## [2.0.0]

* Fixed `toJson()` format
* Updated linting
* Updated example to be a Dart executable
* Updated Dart SDK constraint to `>=3.0.0 <4.0.0`

## [1.1.1]

* Added CREATED ([#46](https://github.com/TesteurManiak/icalendar_parser/issues/46))
* Added Contributors section to README
* Putted back code coverage badge

## [1.1.0]

* Fixed EXDATE parsing ([#44](https://github.com/TesteurManiak/icalendar_parser/pull/44)
* Upgraded dev dependencies
* Refactored some code to beneficiate from enhanced enums

## [1.0.2]

* Added EXDATE ([#37](https://github.com/TesteurManiak/icalendar_parser/pull/37) from [LucaCoduriV](https://github.com/LucaCoduriV))
* Removed dependency to [collection](https://pub.dev/packages/collection)

## [1.0.1+1]

* Updated linting rules

## [1.0.1]

* Fixed [issue #33](https://github.com/TesteurManiak/icalendar_parser/issues/33): Exception on ORGANIZER field parsing

## [1.0.0] - 22/09/2021

* Fixed `fromString` constructor
* Full test coverage on the package

## [0.8.1]

* Added RRULE [#30](https://github.com/TesteurManiak/icalendar_parser/pull/30)

## [0.8.0+1]

* Export ics_datetime.dart [#29](https://github.com/TesteurManiak/icalendar_parser/pull/29)

## [0.8.0]

* **Breaking Change:** Added class `IcsDateTime` to replace the `DateTime.tryParse` ensuring no timezone data are lost ([#22](https://github.com/TesteurManiak/icalendar_parser/issues/27))

## [0.7.0]

* `toJson()` now returns a correctly formatted JSON
* Removed some irrelevant tests
* Refacto a few unit tests so they can use real `.ics` files
* Added lint rules to the code

## [0.6.0]

* Fixed an issue with line folding sometimes causing an exception ([#21](https://github.com/TesteurManiak/icalendar_parser/pull/21))
* Fix TRIGGER and SEQUENCE warnings ([#22](https://github.com/TesteurManiak/icalendar_parser/pull/22))

## [0.5.1]

* Fix for `DESCRIPTION` text that is spanned over multiple lines and contains a `:` ([#19](https://github.com/TesteurManiak/icalendar_parser/pull/19))

## [0.5.0]

* Migrate code to nullsafety
* Refacto some tests

## [0.4.2]

* Added method `registerField` and `unregisterField` to add custom fields to parsing. 

## [0.4.1]

* Updated `/example`
* Updated `README.md`
* Added unit tests and code coverage
* Added support for `IcsStatus` enum:
    - `NEEDS-ACTION`
    - `COMPLETED`
    - `IN-PROCESS`
    - `DRAFT`
    - `FINAL`

## [0.4.0]

* Improved unit tests
* Added support for fields:
    - `TRIGGER`
    - `ACTION`
    - `METHOD`
    - `STATUS` (using `IcsStatus` enum)
    - `SEQUENCE`
    - `REPEAT`
    - `CLASS`
    - `TRANSP` (using `IcsTransp` enum)

## [0.3.1]

* Fixed parsing of `DTSTART` and `DTEND`

## [0.3.0]

* Fixed `END:VCALENDAR` check if ending with newline
* Added parameter `lineSeparator` to `ICalendar.fromString`
* Added constructor `ICalendar.fromLines`
* Added some unit tests

## [0.1.1+1]

* Added pedantic rules to lint code

## [0.1.1]

* Compatible with `dart::core`
* Authorize `END:VCALENDAR` ending with newline

## [0.1.0]

* First release
* Parse an `ICalendar` object from a `String`
