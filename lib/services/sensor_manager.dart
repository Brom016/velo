import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../domain/models/telemetry_data.dart';

class SensorManager extends GetxService {
  final telemetry = TelemetryData().obs;
  final isRunning = false.obs;
  final isTracking = false.obs;
  final gpsAccuracy = 0.0.obs;

  StreamSubscription<Position>? _gpsSub;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<CompassEvent>? _compassSub;

  double _prevLat = 0;
  double _prevLng = 0;
  double _lastGoodLat = 0;
  double _lastGoodLng = 0;
  bool _hasPrevPos = false;
  bool _hasGoodPos = false;
  DateTime? _startTime;
  DateTime? _lastUpdateTime;
  bool _internalTracking = false;
  int _stationaryCount = 0;
  int _gpsIntervalSec = 2;

  // Weighted position averaging
  double _weightedLat = 0;
  double _weightedLng = 0;
  double _totalWeight = 0;
  static const int _maxWeightedSamples = 5;

  // Adaptive speed smoothing
  double _smoothedSpeed = 0;
  static const double _outlierThreshold = 20.0;
  static const double _rapidChangeThreshold = 4.0;
  static const double _adaptiveAlphaFast = 0.50;
  static const double _adaptiveAlphaSlow = 0.20;

  // GPS quality
  static const double _accuracyThreshold = 20.0;
  static const double _jumpThresholdM = 200.0;
  static const double _stationarySpeed = 2.0;
  static const int _stationaryLockCount = 5;

  // Time throttle - more aggressive when tracking
  DateTime _lastGpsProcessed = DateTime(2000);
  Duration _minGpsInterval = const Duration(milliseconds: 500);

  // Route point callback
  void Function(double lat, double lng, double speedKmh)? onRoutePoint;

  // G-force stabilization
  bool _firstAccel = true;
  double _baselineAccel = 9.81;
  double _smoothG = 0;
  static const double _gAlpha = 0.15;

  @override
  void onReady() {
    super.onReady();
    _loadSettings();
    start();
    resetTripCounters();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _gpsIntervalSec = prefs.getInt('gps_interval') ?? 2;
  }

  @override
  void onClose() {
    _cancelSubscriptions();
    super.onClose();
  }

  Future<void> start() async {
    if (isRunning.value) return;

    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
    } catch (_) {
      return;
    }

    try {
      _gpsSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
          timeLimit: null,
        ),
      ).listen(_onGpsData, onError: (_) {});
    } catch (_) {}

    try {
      _accelSub = accelerometerEventStream(
        samplingPeriod: const Duration(milliseconds: 100),
      ).listen(_onAccelData, onError: (_) {});
    } catch (_) {}

    try {
      _compassSub = FlutterCompass.events?.listen(_onCompassData, onError: (_) {});
    } catch (_) {}

    _startTime = DateTime.now();
    isRunning.value = true;
  }

  void startTracking() {
    _internalTracking = true;
    isTracking.value = true;
    _minGpsInterval = const Duration(milliseconds: 200);
    _weightedLat = 0;
    _weightedLng = 0;
    _totalWeight = 0;
    resetTripCounters();
    _acquireWakeLock();
  }

  void stopTracking() {
    _internalTracking = false;
    isTracking.value = false;
    _minGpsInterval = Duration(seconds: _gpsIntervalSec);
    _weightedLat = 0;
    _weightedLng = 0;
    _totalWeight = 0;
    resetTripCounters();
    _releaseWakeLock();
  }

  void _acquireWakeLock() {
    WakelockPlus.enable();
  }

  void _releaseWakeLock() {
    WakelockPlus.disable();
  }

  void resetTripCounters() {
    _hasPrevPos = false;
    _hasGoodPos = false;
    _startTime = DateTime.now();
    _lastUpdateTime = null;
    _stationaryCount = 0;
    _smoothG = 0;
    _smoothedSpeed = 0;
    final prev = telemetry.value;
    telemetry.value = TelemetryData(
      latitude: prev.latitude,
      longitude: prev.longitude,
    );
  }

  void _onGpsData(Position pos) {
    final now = DateTime.now();
    if (now.difference(_lastGpsProcessed) < _minGpsInterval) return;
    _lastGpsProcessed = now;

    final rawSpeed = pos.speed * 3.6;
    final clamped = rawSpeed < 0 ? 0.0 : rawSpeed;

    gpsAccuracy.value = pos.accuracy;

    if (pos.accuracy > _accuracyThreshold) {
      _prevLat = pos.latitude;
      _prevLng = pos.longitude;
      _hasPrevPos = true;
      _lastUpdateTime = now;
      return;
    }

    if (_hasGoodPos) {
      final jumpDist = Geolocator.distanceBetween(
        _lastGoodLat, _lastGoodLng, pos.latitude, pos.longitude,
      );
      if (jumpDist > _jumpThresholdM && _lastUpdateTime != null) {
        final elapsedSec = now.difference(_lastUpdateTime!).inMilliseconds / 1000.0;
        if (elapsedSec < 8) {
          _prevLat = pos.latitude;
          _prevLng = pos.longitude;
          _hasPrevPos = true;
          _lastUpdateTime = now;
          return;
        }
      }
    }

    final speed = _smoothSpeed(clamped);

    final current = telemetry.value;

    double newDist = current.distanceKm;
    double newMax = current.maxSpeedKmh;
    double newAvg = current.avgSpeedKmh;

    double useLat = pos.latitude;
    double useLng = pos.longitude;

    if (_internalTracking) {
      if (pos.accuracy > 0) {
        final weight = 1.0 / (pos.accuracy * pos.accuracy);
        _weightedLat += pos.latitude * weight;
        _weightedLng += pos.longitude * weight;
        _totalWeight += weight;
        if (_totalWeight > 0 && _totalWeight / weight <= _maxWeightedSamples) {
          useLat = _weightedLat / _totalWeight;
          useLng = _weightedLng / _totalWeight;
        }
        if (_totalWeight / weight > _maxWeightedSamples) {
          _weightedLat = pos.latitude * weight;
          _weightedLng = pos.longitude * weight;
          _totalWeight = weight;
        }
      }

      double distanceDelta = 0;
      if (_hasPrevPos) {
        final rawDelta = Geolocator.distanceBetween(
          _prevLat, _prevLng, useLat, useLng,
        ) / 1000;
        distanceDelta = speed > _stationarySpeed ? rawDelta : 0;
      }
      _prevLat = useLat;
      _prevLng = useLng;
      _hasPrevPos = true;

      newDist = current.distanceKm + distanceDelta;
      newMax = speed > current.maxSpeedKmh ? speed : current.maxSpeedKmh;

      final elapsedHours = _startTime != null
          ? DateTime.now().difference(_startTime!).inMilliseconds / 3600000.0
          : 1;
      newAvg = newDist > 0 && elapsedHours > 0
          ? newDist / elapsedHours
          : current.avgSpeedKmh;
    } else {
      _prevLat = useLat;
      _prevLng = useLng;
      _hasPrevPos = true;
    }

    _lastGoodLat = useLat;
    _lastGoodLng = useLng;
    _hasGoodPos = true;
    _lastUpdateTime = now;

    if (speed < _stationarySpeed) {
      _stationaryCount++;
    } else {
      _stationaryCount = 0;
    }

    final finalLat = _stationaryCount > _stationaryLockCount && _hasGoodPos
        ? _lastGoodLat
        : useLat;
    final finalLng = _stationaryCount > _stationaryLockCount && _hasGoodPos
        ? _lastGoodLng
        : useLng;

    telemetry.value = current.copyWith(
      speedKmh: speed,
      avgSpeedKmh: newAvg,
      maxSpeedKmh: newMax,
      distanceKm: newDist,
      latitude: finalLat,
      longitude: finalLng,
    );

    if (_internalTracking && onRoutePoint != null) {
      onRoutePoint!(useLat, useLng, speed);
    }
  }

  double _smoothSpeed(double rawSpeed) {
    if (_smoothedSpeed == 0) {
      _smoothedSpeed = rawSpeed;
      return rawSpeed;
    }

    final diff = (rawSpeed - _smoothedSpeed).abs();
    if (diff > _outlierThreshold) {
      return _smoothedSpeed;
    }

    final alpha = diff > _rapidChangeThreshold
        ? _adaptiveAlphaFast
        : _adaptiveAlphaSlow;

    _smoothedSpeed = alpha * rawSpeed + (1 - alpha) * _smoothedSpeed;

    return _smoothedSpeed;
  }

  void _onAccelData(AccelerometerEvent event) {
    if (_firstAccel) {
      _baselineAccel = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      _smoothG = 0;
      _firstAccel = false;
    }

    final rawMag = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    _baselineAccel = _baselineAccel * 0.995 + rawMag * 0.005;

    final diffG = (rawMag - _baselineAccel).abs() / 9.81;

    _smoothG = _smoothG * (1 - _gAlpha) + diffG * _gAlpha;

    final gX = _smoothG * 0.5;
    final gY = 0.0;
    final gMag = _smoothG;

    final current = telemetry.value;
    telemetry.value = current.copyWith(
      gForceX: gX,
      gForceY: gY,
      gForceMagnitude: gMag,
      maxGForce: gMag > current.maxGForce ? gMag : current.maxGForce,
    );
  }

  void _onCompassData(CompassEvent event) {
    final h = event.heading;
    if (h == null) return;
    telemetry.value = telemetry.value.copyWith(
      compassBearing: h % 360,
    );
  }

  void pause() {
    _gpsSub?.pause();
    _accelSub?.pause();
    _compassSub?.pause();
    if (_internalTracking) {
      _releaseWakeLock();
    }
  }

  void resume() {
    _gpsSub?.resume();
    _accelSub?.resume();
    _compassSub?.resume();
    if (_internalTracking) {
      _acquireWakeLock();
    }
  }

  void _cancelSubscriptions() {
    _gpsSub?.cancel();
    _gpsSub = null;
    _accelSub?.cancel();
    _accelSub = null;
    _compassSub?.cancel();
    _compassSub = null;
    _hasPrevPos = false;
    _hasGoodPos = false;
    _startTime = null;
    _lastUpdateTime = null;
    _stationaryCount = 0;
    _firstAccel = true;
    _baselineAccel = 9.81;
    _smoothG = 0;
    _smoothedSpeed = 0;
    _weightedLat = 0;
    _weightedLng = 0;
    _totalWeight = 0;
    telemetry.value = TelemetryData();
    isRunning.value = false;
    isTracking.value = false;
    gpsAccuracy.value = 0;
    _releaseWakeLock();
  }

  void stop() {
    _cancelSubscriptions();
  }
}
