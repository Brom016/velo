import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _monoFamily = 'JetBrainsMono';

  static final monoHero = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 56,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final monoLg = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final monoMd = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final monoSm = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 13,
    color: AppColors.textPrimary,
  );

  static final monoXs = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 11,
    color: AppColors.textPrimary,
  );

  static final monoXxs = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 10,
    color: AppColors.textPrimary,
  );

  static final heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static final body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static final label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.08,
  );

  static final labelDanger = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.danger,
    letterSpacing: 0.08,
  );
}
