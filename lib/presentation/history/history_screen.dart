import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_sizing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/local/database/app_database.dart';
import 'history_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HistoryController());

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSizing.spacing(context, 14)),
            child: Text('Riwayat Perjalanan', style: AppTextStyles.heading),
          ),
          Expanded(
            child: Obx(() {
              if (c.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.amber),
                );
              }
              if (c.trips.isEmpty) {
                return Center(
                  child: Text('Belum ada perjalanan',
                    style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary)),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizing.spacing(context, 14)),
                itemCount: c.trips.length,
                itemBuilder: (_, i) {
                  final trip = c.trips[i];
                  return _TripCard(trip: trip, onTap: () => c.openTripDetail(trip.id));
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const _TripCard({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = AppSizing.scale(context);
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizing.spacing(context, 8)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppSizing.cardPadding(context)),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 44 * s,
                padding: EdgeInsets.symmetric(vertical: 5 * s),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Column(
                  children: [
                    Text('${trip.startTime.day}',
                      style: AppTextStyles.monoMd.copyWith(
                          color: AppColors.amber, fontSize: 14 * s)),
                    Text(Formatters.date(trip.startTime).split(' ')[1],
                      style: AppTextStyles.monoXs),
                  ],
                ),
              ),
              SizedBox(width: AppSizing.spacing(context, 8)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Formatters.date(trip.startTime),
                      style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500)),
                    SizedBox(height: 3 * s),
                    Row(
                      children: [
                        _stat(context, Formatters.shortDistance(trip.totalDistanceKm), 'km', s),
                        SizedBox(width: 10 * s),
                        _stat(context, Formatters.speed(trip.maxSpeedKmh), 'maks', s),
                        SizedBox(width: 10 * s),
                        _stat(context,
                          trip.endTime != null
                              ? Formatters.duration(
                                  trip.endTime!.difference(trip.startTime))
                              : '--',
                          'durasi', s),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20 * s),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label, double s) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
          style: AppTextStyles.monoXs.copyWith(
            color: AppColors.cyan, fontSize: 10 * s)),
        SizedBox(width: 2 * s),
        Text(label, style: AppTextStyles.label),
      ],
    );
  }
}
