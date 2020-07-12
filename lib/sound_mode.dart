import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sound_mode/enums/sound_profiles.dart';

class SoundMode {
  static const String CHANNEL = "method.channel.audio";

  static const String GET_RINGER_MODE_FUNCTION_NAME = "getRingerMode";
  static const String SET_NORMAL_MODE_FUNCTION_NAME = "setNormalMode";
  static const String SET_SILENT_MODE_FUNCTION_NAME = "setSilentMode";
  static const String SET_VIBRATE_MODE_FUNCTION_NAME = "setVibrateMode";

  static const String OPEN_DO_NOT_DISTURB_SETTING_FUNCTION_NAME =
      "openToDoNotDisturbSettings";

  static const MethodChannel _channel = const MethodChannel(CHANNEL);

  static String _currentRingerStatus;

  static Future<String> get ringerModeStatus async {
    _currentRingerStatus =
        await _channel.invokeMethod(GET_RINGER_MODE_FUNCTION_NAME);

    return _currentRingerStatus;
  }

  static Future<String> setSoundMode(Profiles profile) async {
    switch (profile) {
      case Profiles.NORMAL:
        _currentRingerStatus =
            await _channel.invokeMethod(SET_NORMAL_MODE_FUNCTION_NAME);
        break;
      case Profiles.SILENT:
        _currentRingerStatus =
            await _channel.invokeMethod(SET_SILENT_MODE_FUNCTION_NAME);
        break;
      case Profiles.VIBRATE:
        _currentRingerStatus =
            await _channel.invokeMethod(SET_VIBRATE_MODE_FUNCTION_NAME);
        break;
      default:
        _currentRingerStatus = "Unknown";
    }

    return _currentRingerStatus;
  }

  static Future<void> openDoNotDisturbSetting() async {
    await _channel.invokeMethod(OPEN_DO_NOT_DISTURB_SETTING_FUNCTION_NAME);
  }
}
