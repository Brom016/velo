package com.example.velo

import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class VeloForegroundPlugin(private val context: Context) : MethodChannel.MethodCallHandler {
    companion object {
        private const val CHANNEL = "velo/foreground_service"

        fun registerWith(engine: FlutterEngine, context: Context) {
            MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler(VeloForegroundPlugin(context))
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "start" -> {
                val intent = Intent(context, VeloForegroundService::class.java)
                ContextCompat.startForegroundService(context, intent)
                result.success(true)
            }
            "stop" -> {
                val intent = Intent(context, VeloForegroundService::class.java)
                context.stopService(intent)
                result.success(true)
            }
            "isRunning" -> {
                result.success(false)
            }
            else -> result.notImplemented()
        }
    }
}
