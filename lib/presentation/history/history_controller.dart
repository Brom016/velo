import 'package:get/get.dart';
import '../../core/constants/app_routes.dart';
import '../../data/local/database/app_database.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/trip_repository.dart';
import '../../services/trip_session_manager.dart';

class HistoryController extends GetxController {
  final TripRepository _tripRepo = Get.find<TripRepository>();
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final trips = <Trip>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTrips();
    ever(Get.find<TripSessionManager>().status, (status) {
      if (status == TripStatus.idle) loadTrips();
    });
  }

  Future<void> loadTrips() async {
    loading.value = true;
    try {
      final uid = _authRepo.uid;
      trips.value = await _tripRepo.getMyTrips(uid);
    } finally {
      loading.value = false;
    }
  }

  void openTripDetail(int tripId) {
    Get.toNamed(AppRoutes.tripDetail, arguments: tripId);
  }
}
