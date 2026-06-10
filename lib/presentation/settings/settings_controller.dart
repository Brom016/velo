import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/remote/firebase/auth_service.dart';

class SettingsController extends GetxController {
  final speedUnit = 'kmh'.obs;
  final gpsInterval = 2.obs;
  final batchInterval = 1500.obs;
  final keepScreenOn = true.obs;
  final vibration = true.obs;
  final miniMapOpacity = 0.72.obs;

  final editingName = false.obs;
  final nameCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    super.onClose();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    speedUnit.value = prefs.getString('speed_unit') ?? 'kmh';
    gpsInterval.value = prefs.getInt('gps_interval') ?? 2;
    batchInterval.value = prefs.getInt('batch_interval') ?? 1500;
    keepScreenOn.value = prefs.getBool('keep_screen_on') ?? true;
    vibration.value = prefs.getBool('vibration') ?? true;
    miniMapOpacity.value = prefs.getDouble('mini_map_opacity') ?? 0.72;
  }

  Future<void> saveName(AuthRepository auth) async {
    final newName = nameCtrl.text.trim();
    if (newName.isEmpty) {
      editingName.value = false;
      return;
    }
    try {
      final uid = auth.uid;
      if (uid == 'guest') {
        Get.snackbar('Info', 'Anda harus login untuk mengubah nama');
        return;
      }
      await Get.find<AuthService>().updateProfile(uid, {'name': newName});
      final current = auth.user;
      if (current != null) {
        auth.updateProfile(current.copyWith(name: newName));
      }
      Get.snackbar('Berhasil', 'Nama berhasil diubah');
    } catch (e) {
      Get.snackbar('Error', mapFirebaseError(e));
    } finally {
      editingName.value = false;
    }
  }

  void cancelEditName() {
    editingName.value = false;
  }

  Future<void> setSpeedUnit(String unit) async {
    speedUnit.value = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('speed_unit', unit);
  }

  Future<void> setGpsInterval(int interval) async {
    gpsInterval.value = interval;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gps_interval', interval);
  }

  Future<void> setBatchInterval(int interval) async {
    batchInterval.value = interval;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('batch_interval', interval);
  }

  Future<void> setKeepScreenOn(bool value) async {
    keepScreenOn.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keep_screen_on', value);
  }

  Future<void> setVibration(bool value) async {
    vibration.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration', value);
  }

  Future<void> setMiniMapOpacity(double value) async {
    miniMapOpacity.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('mini_map_opacity', value);
  }
}
