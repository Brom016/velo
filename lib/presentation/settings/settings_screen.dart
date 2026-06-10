import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/remote/firebase/auth_service.dart';
import 'settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SettingsController());
    final auth = Get.find<AuthRepository>();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.amber),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => ListView(
        padding: const EdgeInsets.all(AppDimensions.md),
        children: [
          // ── Edit Profile ──
          if (auth.user != null) ...[
            _section('Edit Profil'),
            _profilePhoto(context, auth),
            const SizedBox(height: AppDimensions.sm),
            _profileName(c, auth),
            const SizedBox(height: AppDimensions.md),
          ],
          _section('Satuan'),
          _radioTile(c, 'km/h', 'kmh', c.speedUnit.value, c.setSpeedUnit),
          _radioTile(c, 'mph', 'mph', c.speedUnit.value, c.setSpeedUnit),
          const SizedBox(height: AppDimensions.md),
          _section('Interval GPS'),
          _radioTile(c, '2 detik', 2, c.gpsInterval.value, c.setGpsInterval),
          _radioTile(c, '3 detik', 3, c.gpsInterval.value, c.setGpsInterval),
          _radioTile(c, '5 detik', 5, c.gpsInterval.value, c.setGpsInterval),
          const SizedBox(height: AppDimensions.md),
          _section('Interval Batch'),
          _radioTile(c, '1 detik', 1000, c.batchInterval.value, c.setBatchInterval),
          _radioTile(c, '1.5 detik', 1500, c.batchInterval.value, c.setBatchInterval),
          _radioTile(c, '2 detik', 2000, c.batchInterval.value, c.setBatchInterval),
          const SizedBox(height: AppDimensions.md),
          _switchTile(c, 'Layar tetap menyala', c.keepScreenOn.value, c.setKeepScreenOn),
          _switchTile(c, 'Getaran', c.vibration.value, c.setVibration),
          const SizedBox(height: AppDimensions.md),
          _section('Minimap Kamera'),
          _sliderTile(c, 'Opacity', c.miniMapOpacity.value, 0.2, 1.0, c.setMiniMapOpacity),
        ],
      )),
    );
  }

  Widget _profilePhoto(BuildContext context, AuthRepository auth) {
    final user = auth.user;
    if (user == null) return const SizedBox.shrink();

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

    return Center(
      child: GestureDetector(
        onTap: () => _pickPhoto(auth),
        child: Stack(
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.amber, width: 2),
                image: avatarImage != null
                    ? DecorationImage(image: avatarImage, fit: BoxFit.cover)
                    : null,
              ),
              child: avatarImage == null
                  ? Center(child: Text(_initials2(user),
                      style: AppTextStyles.monoLg.copyWith(color: AppColors.amber)))
                  : null,
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 24, height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.amber, shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 14, color: AppColors.bgPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileName(SettingsController c, AuthRepository auth) {
    final user = auth.user;
    if (user == null) return const SizedBox.shrink();

    final displayName = user.name.isNotEmpty ? user.name : (user.email.isNotEmpty ? user.email.split('@').first : 'Pengguna');

    return Center(
      child: c.editingName.value
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: c.nameCtrl,
                    style: AppTextStyles.heading.copyWith(fontSize: 18),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.amber),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => c.saveName(auth),
                  child: const Icon(Icons.check, color: AppColors.positive, size: 24),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: c.cancelEditName,
                  child: const Icon(Icons.close, color: AppColors.textSecondary, size: 24),
                ),
              ],
            )
          : GestureDetector(
              onTap: () {
                c.nameCtrl.text = user.name;
                c.editingName.value = true;
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(displayName, style: AppTextStyles.heading),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, size: 16, color: AppColors.textSecondary),
                ],
              ),
            ),
    );
  }

  String _initials2(UserModel user) {
    if (user.name.isNotEmpty) {
      final parts = user.name.split(' ');
      if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      return user.name[0].toUpperCase();
    }
    if (user.email.isNotEmpty) return user.email[0].toUpperCase();
    return '?';
  }

  Future<void> _pickPhoto(AuthRepository auth) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 256,
        maxHeight: 256,
        imageQuality: 70,
      );
      if (image == null) return;
      final bytes = await File(image.path).readAsBytes();
      final b64 = base64Encode(bytes);
      final uid = auth.uid;
      if (uid == 'guest') {
        Get.snackbar('Info', 'Anda harus login untuk mengubah foto profil');
        return;
      }
      await Get.find<AuthService>().updateProfile(uid, {'photoUrl': b64});
      final current = auth.user;
      if (current != null) {
        auth.updateProfile(current.copyWith(photoUrl: b64));
      }
      Get.snackbar('Berhasil', 'Foto profil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan foto: ${mapFirebaseError(e)}');
    }
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Text(title, style: AppTextStyles.subheading),
    );
  }

  Widget _radioTile<T>(SettingsController c, String label, T value, T groupValue, Future<void> Function(T) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: Row(
          children: [
            Icon(
              value == groupValue
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: value == groupValue ? AppColors.amber : AppColors.textDisabled,
              size: 18,
            ),
            const SizedBox(width: AppDimensions.sm),
            Text(label, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }

  Widget _sliderTile(SettingsController c, String label, double value, double min, double max, Future<void> Function(double) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body)),
          SizedBox(
            width: 120,
            child: Obx(() => Slider(
              value: c.miniMapOpacity.value,
              min: min,
              max: max,
              divisions: 8,
              activeColor: AppColors.amber,
              inactiveColor: AppColors.border,
              onChanged: (v) => c.setMiniMapOpacity(v),
            )),
          ),
          SizedBox(
            width: 36,
            child: Text(value.toStringAsFixed(2),
              style: AppTextStyles.monoXs.copyWith(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _switchTile(SettingsController c, String label, bool value, Future<void> Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.amber,
          ),
        ],
      ),
    );
  }
}
