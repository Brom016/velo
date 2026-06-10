import 'dart:math';
import 'dart:ui' as ui;
import 'package:camera/camera.dart' as cam;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/sensor_manager.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../../presentation/settings/settings_controller.dart';
import 'camera_controller.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with SingleTickerProviderStateMixin {
  late final CameraController c;
  bool _shutter = false;

  @override
  void initState() {
    super.initState();
    c = Get.find<CameraController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.initCamera();
    });
  }

  void _triggerShutter() {
    setState(() => _shutter = true);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _shutter = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthRepository>();
    if (!auth.isLoggedIn) {
      return LockedFeatureView(
        title: 'Kamera Terkunci',
        message: 'Login diperlukan untuk menggunakan kamera.',
        onLogin: () => Get.toNamed(AppRoutes.login),
      );
    }

    final sensors = Get.find<SensorManager>();

    return SafeArea(
      child: Obx(() {
        final data = sensors.telemetry.value;
        final ov = c.overlay.value;

        if (!c.isInitialized.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.amber),
          );
        }

        return Stack(
          children: [
            cam.CameraPreview(c.camCtrl!),

            // ── Shutter flash ──
            if (_shutter)
              Positioned.fill(
                child: Container(color: Colors.white.withValues(alpha: 0.6)),
              ),

            // ── Top-left telemetry ──
            Positioned(
              top: AppDimensions.md,
              left: AppDimensions.md,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bgPrimary.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(color: AppColors.amber.withValues(alpha: 0.28)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (ov.speed) _animRow('SPD', data.speedKmh, Formatters.speed, AppColors.textPrimary),
                    if (ov.avgSpeed) _animRow('AVG', data.avgSpeedKmh, Formatters.speed, AppColors.cyan),
                    if (ov.maxSpeed) _animRow('MAX', data.maxSpeedKmh, Formatters.speed, AppColors.amber),
                    if (ov.distance) _animRow('DST', data.distanceKm, Formatters.shortDistance, AppColors.positive),
                    if (ov.gps && data.latitude != null)
                      _hudRow('GPS', Formatters.coordinates(data.latitude!, data.longitude!), AppColors.textSecondary, true),
                    if (ov.datetime) _hudRow('TIME', Formatters.time(DateTime.now())),
                  ],
                ),
              ),
            ),

            // ── Top-right: compass & G-force ──
            if (ov.compass || ov.gforce)
              Positioned(
                top: AppDimensions.md,
                right: AppDimensions.md,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.bgPrimary.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    border: Border.all(color: AppColors.amber.withValues(alpha: 0.28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (ov.gforce) ...[
                        _cameraGforce(data.gForceX, data.gForceY),
                        const SizedBox(height: 4),
                      ],
                      if (ov.compass) ...[
                        _cameraCompass(data.compassBearing),
                      ],
                    ],
                  ),
                ),
              ),

            // ── Mini-map (bottom-right) ──
            if (ov.miniMap && data.latitude != null && data.longitude != null)
              Positioned(
                bottom: 100,
                right: AppDimensions.md,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  child: Opacity(
                    opacity: Get.find<SettingsController>().miniMapOpacity.value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.amber.withValues(alpha: 0.28)),
                      ),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(data.latitude!, data.longitude!),
                          initialZoom: 15,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.velo.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(data.latitude!, data.longitude!),
                                width: 20,
                                height: 20,
                                child: const Icon(Icons.navigation, color: AppColors.amber, size: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ── Bottom controls ──
            Positioned(
              bottom: AppDimensions.lg,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Recording indicator
                  Obx(() {
                    if (!c.isRecording.value) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('REC', style: AppTextStyles.monoXs.copyWith(color: Colors.white)),
                        ],
                      ),
                    );
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mode toggle
                      GestureDetector(
                        onTap: c.toggleMode,
                        child: Container(
                          width: 44,
                          height: 44,
                          margin: const EdgeInsets.only(right: 24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.bgOverlay,
                            border: Border.all(color: AppColors.textSecondary),
                          ),
                          child: Obx(() => Icon(
                            c.mode.value == CameraMode.photo ? Icons.videocam : Icons.camera_alt,
                            color: AppColors.textPrimary, size: 20,
                          )),
                        ),
                      ),
                      // Capture button
                      GestureDetector(
                        onTap: () async {
                          if (c.mode.value == CameraMode.photo) {
                            _triggerShutter();
                          }
                          await c.capture();
                        },
                        child: Container(
                          width: c.isRecording.value ? 64 : 70,
                          height: c.isRecording.value ? 64 : 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: c.isRecording.value ? AppColors.danger : AppColors.amber,
                              width: c.isRecording.value ? 3 : 2.5,
                            ),
                          ),
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: c.isRecording.value ? 28 : 56,
                              height: c.isRecording.value ? 28 : 56,
                              decoration: BoxDecoration(
                                color: c.isRecording.value ? AppColors.danger : AppColors.amber,
                                borderRadius: BorderRadius.circular(
                                  c.isRecording.value ? 6 : 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Spacer for symmetry
                      const SizedBox(width: 68),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _hudRow(String label, String value, [Color? valColor, bool small = false]) {
    final s = AppSizing.scale(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1 * s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (valColor == null || !small) ...[
            Text(label, style: AppTextStyles.monoXxs.copyWith(
              color: AppColors.amber, fontSize: 9 * s)),
            SizedBox(width: 5 * s),
          ],
          Text(value,
            style: small
                ? AppTextStyles.monoXxs.copyWith(
                    fontSize: 9 * s, color: valColor ?? AppColors.textPrimary)
                : AppTextStyles.monoSm.copyWith(
                    fontSize: 11 * s, color: valColor ?? AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _animRow(String label, double value, String Function(double) format, Color color) {
    final s = AppSizing.scale(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1 * s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.monoXxs.copyWith(
            color: AppColors.amber, fontSize: 9 * s)),
          SizedBox(width: 5 * s),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: child,
            ),
            child: Text(
              format(value),
              key: ValueKey('$label-${value.toStringAsFixed(1)}'),
              style: AppTextStyles.monoSm.copyWith(
                fontSize: 11 * s, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cameraCompass(double bearing) {
    final s = AppSizing.scale(context);
    final size = (76 * s).clamp(60.0, 120.0);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CameraCompassPainter(bearing: bearing),
      ),
    );
  }

  Widget _cameraGforce(double gX, double gY) {
    final s = AppSizing.scale(context);
    final size = (76 * s).clamp(60.0, 120.0);
    final mag = sqrt(gX * gX + gY * gY);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CameraGForcePainter(gX: gX, gY: gY, magnitude: mag),
      ),
    );
  }
}

class _CameraCompassPainter extends CustomPainter {
  final double bearing;
  _CameraCompassPainter({required this.bearing});

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
      final labelR = radius - 12;
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            fontSize: 11,
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

    // Rotating triangle indicator
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(bearing * 3.14159 / 180);
    final path = ui.Path()
      ..moveTo(0, -radius + 6)
      ..lineTo(-5, -radius + 16)
      ..lineTo(5, -radius + 16)
      ..close();
    canvas.drawPath(path, Paint()
      ..color = AppColors.amber
      ..style = PaintingStyle.fill);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CameraCompassPainter old) => old.bearing != bearing;
}

class _CameraGForcePainter extends CustomPainter {
  final double gX;
  final double gY;
  final double magnitude;
  _CameraGForcePainter({required this.gX, required this.gY, required this.magnitude});

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
  bool shouldRepaint(covariant _CameraGForcePainter old) =>
      old.gX != gX || old.gY != gY || old.magnitude != magnitude;
}
