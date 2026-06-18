import 'dart:async';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart' show Value;
import '../data/local/database/app_database.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/trip_repository.dart';
import 'sensor_manager.dart';
import 'foreground_service.dart';
import '../data/remote/firebase/firestore_service.dart';
import '../presentation/map/map_controller.dart';

enum TripStatus { idle, active, paused, finished }

class TripSessionManager extends GetxService {
  final SensorManager _sensors = Get.find<SensorManager>();
  final TripRepository _tripRepo = Get.find<TripRepository>();
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final status = TripStatus.idle.obs;
  final currentId = Rxn<int>();
  final elapsed = const Duration().obs;

  Timer? _batchTimer;
  Timer? _clockTimer;
  final List<TelemetryLogsCompanion> _pending = [];

  @override
  void onClose() {
    _stopTimers();
    super.onClose();
  }

  Future<void> start() async {
    await _sensors.start();
    final tripId = await _tripRepo.createTrip(
      TripsCompanion(
        userId: Value(_authRepo.uid),
        startTime: Value(DateTime.now()),
      ),
    );

    currentId.value = tripId;
    _sensors.startTracking();
    await ForegroundService.start();
    final mapCtrl = Get.find<MapScreenController>();
    mapCtrl.clearRoute();
    mapCtrl.resetHighestSpeed();
    status.value = TripStatus.active;
    _startTimers();
  }

  Future<void> pause() async {
    _stopTimers();
    _sensors.pause();
    await ForegroundService.stop();
    await _flush();
    await _tripRepo.updateTripStatus(currentId.value!, 'paused');
    status.value = TripStatus.paused;
  }

  Future<void> resume() async {
    _sensors.resume();
    await ForegroundService.start();
    _startTimers();
    await _tripRepo.updateTripStatus(currentId.value!, 'active');
    status.value = TripStatus.active;
  }

  Future<void> stop() async {
    _stopTimers();
    await _flush();
    await ForegroundService.stop();

    final data = _sensors.telemetry.value;
    final tripId = currentId.value!;
    await _tripRepo.finishTrip(
      tripId,
      totalDistanceKm: data.distanceKm,
      maxSpeedKmh: data.maxSpeedKmh,
      avgSpeedKmh: data.avgSpeedKmh,
      maxGForce: data.maxGForce,
    );

    final uid = _authRepo.uid;
    if (uid != 'guest') {
      final trip = await _tripRepo.getTripById(tripId);
      if (trip != null) {
        await _tripRepo.syncTripToFirestore(trip, uid);
        final points = await _tripRepo.getRoutePoints(tripId);
        await _tripRepo.syncRoutePointsToFirestore(tripId, points, uid);
        final durationSec = trip.endTime != null
            ? trip.endTime!.difference(trip.startTime).inSeconds
            : 0;
        await FirestoreService().updateStats(
          uid: uid,
          distanceKm: data.distanceKm,
          durationSeconds: durationSec,
        );
      }
    }

    _sensors.stopTracking();
    _sensors.onRoutePoint = null;
    currentId.value = null;
    elapsed.value = Duration.zero;
    status.value = TripStatus.idle;
  }

  void _startTimers() {
    _batchTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      _enqueue();
    });
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsed.value = elapsed.value + const Duration(seconds: 1);
    });
  }

  void _stopTimers() {
    _batchTimer?.cancel();
    _batchTimer = null;
    _clockTimer?.cancel();
    _clockTimer = null;
  }

  void _enqueue() {
    final data = _sensors.telemetry.value;
    _pending.add(
      TelemetryLogsCompanion(
        tripId: Value(currentId.value!),
        speedKmh: Value(data.speedKmh),
        avgSpeedKmh: Value(data.avgSpeedKmh),
        maxSpeedKmh: Value(data.maxSpeedKmh),
        distanceKm: Value(data.distanceKm),
        gForceX: Value(data.gForceX),
        gForceY: Value(data.gForceY),
        gForceMagnitude: Value(data.gForceMagnitude),
        compassBearing: Value(data.compassBearing),
        latitude: Value(data.latitude),
        longitude: Value(data.longitude),
        recordedAt: Value(DateTime.now()),
      ),
    );

    if (data.latitude != null && data.longitude != null) {
      _tripRepo.addRoutePoint(
        tripId: currentId.value!,
        latitude: data.latitude!,
        longitude: data.longitude!,
        speedKmh: data.speedKmh,
      );
    }
  }

  Future<void> _flush() async {
    if (_pending.isEmpty) return;
    final batch = List<TelemetryLogsCompanion>.from(_pending);
    _pending.clear();
    await _tripRepo.saveTelemetryBatch(batch);
  }
}

