import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/remote/firebase/auth_service.dart';
import '../../shared/widgets/velo_button.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();

    return SafeArea(
      child: Obx(() {
        final user = c.user.value;
        if (user == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_outline,
                    size: 64, color: AppColors.textSecondary),
                const SizedBox(height: AppDimensions.md),
                Text('Belum masuk', style: AppTextStyles.heading),
                const SizedBox(height: AppDimensions.sm),
                Text('Masuk untuk melihat profil',
                    style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary)),
                const SizedBox(height: AppDimensions.lg),
                VeloButton(
                  label: 'MASUK',
                  width: 200,
                  onPressed: () => Get.toNamed(AppRoutes.login),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.md),
              _buildAvatar(c, user),
              const SizedBox(height: AppDimensions.sm),
              Text(c.displayName, style: AppTextStyles.heading),
              const SizedBox(height: 4),
              Text(user.email, style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary)),
              const SizedBox(height: AppDimensions.lg),

              Row(
                children: [
                  _statBox('${c.tripCount.value}', 'Perjalanan'),
                  const SizedBox(width: AppDimensions.sm),
                  _statBox(Formatters.shortDistance(c.totalDistance.value), 'Total Jarak'),
                  const SizedBox(width: AppDimensions.sm),
                  _statBox(Formatters.duration(Duration(seconds: c.totalDuration.value.toInt())), 'Total Waktu'),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              _menuItem(Icons.settings_outlined, 'Pengaturan',
                  () => Get.toNamed(AppRoutes.settings)),
              const SizedBox(height: AppDimensions.sm),
              _menuItem(Icons.info_outline, 'Tentang', () {}),
              const SizedBox(height: AppDimensions.lg),
              VeloButton(
                label: 'KELUAR',
                style: VeloButtonStyle.danger,
                onPressed: c.logout,
              ),
              const SizedBox(height: AppDimensions.lg),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAvatar(ProfileController c, UserModel user) {
    ImageProvider? avatarImage;
    final photoUrl = user.photoUrl;
    if (photoUrl != null) {
      try {
        if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
          avatarImage = NetworkImage(photoUrl);
        } else {
          avatarImage = MemoryImage(base64Decode(photoUrl));
        }
      } catch (_) {}
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.amber, width: 2),
        image: avatarImage != null
            ? DecorationImage(image: avatarImage, fit: BoxFit.cover)
            : null,
      ),
      child: avatarImage == null
          ? Center(
              child: Text(c.initials,
                  style: AppTextStyles.monoLg.copyWith(color: AppColors.amber)),
            )
          : null,
    );
  }

  Widget _statBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          children: [
            Text(value,
              style: AppTextStyles.monoMd.copyWith(color: AppColors.amber),
              overflow: TextOverflow.ellipsis,
            ),
            Text(label, style: AppTextStyles.label),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md, vertical: AppDimensions.sm + 4),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text(label, style: AppTextStyles.body),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
