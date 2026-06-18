import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/telemetry_data.dart';
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
  static const double _gapThresholdSec = 8.0;
  static const double _routeMinDistM = 0.8;
  static const double _mapMoveDistM = 10.0;
  static const double _stationarySpeed = 3.0;

  GoogleMapController? mapController;
  final hasLocation = false.obs;
  final zoomLevel = _defaultZoom.obs;
  final routeSegments = <List<LatLng>>[].obs;
  bool userInteracting = false;

  LatLng? _currentPosition;
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

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void zoomIn() {
    zoomLevel.value = (zoomLevel.value + 1).clamp(3.0, 20.0);
    _moveCamera();
  }

  void zoomOut() {
    zoomLevel.value = (zoomLevel.value - 1).clamp(3.0, 20.0);
    _moveCamera();
  }

  void _moveCamera() {
    final pos = _currentPosition ?? const LatLng(_defaultLat, _defaultLng);
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(pos, zoomLevel.value),
    );
  }

  Set<Marker> buildMarkers() {
    final result = <Marker>{};
    if (_currentPosition == null) return result;

    result.add(Marker(
      markerId: const MarkerId('current'),
      position: _currentPosition!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ));

    if (_highestSpeedPoint != null && _highestSpeed > 0) {
      result.add(Marker(
        markerId: const MarkerId('highest'),
        position: _highestSpeedPoint!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: '${_highestSpeed.toStringAsFixed(0)} km/h',
        ),
      ));
    }

    return result;
  }

  Set<Polyline> buildPolylines() {
    final result = <Polyline>{};
    for (int i = 0; i < routeSegments.length; i++) {
      final seg = routeSegments[i];
      if (seg.length < 2) continue;
      result.add(Polyline(
        polylineId: PolylineId('route_$i'),
        points: seg,
        width: 4,
        color: AppColors.amber.withValues(alpha: 0.7),
      ));
    }
    return result;
  }

  void _initPosition() {
    final telemetry = _sensors.telemetry.value;
    if (telemetry.latitude != null && telemetry.longitude != null) {
      _currentPosition = LatLng(telemetry.latitude!, telemetry.longitude!);
      hasLocation.value = true;
    }
  }

  void _listenToSensors() {
    ever(_sensors.telemetry, (TelemetryData data) {
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

  void clearRoute() {
    routeSegments.clear();
    _lastPointTime = null;
    _lastRoutePoint = null;
    _lastMapCenter = null;
    _highestSpeed = 0;
    _highestSpeedPoint = null;
  }

  void _updatePosition(double lat, double lng) {
    final pos = LatLng(lat, lng);
    _currentPosition = pos;
    hasLocation.value = true;

    final currentSpeed = _sensors.telemetry.value.speedKmh;

    if (currentSpeed > _highestSpeed + _speedTolerance) {
      _highestSpeed = currentSpeed;
      _highestSpeedPoint = pos;
    }

    if (!userInteracting) {
      final isStationary = currentSpeed < _stationarySpeed;
      final shouldMoveMap = !isStationary || _lastMapCenter == null ||
          Geolocator.distanceBetween(
            _lastMapCenter!.latitude, _lastMapCenter!.longitude,
            lat, lng,
          ) > _mapMoveDistM;

      if (shouldMoveMap) {
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(pos, zoomLevel.value),
        );
        _lastMapCenter = pos;
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

  void centerOnCurrentLocation() {
    if (_currentPosition != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, zoomLevel.value),
      );
    }
  }
}
