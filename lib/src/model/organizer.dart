class IcsOrganizer {
  final String? name;
  final String? mail;

  IcsOrganizer({this.name, this.mail});

  factory IcsOrganizer.fromJson(Map<String, dynamic> json) => IcsOrganizer(
        name: json['name'],
        mail: json['mail'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'mail': mail,
      };
}
