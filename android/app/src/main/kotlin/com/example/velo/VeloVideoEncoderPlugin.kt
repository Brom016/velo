package com.example.velo

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.MediaCodec
import android.media.MediaCodecInfo
import android.media.MediaFormat
import android.media.MediaMuxer
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class VeloVideoEncoderPlugin(engine: FlutterEngine) : MethodChannel.MethodCallHandler {
    companion object {
        private const val CHANNEL = "velo/video_encoder"

        fun registerWith(engine: FlutterEngine) {
            MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler(VeloVideoEncoderPlugin(engine))
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "encodeFrames" -> {
                val framesDir = call.argument<String>("framesDir")
                    ?: return result.error("NO_DIR", "framesDir required", null)
                val fps = call.argument<Int>("fps") ?: 5
                val outputPath = call.argument<String>("outputPath")
                    ?: return result.error("NO_PATH", "outputPath required", null)
                val width = call.argument<Int>("width") ?: 1080
                val height = call.argument<Int>("height") ?: 1920

                try {
                    encodeFrames(framesDir, fps, outputPath, width, height)
                    result.success(outputPath)
                } catch (e: Exception) {
                    result.error("ENCODE_ERROR", e.message ?: "Unknown error", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun encodeFrames(framesDir: String, fps: Int, outputPath: String, width: Int, height: Int) {
        val dir = File(framesDir)
        val frameFiles = dir.listFiles { f -> f.name.endsWith(".png") }
            ?.sortedBy { f -> f.name } ?: throw RuntimeException("No PNG frames found")

        val bitrate = 2_000_000
        val muxer = MediaMuxer(outputPath, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)

        val format = MediaFormat.createVideoFormat(MediaFormat.MIMETYPE_VIDEO_AVC, width, height).apply {
            setInteger(MediaFormat.KEY_BIT_RATE, bitrate)
            setInteger(MediaFormat.KEY_FRAME_RATE, fps)
            setInteger(MediaFormat.KEY_I_FRAME_INTERVAL, 1)
            setInteger(MediaFormat.KEY_COLOR_FORMAT, MediaCodecInfo.CodecCapabilities.COLOR_FormatSurface)
        }

        val codec = MediaCodec.createEncoderByType(MediaFormat.MIMETYPE_VIDEO_AVC)
        val inputSurface = codec.createInputSurface()
        codec.configure(format, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE)
        codec.start()

        val bufferInfo = MediaCodec.BufferInfo()
        var trackIndex = -1
        var muxerStarted = false
        var frameCount = 0

        for (frameFile in frameFiles) {
            val bitmap = BitmapFactory.decodeFile(frameFile.absolutePath) ?: continue
            val canvas = inputSurface.lockCanvas(null)
            canvas.drawBitmap(bitmap, 0f, 0f, null)
            inputSurface.unlockCanvasAndPost(canvas)
            bitmap.recycle()

            frameCount++
            val pts = frameCount * 1_000_000L / fps

            // Drain encoder
            while (true) {
                val outputIndex = codec.dequeueOutputBuffer(bufferInfo, 5_000)
                when {
                    outputIndex == MediaCodec.INFO_TRY_AGAIN_LATER -> break
                    outputIndex == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED -> {
                        if (muxerStarted) throw RuntimeException("Format changed twice")
                        trackIndex = muxer.addTrack(codec.outputFormat)
                        muxer.start()
                        muxerStarted = true
                    }
                    outputIndex >= 0 -> {
                        if (!muxerStarted) {
                            trackIndex = muxer.addTrack(codec.outputFormat)
                            muxer.start()
                            muxerStarted = true
                        }
                        val outputBuffer = codec.getOutputBuffer(outputIndex)
                        if (outputBuffer != null && bufferInfo.size > 0) {
                            outputBuffer.position(bufferInfo.offset)
                            outputBuffer.limit(bufferInfo.offset + bufferInfo.size)
                            bufferInfo.presentationTimeUs = pts / 1000L
                            muxer.writeSampleData(trackIndex, outputBuffer, bufferInfo)
                        }
                        codec.releaseOutputBuffer(outputIndex, false)
                    }
                }
            }
        }

        // End of stream
        codec.signalEndOfInputStream()
        while (true) {
            val outputIndex = codec.dequeueOutputBuffer(bufferInfo, 10_000)
            when {
                outputIndex == MediaCodec.INFO_TRY_AGAIN_LATER -> break
                outputIndex == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED -> {
                    trackIndex = muxer.addTrack(codec.outputFormat)
                    muxer.start()
                    muxerStarted = true
                }
                outputIndex >= 0 -> {
                    if (!muxerStarted) {
                        trackIndex = muxer.addTrack(codec.outputFormat)
                        muxer.start()
                        muxerStarted = true
                    }
                    val outputBuffer = codec.getOutputBuffer(outputIndex)
                    if (outputBuffer != null && bufferInfo.size > 0) {
                        outputBuffer.position(bufferInfo.offset)
                        outputBuffer.limit(bufferInfo.offset + bufferInfo.size)
                        muxer.writeSampleData(trackIndex, outputBuffer, bufferInfo)
                    }
                    codec.releaseOutputBuffer(outputIndex, false)
                    if (bufferInfo.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM != 0) break
                }
            }
        }

        codec.stop()
        codec.release()
        muxer.stop()
        muxer.release()
    }
}
