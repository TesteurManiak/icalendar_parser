import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/model/icalendar.dart';

/// [VEvent] describes an event, which has a scheduled amout of time on a
/// calendar.
///
/// A [VEvent] may include a [VAlarm] which allows an alarm.
class VEvent implements CalendarComponent {
  final String uid;
  final DateTime dtStamp;
  final DateTime dtStart;
  final DateTime dtEnd;
  final String summary;
  final double lat;
  final double lng;
  final VAlarm vAlarm;

  VEvent({
    this.uid,
    this.dtStamp,
    this.dtStart,
    this.dtEnd,
    this.summary,
    this.lat,
    this.lng,
    this.vAlarm,
  });

  factory VEvent.parseFromString(String vEventString, {bool allowEmptyLine}) {
    return VEvent();
  }
}
