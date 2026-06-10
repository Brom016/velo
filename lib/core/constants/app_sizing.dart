import 'package:flutter/material.dart';

class AppSizing {
  AppSizing._();

  static const double _baseline = 360;

  static double scale(BuildContext c) {
    return (MediaQuery.of(c).size.width / _baseline).clamp(0.78, 1.35);
  }

  static double font(BuildContext c, double base) {
    return base * scale(c);
  }

  static double speedometerSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    return (w * 0.55).clamp(170, 260);
  }

  static double indicatorSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    return (w * 0.25).clamp(76, 130);
  }

  static double cardPadding(BuildContext c) {
    return (10 * scale(c)).clamp(8.0, 14.0);
  }

  static double spacing(BuildContext c, double base) {
    return base * scale(c);
  }
}
