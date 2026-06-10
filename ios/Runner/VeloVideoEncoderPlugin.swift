import Flutter
import UIKit

public class VeloVideoEncoderPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "velo/video_encoder", binaryMessenger: registrar.messenger())
        let instance = VeloVideoEncoderPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "encodeFrames":
            result(FlutterError(code: "UNSUPPORTED", message: "iOS video encoding not yet implemented", details: nil))
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
