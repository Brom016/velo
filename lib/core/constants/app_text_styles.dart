import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  /// Ganti font di sini secara global
  static const String monoFamily = 'JetBrainsMono';
  static const String displayFamily = 'MinionPro';
  static const String uiFamily = 'BrandonGrotesque';

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
    fontFamily: uiFamily.isNotEmpty ? uiFamily : null,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final subheading = TextStyle(
    fontFamily: uiFamily.isNotEmpty ? uiFamily : null,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static final body = TextStyle(
    fontFamily: uiFamily.isNotEmpty ? uiFamily : null,
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static final label = TextStyle(
    fontFamily: uiFamily.isNotEmpty ? uiFamily : null,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.08,
  );

  static final labelDanger = TextStyle(
    fontFamily: uiFamily.isNotEmpty ? uiFamily : null,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.danger,
    letterSpacing: 0.08,
  );
}
