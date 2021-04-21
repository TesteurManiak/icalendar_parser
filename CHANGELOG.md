# Changelog

## [0.5.2] - 21/04/2021

* Fix an issue with line folding sometimes causing an exception (Contributor: [simonbengtsson](https://github.com/simonbengtsson))

## [0.5.1] - 19/04/2021

* Fix for `DESCRIPTION` text that is spanned over multiple lines and contains a `:` (Contributor: [stevenboeckmans](https://github.com/TesteurManiak/icalendar_parser/pull/19))

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
