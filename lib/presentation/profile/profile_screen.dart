import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizing.dart';
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
    final s = AppSizing.scale(context);

    return SafeArea(
      child: Obx(() {
        final user = c.user.value;
        if (user == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_outline,
                    size: 56 * s, color: AppColors.textSecondary),
                SizedBox(height: AppSizing.spacing(context, 14)),
                Text('Belum masuk', style: AppTextStyles.heading),
                SizedBox(height: AppSizing.spacing(context, 8)),
                Text('Masuk untuk melihat profil',
                    style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary)),
                SizedBox(height: AppSizing.spacing(context, 20)),
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
          padding: EdgeInsets.all(AppSizing.spacing(context, 14)),
          child: Column(
            children: [
              SizedBox(height: AppSizing.spacing(context, 12)),
              _buildAvatar(c, user, s),
              SizedBox(height: AppSizing.spacing(context, 8)),
              Text(c.displayName, style: AppTextStyles.heading),
              SizedBox(height: 4 * s),
              Text(user.email, style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary)),
              SizedBox(height: AppSizing.spacing(context, 20)),

              Row(
                children: [
                  _statBox(context, '${c.tripCount.value}', 'Perjalanan', s),
                  SizedBox(width: AppSizing.spacing(context, 8)),
                  _statBox(context, Formatters.shortDistance(c.totalDistance.value), 'Total Jarak', s),
                  SizedBox(width: AppSizing.spacing(context, 8)),
                  _statBox(context, Formatters.duration(Duration(seconds: c.totalDuration.value.toInt())), 'Total Waktu', s),
                ],
              ),
              SizedBox(height: AppSizing.spacing(context, 20)),
              _menuItem(context, Icons.settings_outlined, 'Pengaturan',
                  () => Get.toNamed(AppRoutes.settings), s),
              SizedBox(height: AppSizing.spacing(context, 8)),
              _menuItem(context, Icons.info_outline, 'Tentang', () {}, s),
              SizedBox(height: AppSizing.spacing(context, 20)),
              VeloButton(
                label: 'KELUAR',
                style: VeloButtonStyle.danger,
                onPressed: c.logout,
              ),
              SizedBox(height: AppSizing.spacing(context, 20)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAvatar(ProfileController c, UserModel user, double s) {
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

    final avatarSize = (76 * s).clamp(60.0, 100.0);
    return Container(
      width: avatarSize,
      height: avatarSize,
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
                  style: AppTextStyles.monoLg.copyWith(
                    color: AppColors.amber,
                    fontSize: 22 * s,
                  )),
            )
          : null,
    );
  }

  Widget _statBox(BuildContext context, String value, String label, double s) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizing.spacing(context, 12),
        ),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          children: [
            Text(value,
              style: AppTextStyles.monoMd.copyWith(
                color: AppColors.amber,
                fontSize: 16 * s,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(label, style: AppTextStyles.label),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, VoidCallback onTap, double s) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppSizing.spacing(context, 14),
            vertical: AppSizing.spacing(context, 10)),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20 * s),
            SizedBox(width: AppSizing.spacing(context, 8)),
            Expanded(
              child: Text(label, style: AppTextStyles.body),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
