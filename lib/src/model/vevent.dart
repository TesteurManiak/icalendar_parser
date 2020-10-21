import 'package:icalendar_parser/src/model/ics_geo.dart';
import 'package:icalendar_parser/src/model/organizer.dart';

class VEvent {
  final String uid;
  final IcsOrganizer organizer;
  final String name;
  final IcsGeo geo;

  VEvent({this.uid, this.organizer, this.name, this.geo});

  factory VEvent.fromJson(Map<String, dynamic> json) => VEvent(
        uid: json['uid'],
        organizer: IcsOrganizer.fromJson(json['organizer']),
        name: json['name'],
        geo: IcsGeo.fromJson(json['geo']),
      );

  Map<String, dynamic> toJson() => {
        "type": "VEVENT",
        "uid": uid,
        "organizer": organizer?.toJson(),
        "name": name,
        "geo": geo?.toJson(),
      };
}
