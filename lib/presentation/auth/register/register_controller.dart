import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/remote/firebase/auth_service.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final name = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final loading = false.obs;
  final error = ''.obs;

  void setName(String v) => name.value = v;
  void setEmail(String v) => email.value = v;
  void setPassword(String v) => password.value = v;
  void setConfirmPassword(String v) => confirmPassword.value = v;

  Future<void> register() async {
    if (name.value.trim().isEmpty ||
        email.value.trim().isEmpty ||
        password.value.isEmpty) {
      error.value = 'Semua field harus diisi';
      return;
    }
    if (password.value != confirmPassword.value) {
      error.value = 'Password tidak cocok';
      return;
    }
    if (password.value.length < 6) {
      error.value = 'Password minimal 6 karakter';
      return;
    }

    loading.value = true;
    error.value = '';

    try {
      await _authRepo.register(
        name: name.value.trim(),
        email: email.value.trim(),
        password: password.value,
      );
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      error.value = mapFirebaseError(e);
    } finally {
      loading.value = false;
    }
  }

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
  }
}
