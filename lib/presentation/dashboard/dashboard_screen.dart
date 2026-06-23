import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_sizing.dart';
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
    final s = AppSizing.scale(context);

    return SafeArea(
      child: Obx(() {
        final data = sensors.telemetry.value;
        final tripStatus = session.status.value;
        final isRecording = tripStatus == TripStatus.active ||
            tripStatus == TripStatus.paused;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSizing.spacing(context, 12), 6, AppSizing.spacing(context, 12), 0),
              child: Row(
                children: [
                  Text('VELO', style: AppTextStyles.monoMd.copyWith(
                    color: AppColors.amber, letterSpacing: 4, fontSize: 16 * s,
                  )),
                  if (isRecording) ...[
                    const Spacer(),
                    Text(
                      Formatters.duration(session.elapsed.value),
                      style: AppTextStyles.monoMd.copyWith(
                          color: AppColors.textPrimary, fontSize: 14 * s),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 4 * s),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: SpeedometerGauge(
                    speed: data.speedKmh,
                    maxScale: 200,
                    size: AppSizing.speedometerSize(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizing.spacing(context, 12)),
              child: SingleChildScrollView(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 6 * s,
                    runSpacing: 6 * s,
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 24 * s - 24) / 2 - 3 * s,
                        child: MetricCard(
                          label: 'RATA-RATA',
                          value: Formatters.speed(data.avgSpeedKmh),
                          unit: 'km/h',
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 24 * s - 24) / 2 - 3 * s,
                        child: MetricCard(
                          label: 'TERTINGGI',
                          value: Formatters.speed(data.maxSpeedKmh),
                          unit: 'km/h',
                          valueColor: AppColors.amber,
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 24 * s - 24) / 2 - 3 * s,
                        child: MetricCard(
                          label: 'JARAK',
                          value: Formatters.shortDistance(data.distanceKm),
                          unit: 'km',
                          valueColor: AppColors.positive,
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 24 * s - 24) / 2 - 3 * s,
                        child: MetricCard(
                          label: 'G TERTINGGI',
                          value: Formatters.gForce(data.maxGForce),
                          unit: 'G',
                          valueColor: AppColors.cyan,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8 * s),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(AppSizing.cardPadding(context)),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                            border: Border.all(color: AppColors.border, width: 0.5),
                          ),
                          child: CompassIndicator(
                            bearing: data.compassBearing,
                            size: AppSizing.indicatorSize(context),
                          ),
                        ),
                      ),
                      SizedBox(width: 8 * s),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(AppSizing.cardPadding(context)),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                            border: Border.all(color: AppColors.border, width: 0.5),
                          ),
                          child: GForceIndicator(
                            gX: data.gForceX,
                            gY: data.gForceY,
                            magnitude: data.gForceMagnitude,
                            size: AppSizing.indicatorSize(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12 * s),
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
                        SizedBox(width: 8 * s),
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
                  SizedBox(height: 12 * s),
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
