import 'package:flutter/services.dart';

class ForegroundService {
  static const _channel = MethodChannel('velo/foreground_service');

  static Future<void> start() async {
    try {
      await _channel.invokeMethod('start');
    } catch (_) {}
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stop');
    } catch (_) {}
  }
}
