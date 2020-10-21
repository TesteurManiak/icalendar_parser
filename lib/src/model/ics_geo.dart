class IcsGeo {
  num latitude;
  num longitude;

  IcsGeo({this.latitude, this.longitude});

  factory IcsGeo.fromJson(Map<String, dynamic> json) =>
      IcsGeo(latitude: json['latitude'], longitude: json['longitude']);

  Map<String, dynamic> toJson() =>
      {"latitude": latitude, "longitude": longitude};
}
