# Changelog

## [0.8.0+1] - 14/07/2021

* Export ics_datetime.dart [#29](https://github.com/TesteurManiak/icalendar_parser/pull/29)

## [0.8.0] - 04/06/2021

* **Breaking Change:** Added class `IcsDateTime` to replace the `DateTime.tryParse` ensuring no timezone data are lost ([#22](https://github.com/TesteurManiak/icalendar_parser/issues/27))

## [0.7.0] - 02/06/2021

* `toJson()` now returns a correctly formatted JSON
* Removed some irrelevant tests
* Refacto a few unit tests so they can use real `.ics` files
* Added lint rules to the code

## [0.6.0] - 22/04/2021

* Fixed an issue with line folding sometimes causing an exception ([#21](https://github.com/TesteurManiak/icalendar_parser/pull/21))
* Fix TRIGGER and SEQUENCE warnings ([#22](https://github.com/TesteurManiak/icalendar_parser/pull/22))

## [0.5.1] - 19/04/2021

* Fix for `DESCRIPTION` text that is spanned over multiple lines and contains a `:` ([#19](https://github.com/TesteurManiak/icalendar_parser/pull/19))

## [0.5.0] - 25/03/2021

* Migrate code to nullsafety
* Refacto some tests

## [0.4.2] - 04/03/2021

* Added method `registerField` and `unregisterField` to add custom fields to parsing. 

## [0.4.1] - 25/02/2021

* Updated `/example`
* Updated `README.md`
* Added unit tests and code coverage
* Added support for `IcsStatus` enum:
    - `NEEDS-ACTION`
    - `COMPLETED`
    - `IN-PROCESS`
    - `DRAFT`
    - `FINAL`

## [0.4.0] - 27/10/2020

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

## [0.3.1] - 26/10/2020

* Fixed parsing of `DTSTART` and `DTEND`

## [0.3.0] - 26/10/2020

* Fixed `END:VCALENDAR` check if ending with newline
* Added parameter `lineSeparator` to `ICalendar.fromString`
* Added constructor `ICalendar.fromLines`
* Added some unit tests

## [0.1.1+1] - 24/10/2020

* Added pedantic rules to lint code

## [0.1.1] - 24/10/2020

* Compatible with `dart::core`
* Authorize `END:VCALENDAR` ending with newline

## [0.1.0] - 21/10/2020

* First release
* Parse an `ICalendar` object from a `String`
