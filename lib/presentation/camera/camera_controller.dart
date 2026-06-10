import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart' as cam;
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/telemetry_data.dart';
import '../../services/sensor_manager.dart';
import '../../services/telemetry_recorder.dart';
import '../../services/video_encoder_platform.dart';

enum CameraMode { photo, video }

class CameraController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final overlay = OverlayConfig().obs;
  final mode = CameraMode.photo.obs;
  final isRecording = false.obs;
  final isInitialized = false.obs;

  cam.CameraController? _camCtrl;
  cam.CameraController? get camCtrl => _camCtrl;
  TelemetryRecorder? _recorder;

  bool get isLoggedIn => _authRepo.isLoggedIn;

  Future<void> initCamera() async {
    if (isInitialized.value) return;
    try {
      final cameras = await cam.availableCameras();
      if (cameras.isEmpty) return;
      _camCtrl = cam.CameraController(cameras[0], cam.ResolutionPreset.high);
      await _camCtrl!.initialize();
      isInitialized.value = true;
    } catch (_) {}
  }

  void toggleMode() {
    if (isRecording.value) return;
    mode.value = mode.value == CameraMode.photo ? CameraMode.video : CameraMode.photo;
  }

  Future<String?> capture() async {
    if (_camCtrl == null || !isInitialized.value) return null;
    try {
      if (mode.value == CameraMode.photo) {
        final cam.XFile photo = await _camCtrl!.takePicture();
        final bytes = await photo.readAsBytes();
        final sensors = Get.find<SensorManager>();
        final composited = await _overlayPhoto(bytes, sensors.telemetry.value, overlay.value);
        final tempDir = await getTemporaryDirectory();
        final outFile = File('${tempDir.path}/velo_${DateTime.now().millisecondsSinceEpoch}.png');
        await outFile.writeAsBytes(composited);
        await Gal.putImage(outFile.path);
        return outFile.path;
      } else {
        if (isRecording.value) {
          final cam.XFile video = await _camCtrl!.stopVideoRecording();
          isRecording.value = false;
          final videoPath = video.path;
          await Gal.putVideo(videoPath);

          final samples = _recorder?.stop();
          _recorder = null;

          if (samples != null && samples.isNotEmpty) {
            final ts = DateTime.now().millisecondsSinceEpoch.toString();
            await _generateCompanionVideo(samples, overlay.value, ts);
          }
          return videoPath;
        } else {
          await _camCtrl!.startVideoRecording();
          _recorder = TelemetryRecorder();
          _recorder!.start();
          isRecording.value = true;
          return '';
        }
      }
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List> _overlayPhoto(Uint8List? imageBytes, TelemetryData data, OverlayConfig ov, {Map<String, ui.Image>? tileCache}) async {
    ui.Image? image;
    double w, h;
    if (imageBytes != null) {
      final codec = await ui.instantiateImageCodec(imageBytes);
      final frame = await codec.getNextFrame();
      image = frame.image;
      w = image.width.toDouble();
      h = image.height.toDouble();
    } else {
      w = 1080;
      h = 1920;
    }

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    if (image != null) {
      canvas.drawImage(image, ui.Offset.zero, ui.Paint());
    } else {
      final bgGrad = ui.Paint()
        ..shader = ui.Gradient.radial(
          ui.Offset(w / 2, h / 2),
          w * 0.6,
          [const ui.Color(0xFF1A1A2E), const ui.Color(0xFF0A0B0D)],
        );
      canvas.drawRect(ui.Rect.fromLTWH(0, 0, w, h), bgGrad);
      final ts = w / 1080;
      _drawText(canvas, 'VELO TELEMETRY', w / 2, 44 * ts, 32 * ts, const ui.Color(0xFFFFB347), ui.FontWeight.bold, centerX: w / 2);
      _drawText(canvas, DateTime.now().toString().substring(0, 19), w / 2, 82 * ts, 16 * ts, const ui.Color(0xFF7A7870), ui.FontWeight.normal, centerX: w / 2);
    }

    final s = w / 1080;
    const panelColor = ui.Color.fromRGBO(0, 0, 0, 0.55);
    const amberColor = ui.Color(0xFFFFC107);
    const textPrimary = ui.Color(0xFFF5F5F5);
    const cyanColor = ui.Color(0xFF00BCD4);
    const greenColor = ui.Color(0xFF4CAF50);
    const dangerColor = ui.Color(0xFFE53935);

    final px = 12 * s;
    final py = image != null ? 12 * s : 120 * s;
    final lh = 18 * s;
    final labelW = 30 * s;

    final visible = <String>[];
    if (ov.speed) visible.add('SPD|${data.speedKmh.toStringAsFixed(0)}|${textPrimary.toARGB32()}');
    if (ov.avgSpeed) visible.add('AVG|${data.avgSpeedKmh.toStringAsFixed(0)}|${cyanColor.toARGB32()}');
    if (ov.maxSpeed) visible.add('MAX|${data.maxSpeedKmh.toStringAsFixed(0)}|${amberColor.toARGB32()}');
    if (ov.distance) visible.add('DST|${data.distanceKm.toStringAsFixed(1)}|${greenColor.toARGB32()}');

    if (visible.isNotEmpty) {
      final boxH = visible.length * lh + 12 * s;
      final boxW = 160 * s;
      _drawRoundRect(canvas, px, py, boxW, boxH, 6 * s, panelColor, amberColor, s);
      double ty = py + 6 * s;
      for (final line in visible) {
        final parts = line.split('|');
        _drawText(canvas, parts[0], px + 6 * s, ty, 8 * s, amberColor, ui.FontWeight.bold);
        _drawText(canvas, parts[1], px + 6 * s + labelW, ty, 9 * s, ui.Color(int.parse(parts[2])), ui.FontWeight.bold);
        ty += lh;
      }
    }

    // GPS & DateTime block
    double infoTopY = py + (visible.isNotEmpty ? visible.length * lh + 12 * s : 0) + 4 * s;
    final infoLines = <String>[];
    if (ov.datetime) infoLines.add(DateTime.now().toString().substring(0, 19));
    if (ov.gps && data.latitude != null && data.longitude != null) {
      infoLines.add('${data.latitude!.toStringAsFixed(5)}, ${data.longitude!.toStringAsFixed(5)}');
    }
    if (infoLines.isNotEmpty) {
      final boxH3 = infoLines.length * 14 * s + 8 * s;
      final boxW3 = 160 * s;
      _drawRoundRect(canvas, px, infoTopY, boxW3, boxH3, 6 * s, panelColor, amberColor, s);
      double iy = infoTopY + 4 * s;
      for (final line in infoLines) {
        _drawText(canvas, line, px + 4 * s, iy, 9 * s, const ui.Color(0xFFBDBDBD), ui.FontWeight.normal);
        iy += 14 * s;
      }
    }

    // Top-right: compass + G-force
    final rightX = w - 80 * s;

    if (ov.gforce || ov.compass) {
      final rightItems = <String>[];
      if (ov.gforce) {
        rightItems.add('G|${data.gForceMagnitude.toStringAsFixed(2)}');
        rightItems.add('G MAX|${data.maxGForce.toStringAsFixed(2)}');
      }
      if (ov.compass) rightItems.add('');

      final boxH2 = rightItems.length * lh + 12 * s + (ov.compass ? 60 * s : 0);
      final boxW2 = 80 * s;
      _drawRoundRect(canvas, rightX, py, boxW2, boxH2, 6 * s, panelColor, amberColor, s);

      double ty2 = py + 6 * s;
      if (ov.gforce) {
        _drawText(canvas, 'G', rightX + 4 * s, ty2, 8 * s, amberColor, ui.FontWeight.bold);
        _drawText(canvas, data.gForceMagnitude.toStringAsFixed(2), rightX + boxW2 - 4 * s, ty2, 9 * s, cyanColor, ui.FontWeight.bold,
            alignRight: true);
        ty2 += lh;
        _drawText(canvas, 'G MAX', rightX + 4 * s, ty2, 7 * s, amberColor, ui.FontWeight.bold);
        _drawText(canvas, data.maxGForce.toStringAsFixed(2), rightX + boxW2 - 4 * s, ty2, 9 * s, dangerColor, ui.FontWeight.bold,
            alignRight: true);
        ty2 += lh;
      }
      if (ov.compass) {
        final cx = rightX + boxW2 / 2;
        final cy = ty2 + 30 * s;
        final cr = 26 * s;
        _drawCompass(canvas, cx, cy, cr, data.compassBearing, s);
      }
    }

    // Mini-map (bottom-right)
    if (ov.miniMap && data.latitude != null && data.longitude != null) {
      await _drawMiniMap(canvas, data, w, h, s, tileCache: tileCache);
    }

    final picture = recorder.endRecording();
    final outW = image?.width.toDouble() ?? w;
    final outH = image?.height.toDouble() ?? h;
    final composited = await picture.toImage(outW.toInt(), outH.toInt());
    final byteData = await composited.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// Pre-fetch all unique map tiles for a telemetry recording session
  Future<Map<String, ui.Image>> _prefetchTileMap(List<TelemetrySample> samples) async {
    final cache = <String, ui.Image>{};
    final seen = <String>{};
    for (final sample in samples) {
      final d = sample.data;
      if (d.latitude == null || d.longitude == null) continue;
      final det = _latLngDetails(d.latitude!, d.longitude!, 15);
      final key = '${det['tileX']}_${det['tileY']}';
      if (seen.contains(key)) continue;
      seen.add(key);
      final bytes = await _fetchTileImage(15, det['tileX'] as int, det['tileY'] as int);
      if (bytes != null) {
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        cache[key] = frame.image;
      }
    }
    return cache;
  }

  Future<Uint8List> _renderTelemetryFrame(TelemetryData data, OverlayConfig ov, Map<String, ui.Image>? tileCache) async {
    return _overlayPhoto(null, data, ov, tileCache: tileCache);
  }

  /// Generate companion video from sampled telemetry (native platform encoder)
  Future<void> _generateCompanionVideo(List<TelemetrySample> samples, OverlayConfig ov, String ts) async {
    final workDir = await getTemporaryDirectory();
    final frameDir = Directory('${workDir.path}/frames_$ts');
    await frameDir.create();
    final tileCache = await _prefetchTileMap(samples);
    final totalSec = samples.last.elapsed.inMilliseconds / 1000.0;
    final fps = totalSec > 0 ? (samples.length / totalSec).clamp(1.0, 10.0) : 5.0;

    try {
      for (int i = 0; i < samples.length; i++) {
        final frame = await _renderTelemetryFrame(samples[i].data, ov, tileCache);
        final framePath = '${frameDir.path}/f_${i.toString().padLeft(6, '0')}.png';
        await File(framePath).writeAsBytes(frame);
      }

      final outputPath = '${workDir.path}/velo_comp_$ts.mp4';
      final success = await VideoEncoderPlatform.instance.encodeFrames(
        framesDir: frameDir.path,
        fps: fps.round(),
        outputPath: outputPath,
        width: 1080,
        height: 1920,
      );

      if (success && await File(outputPath).exists()) {
        await Gal.putVideo(outputPath);
      } else {
        final lastSample = samples.last;
        final compBytes = await _renderTelemetryFrame(lastSample.data, ov, tileCache);
        final infoFile = File('${workDir.path}/velo_info_$ts.png');
        await infoFile.writeAsBytes(compBytes);
        await Gal.putImage(infoFile.path);
      }
    } catch (_) {
      final lastSample = samples.last;
      final compBytes = await _renderTelemetryFrame(lastSample.data, ov, tileCache);
      final infoFile = File('${workDir.path}/velo_info_$ts.png');
      await infoFile.writeAsBytes(compBytes);
      await Gal.putImage(infoFile.path);
    } finally {
      if (await frameDir.exists()) {
        await frameDir.delete(recursive: true);
      }
    }
  }

  void _drawRoundRect(ui.Canvas c, double x, double y, double w, double h, double r, ui.Color fill, ui.Color stroke, double s) {
    final rect = ui.RRect.fromRectAndRadius(ui.Rect.fromLTWH(x, y, w, h), ui.Radius.circular(r));
    c.drawRRect(rect, ui.Paint()..color = fill);
    c.drawRRect(rect, ui.Paint()
      ..color = stroke.withValues(alpha: 0.28)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 1 * s);
  }

  void _drawText(ui.Canvas c, String text, double x, double y, double size, ui.Color color, ui.FontWeight weight, {bool alignRight = false, double? centerX}) {
    final align = centerX != null ? ui.TextAlign.center : (alignRight ? ui.TextAlign.right : ui.TextAlign.left);
    final style = ui.ParagraphStyle(
      fontSize: size,
      fontWeight: weight,
      textAlign: align,
    );
    final builder = ui.ParagraphBuilder(style)
      ..pushStyle(ui.TextStyle(color: color))
      ..addText(text);
    final p = builder.build();
    final maxW = centerX != null ? centerX * 2 : 300.0;
    p.layout(ui.ParagraphConstraints(width: maxW));
    final dx = centerX != null ? centerX - p.width / 2 : (alignRight ? x - p.width : x);
    c.drawParagraph(p, ui.Offset(dx, y));
  }

  void _drawCompass(ui.Canvas c, double cx, double cy, double r, double bearing, double s) {
    c.drawCircle(ui.Offset(cx, cy), r, ui.Paint()
      ..color = const ui.Color(0xFF1A1A2E));
    c.drawCircle(ui.Offset(cx, cy), r, ui.Paint()
      ..color = const ui.Color(0xFFFFC107).withValues(alpha: 0.5)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 1 * s);

    const labels = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90 - 90) * pi / 180;
      final lr = r - 10 * s;
      _drawText(c, labels[i], cx + lr * cos(angle), cy + lr * sin(angle), 7 * s,
          i == 0 ? const ui.Color(0xFFFFC107) : const ui.Color(0xFF9E9E9E), i == 0 ? ui.FontWeight.bold : ui.FontWeight.normal);
    }

    c.save();
    c.translate(cx, cy);
    c.rotate(bearing * pi / 180);
    final path = ui.Path()
      ..moveTo(0, -r + 4 * s)
      ..lineTo(-4 * s, -r + 10 * s)
      ..lineTo(4 * s, -r + 10 * s)
      ..close();
    c.drawPath(path, ui.Paint()
      ..color = const ui.Color(0xFFFFC107)
      ..style = ui.PaintingStyle.fill);
    c.restore();
  }

  Map<String, num> _latLngDetails(double lat, double lng, int zoom) {
    final n = pow(2.0, zoom).toDouble();
    final xVal = (lng + 180.0) / 360.0 * n;
    final latRad = lat * pi / 180.0;
    final yVal = (1.0 - (log(tan(latRad) + 1.0 / cos(latRad)) / pi)) / 2.0 * n;
    return {'tileX': xVal.floor(), 'tileY': yVal.floor(), 'offsetX': (xVal - xVal.floor()) * 256, 'offsetY': (yVal - yVal.floor()) * 256};
  }

  Future<Uint8List?> _fetchTileImage(int zoom, int tileX, int tileY) async {
    try {
      final url = 'https://tile.openstreetmap.org/$zoom/$tileX/$tileY.png';
      final client = HttpClient();
      try {
        final request = await client.getUrl(Uri.parse(url));
        request.headers.set('User-Agent', 'VeloApp/1.0');
        final response = await request.close();
        if (response.statusCode != 200) return null;
        final chunks = <int>[];
        await for (final chunk in response) {
          chunks.addAll(chunk);
        }
        return Uint8List.fromList(chunks);
      } finally {
        client.close();
      }
    } catch (_) {}
    return null;
  }

  Future<void> _drawMiniMap(ui.Canvas canvas, TelemetryData data, double imgW, double imgH, double s, {Map<String, ui.Image>? tileCache}) async {
    const zoom = 15;
    final d = _latLngDetails(data.latitude!, data.longitude!, zoom);
    final tileX = d['tileX'] as int;
    final tileY = d['tileY'] as int;
    final tileKey = '${tileX}_$tileY';

    ui.Image tileImage;
    if (tileCache != null && tileCache.containsKey(tileKey)) {
      tileImage = tileCache[tileKey]!;
    } else {
      final tileBytes = await _fetchTileImage(zoom, tileX, tileY);
      if (tileBytes == null) return;
      final codec = await ui.instantiateImageCodec(tileBytes);
      final frame = await codec.getNextFrame();
      tileImage = frame.image;
    }

    final mapSize = 120 * s;
    final margin = 10 * s;
    final mapX = imgW - mapSize - margin;
    final mapY = imgH - mapSize - margin;
    final scale = mapSize / 256;
    final offsetX = (d['offsetX'] as num).toDouble();
    final offsetY = (d['offsetY'] as num).toDouble();
    final destX = mapX + mapSize / 2 - offsetX * scale;
    final destY = mapY + mapSize / 2 - offsetY * scale;

    canvas.save();
    canvas.clipRect(ui.Rect.fromLTWH(mapX, mapY, mapSize, mapSize));
    canvas.drawRect(ui.Rect.fromLTWH(mapX, mapY, mapSize, mapSize), ui.Paint()..color = const ui.Color(0xFFE8E0D0));
    canvas.drawImageRect(tileImage, ui.Rect.fromLTWH(0, 0, 256, 256), ui.Rect.fromLTWH(destX, destY, 256 * scale, 256 * scale), ui.Paint());
    canvas.restore();

    canvas.drawRect(ui.Rect.fromLTWH(mapX, mapY, mapSize, mapSize), ui.Paint()
      ..color = const ui.Color(0xFFFFC107).withValues(alpha: 0.6)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 2 * s);

    final cx = mapX + mapSize / 2;
    final cy = mapY + mapSize / 2;
    canvas.drawCircle(ui.Offset(cx, cy), 4 * s, ui.Paint()..color = const ui.Color(0xFFE53935));
    canvas.drawCircle(ui.Offset(cx, cy), 6 * s, ui.Paint()
      ..color = const ui.Color(0xFFE53935).withValues(alpha: 0.3)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 2 * s);
  }

  @override
  void onClose() {
    _camCtrl?.dispose();
    super.onClose();
  }

  void toggleOverlay(String key) {
    final cfg = overlay.value;
    switch (key) {
      case 'speed': cfg.speed = !cfg.speed;
      case 'avgSpeed': cfg.avgSpeed = !cfg.avgSpeed;
      case 'maxSpeed': cfg.maxSpeed = !cfg.maxSpeed;
      case 'distance': cfg.distance = !cfg.distance;
      case 'gps': cfg.gps = !cfg.gps;
      case 'datetime': cfg.datetime = !cfg.datetime;
      case 'gforce': cfg.gforce = !cfg.gforce;
      case 'maxGforce': cfg.maxGforce = !cfg.maxGforce;
      case 'compass': cfg.compass = !cfg.compass;
      case 'miniMap': cfg.miniMap = !cfg.miniMap;
    }
    overlay.refresh();
  }
}

class OverlayConfig {
  bool speed = true;
  bool avgSpeed = true;
  bool maxSpeed = true;
  bool distance = true;
  bool gps = true;
  bool datetime = true;
  bool gforce = true;
  bool maxGforce = false;
  bool compass = true;
  bool miniMap = true;
}
