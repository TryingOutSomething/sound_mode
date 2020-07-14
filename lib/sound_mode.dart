import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sound_mode/utils/constants.dart';
import 'package:sound_mode/utils/sound_profiles.dart';

class SoundMode {
  static const String _GET_RINGER_MODE_FUNCTION_NAME = "getRingerMode";
  static const String _SET_NORMAL_MODE_FUNCTION_NAME = "setNormalMode";
  static const String _SET_SILENT_MODE_FUNCTION_NAME = "setSilentMode";
  static const String _SET_VIBRATE_MODE_FUNCTION_NAME = "setVibrateMode";

  static const MethodChannel _channel =
      const MethodChannel(Constants.METHOD_CHANNEL_NAME);

  static String _currentRingerStatus;

  /// Gets the current device's sound mode.
  /// The return values from the function call are:
  /// 1. Normal mode
  /// 2. Silent mode
  /// 3. Vibrate mode
  static Future<String> get ringerModeStatus async {
    _currentRingerStatus =
        await _channel.invokeMethod(_GET_RINGER_MODE_FUNCTION_NAME);

    return _currentRingerStatus;
  }

  /// Sets the device's sound mode.
  ///
  /// Pass in either one of the following enum from [Profiles] to set the
  /// device's sound mode.
  ///
  /// 1. Profiles.NORMAL (Sets the device to normal mode)
  /// 2. Profiles.SILENT (Sets the device to silent mode)
  /// 3. Profiles.VIBRATE (Sets the device to vibrate mode)
  ///
  /// Throws [PlatformException] if the current device's API version is 24 and
  /// above. Require user's grant for Do Not Disturb Access, call the function
  /// [openDoNotDisturbSetting] from [PermissionHandler] before calling this
  /// function.
  static Future<String> setSoundMode(Profiles profile) async {
    switch (profile) {
      case Profiles.NORMAL:
        _currentRingerStatus =
            await _channel.invokeMethod(_SET_NORMAL_MODE_FUNCTION_NAME);
        break;
      case Profiles.SILENT:
        _currentRingerStatus =
            await _channel.invokeMethod(_SET_SILENT_MODE_FUNCTION_NAME);
        break;
      case Profiles.VIBRATE:
        _currentRingerStatus =
            await _channel.invokeMethod(_SET_VIBRATE_MODE_FUNCTION_NAME);
        break;
      default:
        _currentRingerStatus = "Unknown";
    }

    return _currentRingerStatus;
  }
}
