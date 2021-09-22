/// Enumeration of all transparency types.
///
/// See doc: https://www.kanzaki.com/docs/ical/transp.html
enum IcsTransp { opaque, transparent }

extension IcsTranspModifier on IcsTransp {
  String get string => toString().split('.').last.toUpperCase();
}
