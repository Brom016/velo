import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_colors.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/sensor_manager.dart';
import '../../services/trip_session_manager.dart';

class MapScreenController extends GetxController {
  final SensorManager _sensors = Get.find<SensorManager>();
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  final TripSessionManager _session = Get.find<TripSessionManager>();

  static const _defaultLat = -6.2088;
  static const _defaultLng = 106.8456;
  static const _defaultZoom = 15.0;
  static const double _speedTolerance = 5.0;
  static const double _gapThresholdSec = 10.0;
  static const double _routeMinDistM = 2.0;
  static const double _mapMoveDistM = 10.0;
  static const double _stationarySpeed = 3.0;

  final mapController = MapController();
  final markers = <Marker>[].obs;
  final routeSegments = <List<LatLng>>[].obs;
  final hasLocation = false.obs;
  final zoomLevel = _defaultZoom.obs;
  bool userInteracting = false;

  double _highestSpeed = 0;
  LatLng? _highestSpeedPoint;
  LatLng? _lastRoutePoint;
  LatLng? _lastMapCenter;
  DateTime? _lastPointTime;

  bool get isLoggedIn => _authRepo.isLoggedIn;

  @override
  void onInit() {
    super.onInit();
    _initPosition();
    _listenToSensors();
    _setupRouteCallback();
  }

  void _setupRouteCallback() {
    _sensors.onRoutePoint = (lat, lng, speedKmh) {
      if (_session.status.value != TripStatus.active) return;
      _addRoutePoint(lat, lng);
    };
  }

  void zoomIn() {
    zoomLevel.value = (zoomLevel.value + 1).clamp(3.0, 20.0);
    mapController.move(mapController.camera.center, zoomLevel.value);
  }

  void zoomOut() {
    zoomLevel.value = (zoomLevel.value - 1).clamp(3.0, 20.0);
    mapController.move(mapController.camera.center, zoomLevel.value);
  }

  void _initPosition() {
    final telemetry = _sensors.telemetry.value;
    if (telemetry.latitude != null && telemetry.longitude != null) {
      _updatePosition(telemetry.latitude!, telemetry.longitude!);
    } else {
      final fallback = LatLng(_defaultLat, _defaultLng);
      markers.value = [
        Marker(
          point: fallback,
          width: 40,
          height: 40,
          child: const Icon(Icons.navigation, color: AppColors.amber, size: 36),
        ),
      ];
    }
  }

  void _listenToSensors() {
    ever(_sensors.telemetry, (data) {
      if (data.latitude != null && data.longitude != null) {
        _updatePosition(data.latitude!, data.longitude!);
      }
    });
  }

  void resetHighestSpeed() {
    _highestSpeed = 0;
    _highestSpeedPoint = null;
    _lastPointTime = null;
    _lastRoutePoint = null;
    _lastMapCenter = null;
  }

  void _updatePosition(double lat, double lng) {
    final pos = LatLng(lat, lng);
    hasLocation.value = true;

    final currentSpeed = _sensors.telemetry.value.speedKmh;

    if (currentSpeed > _highestSpeed + _speedTolerance) {
      _highestSpeed = currentSpeed;
      _highestSpeedPoint = pos;
    }

    final result = <Marker>[
      Marker(
        point: pos,
        width: 40,
        height: 40,
        child: const Icon(
          Icons.navigation,
          color: AppColors.amber,
          size: 36,
        ),
      ),
    ];

    if (_highestSpeedPoint != null && _highestSpeed > 0) {
      result.add(
        Marker(
          point: _highestSpeedPoint!,
          width: 32,
          height: 38,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '${_highestSpeed.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.location_on, color: AppColors.danger, size: 22),
            ],
          ),
        ),
      );
    }

    markers.value = result;

    if (!userInteracting) {
      final isStationary = currentSpeed < _stationarySpeed;
      final shouldMoveMap = !isStationary || _lastMapCenter == null ||
          Geolocator.distanceBetween(
            _lastMapCenter!.latitude, _lastMapCenter!.longitude,
            lat, lng,
          ) > _mapMoveDistM;

      if (shouldMoveMap) {
        try {
          mapController.move(pos, zoomLevel.value);
          _lastMapCenter = pos;
        } catch (_) {
          Future.delayed(const Duration(milliseconds: 200), () {
            try { mapController.move(pos, zoomLevel.value); } catch (_) {}
          });
        }
      }
    }
  }

  void _addRoutePoint(double lat, double lng) {
    final pos = LatLng(lat, lng);
    final now = DateTime.now();
    final hasGap = _lastPointTime != null &&
        now.difference(_lastPointTime!).inSeconds > _gapThresholdSec;
    _lastPointTime = now;

    final shouldAdd = _lastRoutePoint == null ||
        Geolocator.distanceBetween(
          _lastRoutePoint!.latitude, _lastRoutePoint!.longitude,
          lat, lng,
        ) > _routeMinDistM;

    if (shouldAdd) {
      if (routeSegments.isEmpty || hasGap) {
        routeSegments.add([pos]);
      } else {
        routeSegments.last.add(pos);
      }
      _lastRoutePoint = pos;
      routeSegments.refresh();
    }
  }

  void clearRoute() {
    routeSegments.clear();
    _lastPointTime = null;
    _lastRoutePoint = null;
    _lastMapCenter = null;
    _highestSpeed = 0;
    _highestSpeedPoint = null;
  }
}
