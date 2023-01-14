# Changelog

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
