import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_routes.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/trip_repository.dart';
import '../../data/remote/firebase/auth_service.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  final TripRepository _tripRepo = Get.find<TripRepository>();
  final ImagePicker _picker = ImagePicker();

  final editingName = false.obs;
  final nameCtrl = TextEditingController();
  final saving = false.obs;
  final tripCount = 0.obs;
  final totalDistance = 0.0.obs;
  final totalDuration = 0.0.obs;

  Rx<UserModel?> get user => _authRepo.userRx;
  bool get isLoggedIn => _authRepo.isLoggedIn;
  String get userName => _authRepo.user?.name ?? '';
  String get userEmail => _authRepo.user?.email ?? '';
  String? get photoUrl => _authRepo.user?.photoUrl;

  String get displayName {
    final name = userName;
    if (name.isNotEmpty) return name;
    final email = userEmail;
    if (email.isNotEmpty) return email.split('@').first;
    return 'Pengguna';
  }

  String get initials {
    final name = displayName;
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  void startEditName() {
    nameCtrl.text = userName;
    editingName.value = true;
  }

  Future<void> saveName() async {
    final newName = nameCtrl.text.trim();
    if (newName.isEmpty) {
      editingName.value = false;
      return;
    }
    saving.value = true;
    try {
      final uid = _authRepo.uid;
      if (uid == 'guest') {
        Get.snackbar('Info', 'Anda harus login untuk mengubah nama');
        return;
      }
      await Get.find<AuthService>().updateProfile(uid, {'name': newName});
      final current = _authRepo.user;
      if (current != null) {
        final updated = UserModel(
          uid: current.uid,
          name: newName,
          email: current.email,
          photoUrl: current.photoUrl,
          createdAt: current.createdAt,
        );
        _authRepo.updateProfile(updated);
        Get.snackbar('Berhasil', 'Nama berhasil diubah');
      }
    } catch (e) {
      Get.snackbar('Error', mapFirebaseError(e));
    } finally {
      editingName.value = false;
      saving.value = false;
    }
  }

  void cancelEditName() {
    editingName.value = false;
  }

  Future<void> pickPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 256,
        maxHeight: 256,
        imageQuality: 70,
      );
      if (image == null) return;
      saving.value = true;
      final file = File(image.path);
      final bytes = await file.readAsBytes();
      final b64 = base64Encode(bytes);

      final uid = _authRepo.uid;
      if (uid == 'guest') {
        Get.snackbar('Info', 'Anda harus login untuk mengubah foto profil');
        return;
      }
      await Get.find<AuthService>().updateProfile(uid, {'photoUrl': b64});
      final current = _authRepo.user;
      if (current != null) {
        final updated = UserModel(
          uid: current.uid,
          name: current.name,
          email: current.email,
          photoUrl: b64,
          createdAt: current.createdAt,
        );
        _authRepo.updateProfile(updated);
      }
      Get.snackbar('Berhasil', 'Foto profil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan foto: ${mapFirebaseError(e)}');
    } finally {
      saving.value = false;
    }
  }

  Future<void> loadTripStats() async {
    final uid = _authRepo.uid;
    final stats = await _tripRepo.getTripStats(uid);
    tripCount.value = stats['count']!.toInt();
    totalDistance.value = stats['totalDistance']!;
    totalDuration.value = stats['totalDuration']!;
  }

  Future<void> logout() async {
    await _authRepo.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onInit() {
    super.onInit();
    ever(_authRepo.userRx, (_) => loadTripStats());
    loadTripStats();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    super.onClose();
  }
}
