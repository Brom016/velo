import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart' show Value;
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
    ever(_authRepo.userRx, (_) {
      if (_authRepo.isLoggedIn) loadTrips();
    });
  }

  Future<void> loadTrips() async {
    loading.value = true;
    try {
      final uid = _authRepo.uid;
      final local = await _tripRepo.getMyTrips(uid);
      if (_authRepo.isLoggedIn) {
        final cloud = await _tripRepo.getTripsFromFirestore(uid);
        final localIds = local.map((t) => '${t.startTime.millisecondsSinceEpoch}_${t.totalDistanceKm}').toSet();
        final merged = [...local];
        for (final t in cloud) {
          final key = '${t.startTime.millisecondsSinceEpoch}_${t.totalDistanceKm}';
          if (!localIds.contains(key)) {
            final newId = await _tripRepo.createTrip(
              TripsCompanion(
                userId: Value(uid),
                startTime: Value(t.startTime),
                endTime: Value(t.endTime),
                totalDistanceKm: Value(t.totalDistanceKm),
                maxSpeedKmh: Value(t.maxSpeedKmh),
                avgSpeedKmh: Value(t.avgSpeedKmh),
                maxGForce: Value(t.maxGForce),
                status: Value(t.status),
              ),
            );
            merged.add(Trip(
              id: newId,
              userId: uid,
              startTime: t.startTime,
              endTime: t.endTime,
              totalDistanceKm: t.totalDistanceKm,
              maxSpeedKmh: t.maxSpeedKmh,
              avgSpeedKmh: t.avgSpeedKmh,
              maxGForce: t.maxGForce,
              status: t.status,
            ));
          }
        }
        merged.sort((a, b) => b.startTime.compareTo(a.startTime));
        trips.value = merged;
      } else {
        trips.value = local;
      }
    } finally {
      loading.value = false;
    }
  }

  void openTripDetail(int tripId) {
    Get.toNamed(AppRoutes.tripDetail, arguments: tripId);
  }
}
