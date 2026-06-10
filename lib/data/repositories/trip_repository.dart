import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart' show Value;
import '../local/daos/daos.dart';
import '../local/database/app_database.dart';

class TripRepository extends GetxService {
  final Daos _daos = Get.find<Daos>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> createTrip(TripsCompanion trip) => _daos.trips.createTrip(trip);

  Future<void> finishTrip(int id, {required double totalDistanceKm, required double maxSpeedKmh, required double avgSpeedKmh, required double maxGForce}) {
    return _daos.trips.updateTrip(
      id,
      TripsCompanion(
        endTime: Value(DateTime.now()),
        totalDistanceKm: Value(totalDistanceKm),
        maxSpeedKmh: Value(maxSpeedKmh),
        avgSpeedKmh: Value(avgSpeedKmh),
        maxGForce: Value(maxGForce),
        status: Value('finished'),
      ),
    );
  }

  Future<void> updateTripStatus(int id, String status) {
    return _daos.trips.updateTrip(
      id,
      TripsCompanion(status: Value(status)),
    );
  }

  Future<List<Trip>> getMyTrips(String userId) => _daos.trips.getMyTrips(userId);

  Future<void> syncTripToFirestore(Trip trip, String uid) async {
    if (uid == 'guest') return;
    try {
      await _firestore.collection('users').doc(uid).collection('trips').doc(trip.id.toString()).set({
        'id': trip.id,
        'startTime': trip.startTime.toIso8601String(),
        'endTime': trip.endTime?.toIso8601String(),
        'totalDistanceKm': trip.totalDistanceKm,
        'maxSpeedKmh': trip.maxSpeedKmh,
        'avgSpeedKmh': trip.avgSpeedKmh,
        'maxGForce': trip.maxGForce,
        'status': trip.status,
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> syncRoutePointsToFirestore(int tripId, List<RoutePoint> points, String uid) async {
    if (uid == 'guest' || points.isEmpty) return;
    try {
      final batch = _firestore.batch();
      for (final p in points) {
        final ref = _firestore
            .collection('users').doc(uid)
            .collection('trips').doc(tripId.toString())
            .collection('routePoints').doc(p.id.toString());
        batch.set(ref, {
          'id': p.id,
          'latitude': p.latitude,
          'longitude': p.longitude,
          'speedKmh': p.speedKmh,
          'recordedAt': p.recordedAt.toIso8601String(),
        }, SetOptions(merge: true));
      }
      await batch.commit();
    } catch (_) {}
  }

  Future<List<Trip>> getTripsFromFirestore(String uid) async {
    if (uid == 'guest') return [];
    try {
      final snap = await _firestore
          .collection('users').doc(uid)
          .collection('trips')
          .orderBy('startTime', descending: true)
          .get();
      return snap.docs.map((doc) {
        final d = doc.data();
        return Trip(
          id: d['id'] as int,
          userId: uid,
          startTime: DateTime.parse(d['startTime'] as String),
          endTime: d['endTime'] != null ? DateTime.parse(d['endTime'] as String) : null,
          totalDistanceKm: (d['totalDistanceKm'] as num).toDouble(),
          maxSpeedKmh: (d['maxSpeedKmh'] as num).toDouble(),
          avgSpeedKmh: (d['avgSpeedKmh'] as num).toDouble(),
          maxGForce: (d['maxGForce'] as num).toDouble(),
          status: d['status'] as String? ?? 'finished',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<RoutePoint>> getRoutePointsFromFirestore(int tripId, String uid) async {
    if (uid == 'guest') return [];
    try {
      final snap = await _firestore
          .collection('users').doc(uid)
          .collection('trips').doc(tripId.toString())
          .collection('routePoints')
          .orderBy('recordedAt')
          .get();
      return snap.docs.map((doc) {
        final d = doc.data();
        return RoutePoint(
          id: d['id'] as int,
          tripId: tripId,
          latitude: (d['latitude'] as num).toDouble(),
          longitude: (d['longitude'] as num).toDouble(),
          speedKmh: (d['speedKmh'] as num).toDouble(),
          recordedAt: DateTime.parse(d['recordedAt'] as String),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, double>> getTripStats(String userId) async {
    final trips = await getMyTrips(userId);
    final finished = trips.where((t) => t.status == 'finished');
    double totalDistance = 0;
    double totalDuration = 0;
    for (final trip in finished) {
      totalDistance += trip.totalDistanceKm;
      if (trip.endTime != null) {
        totalDuration += trip.endTime!.difference(trip.startTime).inSeconds;
      }
    }
    return {
      'count': finished.length.toDouble(),
      'totalDistance': totalDistance,
      'totalDuration': totalDuration,
    };
  }

  Future<Trip?> getTripById(int id) => _daos.trips.getTripById(id);

  Future<void> deleteTrip(int id) => _daos.deleteTripCascade(id);

  Future<void> migrateGuestTrips(String toUserId) => _daos.trips.migrateGuestTrips(toUserId);

  Future<int> addRoutePoint({
    required int tripId,
    required double latitude,
    required double longitude,
    required double speedKmh,
  }) {
    return _daos.routePoints.insertPoint(
      RoutePointsCompanion(
        tripId: Value(tripId),
        latitude: Value(latitude),
        longitude: Value(longitude),
        speedKmh: Value(speedKmh),
        recordedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<RoutePoint>> getRoutePoints(int tripId) => _daos.routePoints.getRoutePoints(tripId);

  Future<void> saveTelemetryBatch(List<TelemetryLogsCompanion> entries) => _daos.telemetry.insertBatch(entries);

  Future<List<TelemetryLog>> getTelemetryLogs(int tripId) => _daos.telemetry.getTelemetryLogs(tripId);

  Future<int> addMedia({
    required int tripId,
    required String type,
    required String filePath,
    String? thumbnailPath,
    String? overlayConfig,
  }) {
    return _daos.media.insertMedia(
      MediaFilesCompanion(
        tripId: Value(tripId),
        type: Value(type),
        filePath: Value(filePath),
        thumbnailPath: Value(thumbnailPath),
        overlayConfig: Value(overlayConfig),
        capturedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<MediaFile>> getMediaByTrip(int tripId) => _daos.media.getMediaByTrip(tripId);

  Future<void> deleteMedia(int id) => _daos.media.deleteMedia(id);
}
