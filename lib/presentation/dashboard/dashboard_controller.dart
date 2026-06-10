import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/trip_session_manager.dart';

class DashboardController extends GetxController {
  final TripSessionManager _tripSession = Get.find<TripSessionManager>();
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final startLoading = false.obs;
  final gpsEnabled = false.obs;
  final locationDenied = false.obs;

  bool get isLoggedIn => _authRepo.isLoggedIn;

  @override
  void onInit() {
    super.onInit();
    _checkGps();
  }

  Future<void> _checkGps() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      gpsEnabled.value = serviceEnabled;

      final permission = await Geolocator.checkPermission();
      locationDenied.value = permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever;
    } catch (_) {}
  }

  Future<void> onStartPressed() async {
    if (_tripSession.status.value != TripStatus.idle) return;

    await _checkGps();
    if (locationDenied.value) {
      Get.snackbar(
        'Izin Lokasi',
        'Aktifkan izin lokasi untuk memulai perekaman',
        backgroundColor: AppColors.amber,
        colorText: AppColors.bgPrimary,
        duration: const Duration(seconds: 4),
      );
      return;
    }
    if (!gpsEnabled.value) {
      Get.snackbar(
        'GPS Mati',
        'Aktifkan GPS untuk data akurat',
        backgroundColor: AppColors.amber,
        colorText: AppColors.bgPrimary,
        duration: const Duration(seconds: 4),
      );
    }

    startLoading.value = true;
    try {
      await _tripSession.start();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memulai: $e',
        backgroundColor: AppColors.danger,
        colorText: AppColors.textPrimary,
        duration: const Duration(seconds: 3),
      );
    } finally {
      startLoading.value = false;
    }
  }

  Future<void> onPausePressed() async {
    if (_tripSession.status.value == TripStatus.active) {
      await _tripSession.pause();
    } else if (_tripSession.status.value == TripStatus.paused) {
      await _tripSession.resume();
    }
  }

  Future<void> onStopPressed() async {
    await _tripSession.stop();
  }
}
