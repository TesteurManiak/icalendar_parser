class IcsGeo {
  num latitude;
  num longitude;

  IcsGeo({required this.latitude, required this.longitude});

  factory IcsGeo.fromJson(Map<String, dynamic> json) => IcsGeo(
        latitude: json['latitude'] as num,
        longitude: json['longitude'] as num,
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
