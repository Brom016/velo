import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../../../shared/widgets/velo_button.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<LoginController>();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.xxl),
              Text('VELO', style: AppTextStyles.monoLg.copyWith(
                color: AppColors.amber, letterSpacing: 8, fontSize: 36,
              )),
              const SizedBox(height: AppDimensions.xxl),
              Text('Masuk', style: AppTextStyles.heading),
              const SizedBox(height: AppDimensions.lg),
              Obx(() {
                if (c.error.value.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.md),
                  child: ErrorBanner(message: c.error.value),
                );
              }),
              VeloTextField(
                label: 'Email',
                hint: 'nama@email.com',
                controller: emailCtrl,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onChanged: c.setEmail,
              ),
              const SizedBox(height: AppDimensions.sm + 6),
              VeloTextField(
                label: 'Password',
                hint: 'Minimal 6 karakter',
                controller: passCtrl,
                prefixIcon: Icons.lock_outline,
                obscure: true,
                onChanged: c.setPassword,
              ),
              const SizedBox(height: AppDimensions.lg),
              Obx(() => VeloButton(
                label: 'MASUK',
                loading: c.loading.value,
                onPressed: c.login,
              )),
              const SizedBox(height: AppDimensions.sm),
              Obx(() => VeloButton(
                label: 'MASUK DENGAN GOOGLE',
                icon: Icons.login,
                style: VeloButtonStyle.outline,
                loading: c.loading.value,
                onPressed: c.loginWithGoogle,
              )),
              const SizedBox(height: AppDimensions.sm),
              VeloButton(
                label: 'Lanjut tanpa login',
                style: VeloButtonStyle.ghost,
                onPressed: c.skipLogin,
              ),
              const SizedBox(height: AppDimensions.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Belum punya akun? ', style: AppTextStyles.body),
                  GestureDetector(
                    onTap: c.goToRegister,
                    child: Text('Daftar',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.amber,
                        fontWeight: FontWeight.w600,
                      )),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
            ],
          ),
        ),
      ),
    );
  }
}
