import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ponytail: Montserrat for bold/mono/display, Poppins for body. JetBrainsMono/MinionPro/BrandonGrotesque files were missing
  static const String monoFamily = 'Montserrat';
  static const String displayFamily = 'Montserrat';
  static const String boldFamily = 'Montserrat';
  static const String bodyFamily = 'Poppins';

  static final monoHero = TextStyle(
    fontFamily: displayFamily,
    fontSize: 56,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final monoLg = TextStyle(
    fontFamily: monoFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final monoMd = TextStyle(
    fontFamily: monoFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final monoSm = TextStyle(
    fontFamily: monoFamily,
    fontSize: 13,
    color: AppColors.textPrimary,
  );

  static final monoXs = TextStyle(
    fontFamily: monoFamily,
    fontSize: 11,
    color: AppColors.textPrimary,
  );

  static final monoXxs = TextStyle(
    fontFamily: monoFamily,
    fontSize: 10,
    color: AppColors.textPrimary,
  );

  static final heading = TextStyle(
    fontFamily: boldFamily,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );

  static final subheading = TextStyle(
    fontFamily: boldFamily,
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );

  static final body = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static final label = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.08,
  );

  static final labelDanger = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.danger,
    letterSpacing: 0.08,
  );
}
