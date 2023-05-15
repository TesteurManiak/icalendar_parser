part of 'ical_component.dart';

/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-6-1-event-component.html
class VEvent extends ICalComponent {
  VEvent({
    required this.dtStamp,
    required this.uid,
    this.dtStart,
    this.classification = Classification.public,
    this.created,
    this.description,
    this.geo,
    this.lastModified,
    this.location,
  }) : super('VEVENT');

  factory VEvent.parse(List<String> lines) {
    final map = <String, String>{};

    // TODO: parse lines
    for (final line in lines) {
      final parts = line.split(':');
      if (parts.length != 2) {
        throw ArgumentError('Invalid line: $line');
      }
      map[parts[0]] = parts[1];
    }

    final dtStamp = map['DTSTAMP'];
    if (dtStamp == null) {
      throw ArgumentError('DTSTAMP is required in VEVENT component.');
    }

    final uid = map['UID'];
    if (uid == null) {
      throw ArgumentError('UID is required in VEVENT component.');
    }

    return VEvent(
      dtStamp: IcalDateTime.parse(dtStamp),
      uid: uid,
      dtStart: IcalDateTime.tryParse(map['DTSTART']),
      classification: Classification.parse(map['CLASS'] ?? 'PUBLIC'),
      created: IcalDateTime.tryParse(map['CREATED']),
      description: map['DESCRIPTION'],
      geo: GeographicPosition.tryParse(map['GEO']),
      lastModified: IcalDateTime.tryParse(map['LAST-MODIFIED']),
      location: Location.tryParse(map['LOCATION']),
    );
  }

  final IcalDateTime dtStamp;
  final String uid;
  final IcalDateTime? dtStart;
  final Classification classification;
  final IcalDateTime? created;
  final String? description;
  final (double, double)? geo;
  final IcalDateTime? lastModified;
  final Location? location;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'dtStamp': dtStamp.toString(),
      'uid': uid,
      'dtStart': dtStart?.toString(),
      'classification': classification.toString(),
      'created': created?.toString(),
      'description': description,
      'geo': geo?.toJson(),
      'last-modified': lastModified?.toString(),
      'location': location?.toString(),
    }.toValidMap();
  }
}

extension on (double, double) {
  String toJson() => '${this.$1};${this.$2}';
}
