import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/sensor_manager.dart';
import '../../services/trip_session_manager.dart';
import '../../shared/widgets/shared_widgets.dart';
import 'map_controller.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthRepository>();
    if (!auth.isLoggedIn) {
      return LockedFeatureView(
        title: 'Peta Terkunci',
        message: 'Anda harus login untuk mengakses peta.',
        onLogin: () => Get.toNamed(AppRoutes.login),
      );
    }

    final c = Get.find<MapScreenController>();
    final sensors = Get.find<SensorManager>();
    final session = Get.find<TripSessionManager>();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: c.mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(-6.2088, 106.8456),
                    initialZoom: 15,
                    backgroundColor: AppColors.bgSurface,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                    onMapEvent: (e) {
                      if (e is MapEventMoveEnd) {
                        c.zoomLevel.value = e.camera.zoom;
                      }
                      if (e is MapEventMoveStart ||
                          e is MapEventFlingAnimationStart) {
                        c.userInteracting = true;
                      }
                      if (e is MapEventMoveEnd ||
                          e is MapEventFlingAnimationEnd) {
                        Future.delayed(const Duration(seconds: 3), () {
                          c.userInteracting = false;
                        });
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.velo.app',
                    ),
                    Obx(() {
                      final segments = c.routeSegments;
                      if (segments.isEmpty) return const SizedBox.shrink();
                      final polylines = <Polyline>[];
                      for (final seg in segments) {
                        if (seg.length < 2) continue;
                        polylines.add(Polyline(
                          points: List<LatLng>.from(seg),
                          strokeWidth: 4,
                          color: AppColors.amber.withValues(alpha: 0.7),
                        ));
                      }
                      return PolylineLayer(polylines: polylines);
                    }),
                    Obx(() {
                      final markers = c.markers;
                      return MarkerLayer(markers: List<Marker>.from(markers));
                    }),
                  ],
                ),
                // Zoom buttons (right)
                Positioned(
                  bottom: AppDimensions.md,
                  right: AppDimensions.md,
                  child: Column(
                    children: [
                      _ZoomButton(icon: Icons.add, onTap: c.zoomIn),
                      const SizedBox(height: 8),
                      _ZoomButton(icon: Icons.remove, onTap: c.zoomOut),
                      const SizedBox(height: 8),
                      _ZoomButton(
                        icon: Icons.my_location,
                        onTap: () {
                          final data = sensors.telemetry.value;
                          if (data.latitude != null && data.longitude != null) {
                            c.mapController.move(
                              LatLng(data.latitude!, data.longitude!),
                              c.zoomLevel.value,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // Compass & G-force (top-right)
                Positioned(
                  top: AppDimensions.sm,
                  right: AppDimensions.md,
                  child: Obx(() {
                    final data = sensors.telemetry.value;
                    return Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.bgOverlay,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _MapCompass(bearing: data.compassBearing),
                          const SizedBox(height: 6),
                          _MapGForce(gX: data.gForceX, gY: data.gForceY, magnitude: data.gForceMagnitude),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          // Telemetry below map
          Expanded(
            flex: 1,
            child: Obx(() {
              final data = sensors.telemetry.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.sm),
                decoration: const BoxDecoration(
                  color: AppColors.bgSurface,
                  border: Border(
                    top: BorderSide(color: AppColors.border, width: 0.5),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                  children: [
                    Row(
                      children: [
                        _TelemetryItem(label: 'SPD', value: Formatters.speed(data.speedKmh), color: AppColors.textPrimary),
                        const SizedBox(width: AppDimensions.sm),
                        _TelemetryItem(label: 'MAX', value: Formatters.speed(data.maxSpeedKmh), color: AppColors.amber),
                        const SizedBox(width: AppDimensions.sm),
                        _TelemetryItem(label: 'AVG', value: Formatters.speed(data.avgSpeedKmh), color: AppColors.cyan),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      children: [
                        _TelemetryItem(label: 'JARAK', value: Formatters.shortDistance(data.distanceKm), color: AppColors.positive),
                        const SizedBox(width: AppDimensions.sm),
                        _TelemetryItem(label: 'DURASI', value: Formatters.duration(session.elapsed.value), color: AppColors.textPrimary),
                        const SizedBox(width: AppDimensions.sm),
                        _TelemetryItem(label: 'G', value: Formatters.gForce(data.gForceMagnitude), color: AppColors.cyan),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      children: [
                        _TelemetryItem(label: 'G TERTINGGI', value: Formatters.gForce(data.maxGForce), color: AppColors.cyan),
                      ],
                    ),
                  ],
                ),
                  ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TelemetryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TelemetryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          children: [
            Text(label, style: AppTextStyles.monoXxs.copyWith(color: AppColors.amber)),
            const SizedBox(height: 2),
            Text(value,
              style: AppTextStyles.monoMd.copyWith(
                color: color, fontSize: 18, fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapCompass extends StatelessWidget {
  final double bearing;
  const _MapCompass({required this.bearing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(
        painter: _MapCompassPainter(bearing: bearing),
      ),
    );
  }
}

class _MapCompassPainter extends CustomPainter {
  final double bearing;
  _MapCompassPainter({required this.bearing});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    canvas.drawCircle(center, radius, Paint()
      ..color = AppColors.bgOverlay
      ..style = PaintingStyle.fill);
    canvas.drawCircle(center, radius, Paint()
      ..color = AppColors.amber.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);

    // Fixed labels
    const labels = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90 - 90) * 3.14159 / 180;
      final labelR = radius - 10;
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            fontSize: 9,
            fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
            color: i == 0 ? AppColors.amber : AppColors.textSecondary,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(
        center.dx + labelR * cos(angle) - tp.width / 2,
        center.dy + labelR * sin(angle) - tp.height / 2,
      ));
    }

    // Rotating indicator (triangle pointing up)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(bearing * 3.14159 / 180);
    final path = ui.Path()
      ..moveTo(0, -radius + 6)
      ..lineTo(-4, -radius + 14)
      ..lineTo(4, -radius + 14)
      ..close();
    canvas.drawPath(path, Paint()
      ..color = AppColors.amber
      ..style = PaintingStyle.fill);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MapCompassPainter old) => old.bearing != bearing;
}

class _MapGForce extends StatelessWidget {
  final double gX;
  final double gY;
  final double magnitude;
  const _MapGForce({required this.gX, required this.gY, required this.magnitude});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(
        painter: _MapGForcePainter(gX: gX, gY: gY, magnitude: magnitude),
      ),
    );
  }
}

class _MapGForcePainter extends CustomPainter {
  final double gX;
  final double gY;
  final double magnitude;
  _MapGForcePainter({required this.gX, required this.gY, required this.magnitude});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    canvas.drawCircle(center, radius, Paint()
      ..color = AppColors.bgOverlay
      ..style = PaintingStyle.fill);
    canvas.drawCircle(center, radius, Paint()
      ..color = AppColors.cyan.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);

    for (final g in [0.5, 1.0]) {
      final r = radius * (g / 2);
      canvas.drawCircle(center, r, Paint()
        ..color = AppColors.textDisabled
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5);
    }

    final clampedX = (gX / 2).clamp(-1.0, 1.0) * radius;
    final clampedY = (gY / 2).clamp(-1.0, 1.0) * radius;
    final dotPos = Offset(center.dx + clampedX, center.dy - clampedY);

    canvas.drawCircle(dotPos, 3, Paint()..color = AppColors.danger);
    canvas.drawCircle(dotPos, 5, Paint()
      ..color = AppColors.danger.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
  }

  @override
  bool shouldRepaint(covariant _MapGForcePainter old) =>
      old.gX != gX || old.gY != gY || old.magnitude != magnitude;
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgOverlay,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }
}
