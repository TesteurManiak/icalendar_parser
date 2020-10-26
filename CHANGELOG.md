# Changelog

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
