import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/remote/firebase/auth_service.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final email = ''.obs;
  final password = ''.obs;
  final loading = false.obs;
  final error = ''.obs;

  void setEmail(String v) => email.value = v;
  void setPassword(String v) => password.value = v;

  Future<void> login() async {
    if (email.value.trim().isEmpty || password.value.trim().isEmpty) {
      error.value = 'Email dan password harus diisi';
      return;
    }

    loading.value = true;
    error.value = '';

    try {
      await _authRepo.login(
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

  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  Future<void> loginWithGoogle() async {
    loading.value = true;
    error.value = '';
    try {
      await _authRepo.loginWithGoogle();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      error.value = mapFirebaseError(e);
    } finally {
      loading.value = false;
    }
  }

  void skipLogin() {
    Get.offAllNamed(AppRoutes.home);
  }
}
