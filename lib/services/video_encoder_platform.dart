import 'package:flutter/services.dart';

class VideoEncoderPlatform {
  static const _channel = MethodChannel('velo/video_encoder');
  static final VideoEncoderPlatform instance = VideoEncoderPlatform._();
  VideoEncoderPlatform._();

  Future<bool> encodeFrames({
    required String framesDir,
    required int fps,
    required String outputPath,
    required int width,
    required int height,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>('encodeFrames', {
        'framesDir': framesDir,
        'fps': fps,
        'outputPath': outputPath,
        'width': width,
        'height': height,
      });
      return result == outputPath;
    } catch (_) {
      return false;
    }
  }
}
