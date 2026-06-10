import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

extension ContextExt on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  void showSnack(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.bgCard,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(AppDimensions.md),
      borderRadius: AppDimensions.radiusMd,
      duration: const Duration(seconds: 3),
    );
  }
}
