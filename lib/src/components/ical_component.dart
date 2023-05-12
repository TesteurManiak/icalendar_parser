abstract class ICalComponent {
  const ICalComponent(this.type);

  final String type;

  Map<String, dynamic> toJson();
}
