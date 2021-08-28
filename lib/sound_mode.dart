import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sound_mode/utils/constants.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class SoundMode {
  static const String _GET_RINGER_MODE_FUNCTION_NAME = "getRingerMode";
  static const String _SET_NORMAL_MODE_FUNCTION_NAME = "setNormalMode";
  static const String _SET_SILENT_MODE_FUNCTION_NAME = "setSilentMode";
  static const String _SET_VIBRATE_MODE_FUNCTION_NAME = "setVibrateMode";

  static const MethodChannel _channel =
      const MethodChannel(Constants.METHOD_CHANNEL_NAME);

  static RingerModeStatus _currentRingerStatus = RingerModeStatus.unknown;

  /// Gets the current device's sound mode.
  /// The return values from the function call are:
  /// 1. Unknown mode
  /// 2. Normal mode
  /// 3. Silent mode
  /// 4. Vibrate mode
  static Future<RingerModeStatus> get ringerModeStatus async {
    if (_currentRingerStatus == RingerModeStatus.unknown) {
      String enumStringValue =
          await _channel.invokeMethod(_GET_RINGER_MODE_FUNCTION_NAME);

      _currentRingerStatus = _toEnum(enumStringValue);
    }

    return _currentRingerStatus;
  }

  /// Sets the device's sound mode.
  ///
  /// Pass in either one of the following enum from [RingerModeStatus] to set
  /// the device's sound mode.
  ///
  /// 1. RingerModeStatus.NORMAL (Sets the device to normal mode)
  /// 2. RingerModeStatus.SILENT (Sets the device to silent mode)
  /// 3. RingerModeStatus.VIBRATE (Sets the device to vibrate mode)
  ///
  /// Throws [PlatformException] if the current device's API version is 24 and
  /// above. Require user's grant for Do Not Disturb Access, call the function
  /// [openDoNotDisturbSetting] from [PermissionHandler] before calling this
  /// function.
  static Future<RingerModeStatus> setSoundMode(RingerModeStatus profile) async {
    String enumStringValue;

    switch (profile) {
      case RingerModeStatus.normal:
        enumStringValue =
            await _channel.invokeMethod(_SET_NORMAL_MODE_FUNCTION_NAME);
        break;
      case RingerModeStatus.silent:
        enumStringValue =
            await _channel.invokeMethod(_SET_SILENT_MODE_FUNCTION_NAME);
        break;
      case RingerModeStatus.vibrate:
        enumStringValue =
            await _channel.invokeMethod(_SET_VIBRATE_MODE_FUNCTION_NAME);
        break;
      default:
        enumStringValue = "unknown";
    }

    _currentRingerStatus = _toEnum(enumStringValue);

    return _currentRingerStatus;
  }

  static RingerModeStatus _toEnum(String enumString) {
    return RingerModeStatus.values.firstWhere(
        (e) => e.toString() == 'RingerModeStatus.' + enumString,
        orElse: () => RingerModeStatus.unknown);
  }
}
