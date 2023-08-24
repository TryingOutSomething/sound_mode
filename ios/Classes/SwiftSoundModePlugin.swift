import Flutter
import UIKit

public class SwiftSoundModePlugin: NSObject, FlutterPlugin {
  var str: String = "unknown" 

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "method.channel.audio", binaryMessenger: registrar.messenger())
    let instance = SwiftSoundModePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
        case "getRingerMode":
          RingerModeDetector.instance.detect( { (muteMode) in
              let mode = muteMode ? "vibrate" : "normal"
              result(mode)
          })
        default:
          result(FlutterMethodNotImplemented)
          break;
      }
  }
}
