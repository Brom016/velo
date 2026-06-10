import 'package:get/get.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/daos/daos.dart';
import '../../data/remote/firebase/auth_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/trip_repository.dart';
import '../../services/sensor_manager.dart';
import '../../services/trip_session_manager.dart';
import '../../presentation/home/home_controller.dart';
import '../../presentation/auth/login/login_controller.dart';
import '../../presentation/auth/register/register_controller.dart';
import '../../presentation/dashboard/dashboard_controller.dart';
import '../../presentation/map/map_controller.dart';
import '../../presentation/camera/camera_controller.dart';
import '../../presentation/profile/profile_controller.dart';
import '../../presentation/settings/settings_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppDatabase(), permanent: true);
    Get.put(Daos(Get.find<AppDatabase>()), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(AuthRepository(), permanent: true);
    Get.put(TripRepository(), permanent: true);
    Get.put(SensorManager(), permanent: true);
    Get.put(TripSessionManager(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<RegisterController>(RegisterController(), permanent: true);
    Get.put<DashboardController>(DashboardController(), permanent: true);
    Get.put<MapScreenController>(MapScreenController(), permanent: true);
    Get.put<CameraController>(CameraController(), permanent: true);
    Get.put<ProfileController>(ProfileController(), permanent: true);
    Get.put<SettingsController>(SettingsController(), permanent: true);
  }
}
