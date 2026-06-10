class TelemetryData {
  final double speedKmh;
  final double avgSpeedKmh;
  final double maxSpeedKmh;
  final double distanceKm;
  final double gForceX;
  final double gForceY;
  final double gForceMagnitude;
  final double maxGForce;
  final double compassBearing;
  final double? latitude;
  final double? longitude;

  const TelemetryData({
    this.speedKmh = 0,
    this.avgSpeedKmh = 0,
    this.maxSpeedKmh = 0,
    this.distanceKm = 0,
    this.gForceX = 0,
    this.gForceY = 0,
    this.gForceMagnitude = 0,
    this.maxGForce = 0,
    this.compassBearing = 0,
    this.latitude,
    this.longitude,
  });

  TelemetryData copyWith({
    double? speedKmh,
    double? avgSpeedKmh,
    double? maxSpeedKmh,
    double? distanceKm,
    double? gForceX,
    double? gForceY,
    double? gForceMagnitude,
    double? maxGForce,
    double? compassBearing,
    double? latitude,
    double? longitude,
  }) {
    return TelemetryData(
      speedKmh: speedKmh ?? this.speedKmh,
      avgSpeedKmh: avgSpeedKmh ?? this.avgSpeedKmh,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      distanceKm: distanceKm ?? this.distanceKm,
      gForceX: gForceX ?? this.gForceX,
      gForceY: gForceY ?? this.gForceY,
      gForceMagnitude: gForceMagnitude ?? this.gForceMagnitude,
      maxGForce: maxGForce ?? this.maxGForce,
      compassBearing: compassBearing ?? this.compassBearing,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
