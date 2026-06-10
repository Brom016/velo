import 'package:drift/drift.dart';
import '../database/app_database.dart';

class Daos {
  final AppDatabase _db;

  Daos(this._db);

  TripsDao get trips => TripsDao(_db);
  RoutePointsDao get routePoints => RoutePointsDao(_db);
  TelemetryDao get telemetry => TelemetryDao(_db);
  MediaDao get media => MediaDao(_db);

  Future<void> deleteTripCascade(int tripId) async {
    await _db.batch((batch) {
      batch.deleteWhere(
        _db.telemetryLogs,
        (t) => t.tripId.equals(tripId),
      );
      batch.deleteWhere(
        _db.routePoints,
        (r) => r.tripId.equals(tripId),
      );
      batch.deleteWhere(
        _db.mediaFiles,
        (m) => m.tripId.equals(tripId),
      );
      batch.deleteWhere(
        _db.trips,
        (t) => t.id.equals(tripId),
      );
    });
  }
}

class TripsDao {
  final AppDatabase _db;
  TripsDao(this._db);

  Future<int> createTrip(TripsCompanion trip) => _db.into(_db.trips).insert(trip);

  Future<void> updateTrip(int id, TripsCompanion updates) =>
      (_db.update(_db.trips)..where((t) => t.id.equals(id))).write(updates);

  Future<Trip?> getTripById(int id) =>
      (_db.select(_db.trips)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Trip>> getMyTrips(String userId) =>
      (_db.select(_db.trips)..where((t) => t.userId.equals(userId))..orderBy([(t) => OrderingTerm.desc(t.startTime)])).get();

  Future<void> deleteTrip(int id) =>
      (_db.delete(_db.trips)..where((t) => t.id.equals(id))).go();

  Future<void> migrateGuestTrips(String toUserId) async {
    await (_db.update(_db.trips)
      ..where((t) => t.userId.equals('guest'))
    ).write(TripsCompanion(userId: Value(toUserId)));
  }
}

class RoutePointsDao {
  final AppDatabase _db;
  RoutePointsDao(this._db);

  Future<int> insertPoint(RoutePointsCompanion point) =>
      _db.into(_db.routePoints).insert(point);

  Future<List<RoutePoint>> getRoutePoints(int tripId) =>
      (_db.select(_db.routePoints)..where((r) => r.tripId.equals(tripId))..orderBy([(r) => OrderingTerm.asc(r.recordedAt)])).get();
}

class TelemetryDao {
  final AppDatabase _db;
  TelemetryDao(this._db);

  Future<void> insertBatch(List<TelemetryLogsCompanion> entries) async {
    await _db.batch((batch) {
      batch.insertAll(_db.telemetryLogs, entries);
    });
  }

  Future<List<TelemetryLog>> getTelemetryLogs(int tripId) =>
      (_db.select(_db.telemetryLogs)..where((t) => t.tripId.equals(tripId))..orderBy([(t) => OrderingTerm.asc(t.recordedAt)])).get();
}

class MediaDao {
  final AppDatabase _db;
  MediaDao(this._db);

  Future<int> insertMedia(MediaFilesCompanion media) =>
      _db.into(_db.mediaFiles).insert(media);

  Future<List<MediaFile>> getMediaByTrip(int tripId) =>
      (_db.select(_db.mediaFiles)..where((m) => m.tripId.equals(tripId))).get();

  Future<void> deleteMedia(int id) =>
      (_db.delete(_db.mediaFiles)..where((m) => m.id.equals(id))).go();
}
