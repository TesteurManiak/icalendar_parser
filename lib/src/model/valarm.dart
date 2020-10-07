/// Allow an alarm. This event has a [DTSTART] which sets a starting time, and a
/// [DTEND] which sets an ending time. If the calendar event is reccuring,
/// [DTSTART] sets up the start of the first event.
class VAlarm {
  VAlarm();
  
  factory VAlarm.parseFromString(String vAlarmString) {
    // final dataList = vAlarmString.split('\n');
    return VAlarm();
  }
}