import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';

class HomeController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final currentIndex = 0.obs;

  bool get isGuest => !_authRepo.isLoggedIn;

  void onTabTapped(int index) {
    currentIndex.value = index;
  }

  bool get showLoginTab => isGuest;

  IconData iconFor(int index) {
    const icons = [
      Icons.speed,
      Icons.map,
      Icons.camera_alt,
      Icons.history,
      Icons.person,
    ];
    if (index == 4 && isGuest) return Icons.login_outlined;
    return currentIndex.value == index
        ? icons[index]
        : _outlinedFor(index);
  }

  IconData _outlinedFor(int index) {
    const outlined = [
      Icons.speed_outlined,
      Icons.map_outlined,
      Icons.camera_alt_outlined,
      Icons.history_outlined,
      Icons.person_outline,
    ];
    return outlined[index];
  }

  String labelFor(int index) {
    const labels = ['Dashboard', 'Peta', 'Kamera', 'Riwayat', 'Profil'];
    if (index == 4 && isGuest) return 'Masuk';
    return labels[index];
  }
}
