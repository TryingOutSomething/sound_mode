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
    String enumValue =
        await _channel.invokeMethod(_GET_RINGER_MODE_FUNCTION_NAME);

    _currentRingerStatus = RingerModeStatus.values
        .firstWhere((e) => e.toString() == 'RingerModeStatus.' + enumValue);

    return _currentRingerStatus;
  }

  /// Sets the device's sound mode.
  ///
  /// Pass in either one of the following enum from [Profiles] to set the
  /// device's sound mode.
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
    switch (profile) {
      case RingerModeStatus.normal:
        _currentRingerStatus =
            await _channel.invokeMethod(_SET_NORMAL_MODE_FUNCTION_NAME);
        break;
      case RingerModeStatus.silent:
        _currentRingerStatus =
            await _channel.invokeMethod(_SET_SILENT_MODE_FUNCTION_NAME);
        break;
      case RingerModeStatus.vibrate:
        _currentRingerStatus =
            await _channel.invokeMethod(_SET_VIBRATE_MODE_FUNCTION_NAME);
        break;
      default:
        _currentRingerStatus = RingerModeStatus.unknown;
    }

    return _currentRingerStatus;
  }
}
