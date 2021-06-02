class IcsOrganizer {
  final String? name;
  final String? mail;

  IcsOrganizer({this.name, this.mail});

  factory IcsOrganizer.fromJson(Map<String, dynamic> json) => IcsOrganizer(
        name: json['name'] as String?,
        mail: json['mail'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'mail': mail,
      };
}
