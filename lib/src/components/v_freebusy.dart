import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/components/ical_component.dart';
import 'package:icalendar_parser/src/model/calendar_user_address.dart';
import 'package:icalendar_parser/src/model/ical_organizer.dart';

/// A component that represents either a request for free or busy time
/// information, a reply to a request for free or busy time information, or a
/// published set of busy time information.
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-6-4-free-busy-component.html
class VFreebusy implements ICalComponent {
  const VFreebusy({
    required this.dtStamp,
    required this.uid,
    this.contact,
    this.dtStart,
    this.dtEnd,
    this.organizer,
    this.url,
    this.attendees,
    this.comments,
    this.freebusies,
    this.rstatuses,
    this.xProps,
    this.ianaProps,
  });

  final IcsDateTime dtStamp;
  final String uid;
  final String? contact;
  final IcsDateTime? dtStart;
  final IcsDateTime? dtEnd;
  final ICalOrganizer? organizer;
  final Uri? url;
  final List<CalendarUserAddress>? attendees;

  final List<String>? comments;

  // TODO: use Period value type
  final List<String>? freebusies;

  final List<String>? rstatuses;
  final List<String>? xProps;
  final List<String>? ianaProps;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'VFREEBUSY',
      'dtStamp': dtStamp.toJson(),
      'uid': uid,
      if (contact != null) 'contact': contact,
      if (dtStart != null) 'dtStart': dtStart?.toJson(),
      if (dtEnd != null) 'dtEnd': dtEnd?.toJson(),
      if (organizer != null) 'organizer': organizer?.toString(),
      if (url != null) 'url': url?.toString(),
      if (attendees != null) 'attendees': attendees,
      if (comments != null) 'comments': comments,
      if (freebusies != null) 'freebusies': freebusies,
      if (rstatuses != null) 'rstatuses': rstatuses,
      if (xProps != null) 'xProps': xProps,
      if (ianaProps != null) 'ianaProps': ianaProps,
    };
  }
}
