import 'dart:async';
import 'package:get/get.dart';
import '../domain/models/telemetry_data.dart';
import 'sensor_manager.dart';

class TelemetrySample {
  final Duration elapsed;
  final TelemetryData data;
  TelemetrySample({required this.elapsed, required this.data});
}

class TelemetryRecorder {
  final List<TelemetrySample> _samples = [];
  Timer? _timer;
  final SensorManager _sensors = Get.find<SensorManager>();
  final Stopwatch _stopwatch = Stopwatch();

  void start() {
    _samples.clear();
    _stopwatch.reset();
    _stopwatch.start();
    _record();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) => _record());
  }

  void _record() {
    _samples.add(TelemetrySample(
      elapsed: _stopwatch.elapsed,
      data: _sensors.telemetry.value,
    ));
  }

  List<TelemetrySample> stop() {
    _timer?.cancel();
    _timer = null;
    _record();
    _stopwatch.stop();
    final result = List<TelemetrySample>.from(_samples);
    _samples.clear();
    return result;
  }
}
