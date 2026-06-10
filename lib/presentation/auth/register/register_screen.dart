import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../../../shared/widgets/velo_button.dart';
import 'register_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RegisterController>();
    final s = AppSizing.scale(context);
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizing.spacing(context, 20)),
          child: Column(
            children: [
              SizedBox(height: AppSizing.spacing(context, 40)),
              Text('VELO', style: AppTextStyles.monoLg.copyWith(
                color: AppColors.amber, letterSpacing: 8, fontSize: 32 * s,
              )),
              SizedBox(height: AppSizing.spacing(context, 32)),
              Text('Daftar', style: AppTextStyles.heading),
              SizedBox(height: AppSizing.spacing(context, 20)),
              Obx(() {
                if (c.error.value.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSizing.spacing(context, 14)),
                  child: ErrorBanner(message: c.error.value),
                );
              }),
              VeloTextField(
                label: 'Nama',
                hint: 'Nama lengkap',
                controller: nameCtrl,
                prefixIcon: Icons.person_outline,
                onChanged: c.setName,
              ),
              SizedBox(height: AppSizing.spacing(context, 12)),
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
              SizedBox(height: AppSizing.spacing(context, 12)),
              VeloTextField(
                label: 'Konfirmasi Password',
                hint: 'Ulangi password',
                controller: confirmCtrl,
                prefixIcon: Icons.lock_outline,
                obscure: true,
                onChanged: c.setConfirmPassword,
              ),
              SizedBox(height: AppSizing.spacing(context, 20)),
              Obx(() => VeloButton(
                label: 'DAFTAR',
                loading: c.loading.value,
                onPressed: c.register,
              )),
              SizedBox(height: AppSizing.spacing(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sudah punya akun? ', style: AppTextStyles.body),
                  GestureDetector(
                    onTap: c.goToLogin,
                    child: Text('Masuk',
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
      ),
    );
  }
}
