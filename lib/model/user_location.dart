class UserLocation {
  final String email;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double verticalAccuracy;
  final double altitude;
  final double speed;
  final double speedAccuracy;
  final double heading;
  final double time;

  UserLocation({required this.email, required this.latitude, required this.longitude, required this.accuracy, required this.verticalAccuracy, required this.altitude, required this.speed, required this.speedAccuracy, required this.heading, required this.time});

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      email: json['email'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      accuracy: json['accuracy'] as double,
      verticalAccuracy: json['verticalAccuracy'] as double,
      altitude: json['altitude'] as double,
      speed: json['speed'] as double,
      speedAccuracy: json['speedAccuracy'] as double,
      heading: json['heading'] as double,
      time: json['time'] as double,
    );
  }
}