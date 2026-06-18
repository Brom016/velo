import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_sizing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/local/database/app_database.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/trip_repository.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tripId = Get.arguments as int;
    final tripRepo = Get.find<TripRepository>();

    return FutureBuilder<Trip?>(
      future: tripRepo.getTripById(tripId),
      builder: (_, snap) {
        final trip = snap.data;
        if (trip == null) {
          return Scaffold(
            backgroundColor: AppColors.bgPrimary,
            appBar: AppBar(title: const Text('Detail')),
            body: const Center(child: Text('Data tidak ditemukan')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          appBar: AppBar(
            title: const Text('Detail Perjalanan'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.amber),
              onPressed: () => Get.back(),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizing.spacing(context, 14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Formatters.date(trip.startTime),
                  style: AppTextStyles.subheading),
                SizedBox(height: AppSizing.spacing(context, 14)),
                Row(
                  children: [
                    _statBox(context, 'JARAK', '${Formatters.shortDistance(trip.totalDistanceKm)} km', AppColors.positive),
                    SizedBox(width: AppSizing.spacing(context, 8)),
                    _statBox(context, 'MAKS', '${Formatters.speed(trip.maxSpeedKmh)} km/h', AppColors.amber),
                    SizedBox(width: AppSizing.spacing(context, 8)),
                    _statBox(context, 'RATA-RATA', '${Formatters.speed(trip.avgSpeedKmh)} km/h', AppColors.cyan),
                  ],
                ),
                SizedBox(height: AppSizing.spacing(context, 8)),
                Row(
                  children: [
                    _statBox(context, 'DURASI', Formatters.duration(
                      trip.endTime != null
                          ? trip.endTime!.difference(trip.startTime)
                          : Duration.zero,
                    ), AppColors.textPrimary),
                    SizedBox(width: AppSizing.spacing(context, 8)),
                    _statBox(context, 'G-FORCE', '${trip.maxGForce.toStringAsFixed(2)} G', AppColors.danger),
                  ],
                ),
                SizedBox(height: AppSizing.spacing(context, 20)),
                Text('Rute Perjalanan', style: AppTextStyles.subheading),
                SizedBox(height: AppSizing.spacing(context, 8)),
                SizedBox(
                  height: AppSizing.spacing(context, 220).clamp(180, 350),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    child: _RouteMap(tripId: tripId),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statBox(BuildContext context, String label, String value, Color color) {
    final s = AppSizing.scale(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppSizing.cardPadding(context)),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.label),
            SizedBox(height: 3 * s),
            Text(value, style: AppTextStyles.monoMd.copyWith(
              color: color, fontSize: 16 * s)),
          ],
        ),
      ),
    );
  }
}

class _RouteMap extends StatefulWidget {
  final int tripId;
  const _RouteMap({required this.tripId});

  @override
  State<_RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<_RouteMap> {
  GoogleMapController? _mapCtrl;
  List<LatLng> _points = [];
  List<RoutePoint> _routePts = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    final repo = Get.find<TripRepository>();
    final auth = Get.find<AuthRepository>();
    List<RoutePoint> pts = await repo.getRoutePoints(widget.tripId);
    if (pts.isEmpty && auth.uid != 'guest') {
      pts = await repo.getRoutePointsFromFirestore(widget.tripId, auth.uid);
    }
    if (!mounted) return;
    setState(() {
      _routePts = pts;
      _points = pts
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();
      _loaded = true;
    });
  }

  LatLngBounds _boundsFromPoints(List<LatLng> pts) {
    double? minLat, maxLat, minLng, maxLng;
    for (final p in pts) {
      minLat = minLat == null ? p.latitude : min(minLat, p.latitude);
      maxLat = maxLat == null ? p.latitude : max(maxLat, p.latitude);
      minLng = minLng == null ? p.longitude : min(minLng, p.longitude);
      maxLng = maxLng == null ? p.longitude : max(maxLng, p.longitude);
    }
    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  Set<Marker> _buildMarkers() {
    if (_points.isEmpty) return {};
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('start'),
        position: _points.first,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('end'),
        position: _points.last,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    final maxPts = _routePts
        .where((p) => p.speedKmh > 0)
        .toList()
      ..sort((a, b) => b.speedKmh.compareTo(a.speedKmh));
    if (maxPts.isNotEmpty) {
      final maxPt = maxPts.first;
      markers.add(Marker(
        markerId: const MarkerId('highest'),
        position: LatLng(maxPt.latitude, maxPt.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: '${maxPt.speedKmh.toStringAsFixed(0)} km/h',
        ),
      ));
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (_points.length < 2) return {};
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: _points,
        width: 3,
        color: AppColors.amber.withValues(alpha: 0.8),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Center(child: CircularProgressIndicator(color: AppColors.amber));
    }

    if (_points.isEmpty) {
      return Container(
        color: AppColors.bgSurface,
        child: Center(
          child: Text('Tidak ada data rute', style: AppTextStyles.body),
        ),
      );
    }

    final bounds = _boundsFromPoints(_points);
    final center = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
      (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: center, zoom: 13),
      onMapCreated: (ctrl) => _mapCtrl = ctrl,
      markers: _buildMarkers(),
      polylines: _buildPolylines(),
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      mapType: MapType.normal,
      onCameraIdle: () {
        _mapCtrl?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      },
    );
  }
}
