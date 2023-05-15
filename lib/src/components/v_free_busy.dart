part of 'ical_component.dart';

/// A component that represents either a request for free or busy time
/// information, a reply to a request for free or busy time information, or a
/// published set of busy time information.
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-6-4-free-busy-component.html
class VFreeBusy extends ICalComponent {
  const VFreeBusy({
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
  }) : super('VFREEBUSY');

  final IcalDateTime dtStamp;
  final String uid;
  final String? contact;
  final IcalDateTime? dtStart;
  final IcalDateTime? dtEnd;
  final ICalOrganizer? organizer;
  final Uri? url;
  final List<Uri>? attendees;
  final List<String>? comments;
  final List<PeriodOfTime>? freebusies;
  final List<String>? rstatuses;
  final List<String>? xProps;
  final List<String>? ianaProps;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'dtStamp': dtStamp.toJson(),
      'uid': uid,
      'contact': contact,
      'dtStart': dtStart?.toJson(),
      'dtEnd': dtEnd?.toJson(),
      'organizer': organizer?.toString(),
      'url': url?.toString(),
      'attendees': attendees,
      'comments': comments,
      'freebusy': freebusies?.map((e) => e.toString()).toList(),
      'rstatuses': rstatuses,
      'xProps': xProps,
      'ianaProps': ianaProps,
    }.toValidMap();
  }
}
