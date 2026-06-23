import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../../../shared/widgets/velo_button.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<LoginController>();
    final s = AppSizing.scale(context);
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: AppSizing.spacing(context, 8),
              left: AppSizing.spacing(context, 8),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.bgOverlay,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.close, color: AppColors.textPrimary, size: 18),
                ),
              ),
            ),
            SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizing.spacing(context, 20)),
          child: Column(
            children: [
              SizedBox(height: AppSizing.spacing(context, 40)),
              Text('VELO', style: AppTextStyles.monoLg.copyWith(
                color: AppColors.amber, letterSpacing: 8, fontSize: 32 * s,
              )),
              SizedBox(height: AppSizing.spacing(context, 32)),
              Text('Masuk', style: AppTextStyles.heading),
              SizedBox(height: AppSizing.spacing(context, 20)),
              Obx(() {
                if (c.error.value.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSizing.spacing(context, 14)),
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
              SizedBox(height: AppSizing.spacing(context, 12)),
              VeloTextField(
                label: 'Password',
                hint: 'Minimal 6 karakter',
                controller: passCtrl,
                prefixIcon: Icons.lock_outline,
                obscure: true,
                onChanged: c.setPassword,
              ),
              SizedBox(height: AppSizing.spacing(context, 20)),
              Obx(() => VeloButton(
                label: 'MASUK',
                loading: c.loading.value,
                onPressed: c.login,
              )),
              SizedBox(height: AppSizing.spacing(context, 8)),
              Obx(() => VeloButton(
                label: 'MASUK DENGAN GOOGLE',
                icon: Icons.login,
                style: VeloButtonStyle.outline,
                loading: c.loading.value,
                onPressed: c.loginWithGoogle,
              )),
              SizedBox(height: AppSizing.spacing(context, 8)),
              VeloButton(
                label: 'Lanjut tanpa login',
                style: VeloButtonStyle.ghost,
                onPressed: c.skipLogin,
              ),
              SizedBox(height: AppSizing.spacing(context, 20)),
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
              SizedBox(height: AppSizing.spacing(context, 20)),
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }
}
