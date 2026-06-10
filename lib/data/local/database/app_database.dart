import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

class Trips extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn? get endTime => dateTime().nullable()();
  RealColumn get totalDistanceKm => real().withDefault(const Constant(0))();
  RealColumn get maxSpeedKmh => real().withDefault(const Constant(0))();
  RealColumn get avgSpeedKmh => real().withDefault(const Constant(0))();
  RealColumn get maxGForce => real().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('active'))();
}

class RoutePoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer().references(Trips, #id)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get speedKmh => real().withDefault(const Constant(0))();
  DateTimeColumn get recordedAt => dateTime()();
}

class TelemetryLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer().references(Trips, #id)();
  RealColumn get speedKmh => real()();
  RealColumn get avgSpeedKmh => real()();
  RealColumn get maxSpeedKmh => real()();
  RealColumn get distanceKm => real()();
  RealColumn get gForceX => real()();
  RealColumn get gForceY => real()();
  RealColumn get gForceMagnitude => real()();
  RealColumn get compassBearing => real()();
  RealColumn? get latitude => real().nullable()();
  RealColumn? get longitude => real().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
}

class MediaFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer().references(Trips, #id)();
  TextColumn get type => text()();
  TextColumn get filePath => text()();
  TextColumn? get thumbnailPath => text().nullable()();
  TextColumn? get overlayConfig => text().nullable()();
  DateTimeColumn get capturedAt => dateTime()();
}

@DriftDatabase(tables: [Trips, RoutePoints, TelemetryLogs, MediaFiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    await _ensureExtension();
    final dbPath = p.join(dbDir.path, 'velo.db');
    return NativeDatabase(File(dbPath));
  });
}

Future<void> _ensureExtension() async {
  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
  }
}
