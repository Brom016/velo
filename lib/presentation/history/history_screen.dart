import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
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
            padding: const EdgeInsets.all(AppDimensions.md),
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
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                itemCount: c.trips.length,
                itemBuilder: (_, i) {
                  final trip = c.trips[i];
                  return _TripCard(
                    trip: trip,
                    onTap: () => c.openTripDetail(trip.id),
                  );
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Column(
                  children: [
                    Text('${trip.startTime.day}',
                      style: AppTextStyles.monoMd.copyWith(
                          color: AppColors.amber, fontSize: 16)),
                    Text(Formatters.date(trip.startTime).split(' ')[1],
                      style: AppTextStyles.monoXs),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Formatters.date(trip.startTime),
                      style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _stat(Formatters.shortDistance(trip.totalDistanceKm), 'km'),
                        const SizedBox(width: 12),
                        _stat(Formatters.speed(trip.maxSpeedKmh), 'maks'),
                        const SizedBox(width: 12),
                        _stat(
                          trip.endTime != null
                              ? Formatters.duration(
                                  trip.endTime!.difference(trip.startTime))
                              : '--',
                          'durasi',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
          style: AppTextStyles.monoXs.copyWith(color: AppColors.cyan)),
        const SizedBox(width: 2),
        Text(label, style: AppTextStyles.label),
      ],
    );
  }
}
