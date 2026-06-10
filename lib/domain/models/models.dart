class TripModel {
  final int id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalDistanceKm;
  final double maxSpeedKmh;
  final double avgSpeedKmh;
  final double maxGForce;
  final String status;

  const TripModel({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.totalDistanceKm = 0,
    this.maxSpeedKmh = 0,
    this.avgSpeedKmh = 0,
    this.maxGForce = 0,
    this.status = 'active',
  });
}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
  });
}
