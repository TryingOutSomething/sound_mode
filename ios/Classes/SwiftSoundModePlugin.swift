import Flutter
import UIKit
import MuteDetect
public class SwiftSoundModePlugin: NSObject, FlutterPlugin {
  var str: String = "default" 
  var count: Int = 0
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "method.channel.audio", binaryMessenger: registrar.messenger())
    let instance = SwiftSoundModePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
        case "getRingerMode":
           MuteDetect.shared.detectSound { (isMute) in
               self.str = (isMute ? "Vibrate Mode" : "Normal Moder")
               self.count=self.count+1;
               self.str+=String(self.count);
          }
          result(self.str);
        default:
          break;
      }
  }
}
