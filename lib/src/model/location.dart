/// https://icalendar.org/iCalendar-RFC-5545/3-8-1-7-location.html
class Location {
  const Location({
    this.altRep,
    this.language,
  });

  final String? altRep;
  final String? language;
}
