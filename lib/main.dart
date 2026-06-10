import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'core/bindings/initial_binding.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/splash/splash_screen.dart';
import 'presentation/auth/login/login_screen.dart';
import 'presentation/auth/register/register_screen.dart';
import 'presentation/home/home_shell.dart';
import 'presentation/history/trip_detail_screen.dart';
import 'presentation/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WakelockPlus.disable();
  runApp(const VeloApp());
}

class VeloApp extends StatelessWidget {
  const VeloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Velo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
        GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
        GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
        GetPage(name: AppRoutes.home, page: () => const HomeShell()),
        GetPage(name: AppRoutes.settings, page: () => const SettingsScreen()),
        GetPage(name: AppRoutes.tripDetail, page: () => const TripDetailScreen()),
      ],
    );
  }
}
