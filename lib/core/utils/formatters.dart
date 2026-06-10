import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String speed(double kmh) {
    return kmh.toStringAsFixed(0);
  }

  static String distance(double km) {
    if (km < 1) {
      return '${(km * 1000).toStringAsFixed(0)} m';
    }
    return '${km.toStringAsFixed(2)} km';
  }

  static String shortDistance(double km) {
    return '${km.toStringAsFixed(1)}';
  }

  static String duration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    if (d.inHours > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  static String coordinates(double lat, double lng) {
    final latDir = lat >= 0 ? 'N' : 'S';
    final lngDir = lng >= 0 ? 'E' : 'W';
    return '${lat.toStringAsFixed(4)}°$latDir ${lng.toStringAsFixed(4)}°$lngDir';
  }

  static String gForce(double g) {
    final sign = g >= 0 ? '+' : '';
    return '$sign${g.toStringAsFixed(2)}';
  }

  static String bearing(double degrees) {
    return '${degrees.toStringAsFixed(0)}°';
  }

  static String date(DateTime dt) {
    return DateFormat('dd MMM yyyy').format(dt);
  }

  static String time(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  static String dateTime(DateTime dt) {
    return DateFormat('dd MMM yyyy HH:mm').format(dt);
  }
}
