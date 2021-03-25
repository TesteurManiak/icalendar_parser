import 'package:icalendar_parser/src/model/ics_class.dart';
import 'package:icalendar_parser/src/model/ics_geo.dart';
import 'package:icalendar_parser/src/model/ics_status.dart';
import 'package:icalendar_parser/src/model/organizer.dart';
import 'package:icalendar_parser/src/model/ics_transp.dart';

/// VEVENT component
class VEvent {
  final String? uid;
  final dynamic dtStart;
  final dynamic dtEnd;
  final dynamic dtStamp;
  final IcsOrganizer? organizer;
  final IcsGeo? geo;
  final String? summary;
  final String? location;
  final List<String>? categories;
  final IcsStatus? status;
  final String? description;
  final IcsTransp? transp;
  final int? sequence;
  final IcsClass? icsClass;
  final dynamic lastModified;

  VEvent({
    this.uid,
    this.dtStart,
    this.dtEnd,
    this.dtStamp,
    this.organizer,
    this.geo,
    this.summary,
    this.location,
    this.categories,
    this.status,
    this.description,
    this.transp,
    this.sequence,
    this.icsClass,
    this.lastModified,
  });
}
