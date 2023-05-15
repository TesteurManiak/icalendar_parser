import 'package:icalendar_parser/src/components/ical_component.dart';
import 'package:icalendar_parser/src/model/classification.dart';
import 'package:icalendar_parser/src/model/ical_datetime.dart';
import 'package:icalendar_parser/src/utils/extensions.dart';

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
  }) : super('VEVENT');

  final IcalDateTime dtStamp;
  final String uid;
  final IcalDateTime? dtStart;
  final Classification classification;
  final IcalDateTime? created;
  final String? description;
  final (double, double)? geo;
  final IcalDateTime? lastModified;

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
    }.toValidMap();
  }
}

extension on (double, double) {
  String toJson() => '${this.$1};${this.$2}';
}
