import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../services/sensor_manager.dart';
import '../../services/trip_session_manager.dart';
import '../../shared/widgets/velo_button.dart';
import 'dashboard_controller.dart';
import 'widgets/dashboard_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DashboardController>();
    final sensors = Get.find<SensorManager>();
    final session = Get.find<TripSessionManager>();

    return SafeArea(
      child: Obx(() {
        final data = sensors.telemetry.value;
        final tripStatus = session.status.value;
        final isRecording = tripStatus == TripStatus.active ||
            tripStatus == TripStatus.paused;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppDimensions.md, AppDimensions.sm, AppDimensions.md, 0),
              child:               Row(
                children: [
                  Text('VELO', style: AppTextStyles.monoMd.copyWith(
                    color: AppColors.amber, letterSpacing: 4, fontSize: 18,
                  )),
                  if (isRecording) ...[
                    const Spacer(),
                    Text(
                      Formatters.duration(session.elapsed.value),
                      style: AppTextStyles.monoMd.copyWith(
                          color: AppColors.textPrimary, fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                child: Column(
                  children: [
                    SpeedometerGauge(
                      speed: data.speedKmh,
                      maxScale: 200,
                      size: 220,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            label: 'RATA-RATA',
                            value: Formatters.speed(data.avgSpeedKmh),
                            unit: 'km/h',
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Expanded(
                          child: MetricCard(
                            label: 'TERTINGGI',
                            value: Formatters.speed(data.maxSpeedKmh),
                            unit: 'km/h',
                            valueColor: AppColors.amber,
                          ),
                        ),
                        Expanded(
                          child: MetricCard(
                            label: 'JARAK',
                            value: Formatters.shortDistance(data.distanceKm),
                            unit: 'km',
                            valueColor: AppColors.positive,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Expanded(
                          child: MetricCard(
                            label: 'G TERTINGGI',
                            value: Formatters.gForce(data.maxGForce),
                            unit: 'G',
                            valueColor: AppColors.cyan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.cardPadding),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                              border: Border.all(color: AppColors.border, width: 0.5),
                            ),
                            child: CompassIndicator(
                              bearing: data.compassBearing,
                              size: 100,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.cardPadding),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                              border: Border.all(color: AppColors.border, width: 0.5),
                            ),
                            child: GForceIndicator(
                              gX: data.gForceX,
                              gY: data.gForceY,
                              magnitude: data.gForceMagnitude,
                              size: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    if (tripStatus == TripStatus.idle)
                      Obx(() => VeloButton(
                        label: 'MULAI',
                        icon: Icons.play_arrow,
                        loading: c.startLoading.value,
                        onPressed: c.onStartPressed,
                      ))
                    else ...[
                      Row(
                        children: [
                          Expanded(
                            child: VeloButton(
                              label: tripStatus == TripStatus.paused
                                  ? 'LANJUTKAN' : 'JEDA',
                              icon: tripStatus == TripStatus.paused
                                  ? Icons.play_arrow : Icons.pause,
                              style: tripStatus == TripStatus.paused
                                  ? VeloButtonStyle.primary
                                  : VeloButtonStyle.outline,
                              onPressed: c.onPausePressed,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          Expanded(
                            child: VeloButton(
                              label: 'BERHENTI',
                              icon: Icons.stop,
                              style: VeloButtonStyle.danger,
                              onPressed: c.onStopPressed,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppDimensions.lg),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
