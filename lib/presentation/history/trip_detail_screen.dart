import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
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
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Formatters.date(trip.startTime),
                  style: AppTextStyles.subheading),
                const SizedBox(height: AppDimensions.md),
                Row(
                  children: [
                    _statBox('JARAK', '${Formatters.shortDistance(trip.totalDistanceKm)} km', AppColors.positive),
                    const SizedBox(width: AppDimensions.sm),
                    _statBox('MAKS', '${Formatters.speed(trip.maxSpeedKmh)} km/h', AppColors.amber),
                    const SizedBox(width: AppDimensions.sm),
                    _statBox('RATA-RATA', '${Formatters.speed(trip.avgSpeedKmh)} km/h', AppColors.cyan),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    _statBox('DURASI', Formatters.duration(
                      trip.endTime != null
                          ? trip.endTime!.difference(trip.startTime)
                          : Duration.zero,
                    ), AppColors.textPrimary),
                    const SizedBox(width: AppDimensions.sm),
                    _statBox('G-FORCE', '${trip.maxGForce.toStringAsFixed(2)} G', AppColors.danger),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),
                Text('Rute Perjalanan', style: AppTextStyles.subheading),
                const SizedBox(height: AppDimensions.sm),
                SizedBox(
                  height: 250,
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

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.label),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.monoMd.copyWith(color: color)),
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
  final _mapCtrl = MapController();
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

    final bounds = LatLngBounds.fromPoints(_points);
    final center = LatLng(
      (bounds.north + bounds.south) / 2,
      (bounds.east + bounds.west) / 2,
    );
    final zoom = 13.0;

    final polylines = [
      Polyline(
        points: _points,
        strokeWidth: 3,
        color: AppColors.amber.withValues(alpha: 0.8),
      ),
    ];

    final markers = <Marker>[
      Marker(
        point: _points.first,
        width: 24,
        height: 24,
        child: const Icon(Icons.trip_origin, color: AppColors.positive, size: 24),
      ),
      Marker(
        point: _points.last,
        width: 24,
        height: 24,
        child: const Icon(Icons.place, color: AppColors.danger, size: 24),
      ),
    ];

    final maxPts = _routePts
        .where((p) => p.speedKmh > 0)
        .toList()
      ..sort((a, b) => b.speedKmh.compareTo(a.speedKmh));
    if (maxPts.isNotEmpty) {
      final maxPt = maxPts.first;
      markers.add(
        Marker(
          point: LatLng(maxPt.latitude, maxPt.longitude),
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
                  '${maxPt.speedKmh.toStringAsFixed(0)}',
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

    return FlutterMap(
      mapController: _mapCtrl,
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
        backgroundColor: AppColors.bgSurface,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.velo.app',
        ),
        PolylineLayer(polylines: polylines),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
