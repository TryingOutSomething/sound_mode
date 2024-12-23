import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sound_mode/utils/constants.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

/// A class to manage and interact with the device's sound mode.
class SoundMode {
  // Platform method names for getting and setting sound modes
  static const String _getRingerModeMethod = "getRingerMode";
  static const String _setNormalModeMethod = "setNormalMode";
  static const String _setSilentModeMethod = "setSilentMode";
  static const String _setVibrateModeMethod = "setVibrateMode";

  // The method channel used for communication with platform code
  static const MethodChannel _channel = MethodChannel(Constants.METHOD_CHANNEL_NAME);

  // Holds the current ringer status
  static RingerModeStatus _currentRingerStatus = RingerModeStatus.unknown;

  /// Retrieves the current sound mode of the device.
  ///
  /// The return value can be one of the following:
  /// - [RingerModeStatus.unknown]
  /// - [RingerModeStatus.normal]
  /// - [RingerModeStatus.silent]
  /// - [RingerModeStatus.vibrate]
  static Future<RingerModeStatus> get ringerModeStatus async {
    try {
      // Invoke the platform method to get the ringer mode
      final String enumString = await _channel.invokeMethod(_getRingerModeMethod);

      // Map the string to the corresponding RingerModeStatus enum
      _currentRingerStatus = _toEnum(enumString);

      return _currentRingerStatus;
    } on PlatformException catch (e) {
      // Handle platform-specific errors
      print("Error getting ringer mode: ${e.message}");
      return RingerModeStatus.unknown;
    }
  }

  /// Sets the device's sound mode to the provided [profile].
  ///
  /// Accepts one of the following [RingerModeStatus] values:
  /// - [RingerModeStatus.normal] - Sets the device to normal mode.
  /// - [RingerModeStatus.silent] - Sets the device to silent mode.
  /// - [RingerModeStatus.vibrate] - Sets the device to vibrate mode.
  ///
  /// Throws a [PlatformException] if there are platform-specific issues
  /// (e.g., permission issues, unsupported devices).
  static Future<RingerModeStatus> setSoundMode(RingerModeStatus profile) async {
    String enumStringValue;

    try {
      switch (profile) {
        case RingerModeStatus.normal:
          enumStringValue = await _channel.invokeMethod(_setNormalModeMethod);
          break;
        case RingerModeStatus.silent:
          enumStringValue = await _channel.invokeMethod(_setSilentModeMethod);
          break;
        case RingerModeStatus.vibrate:
          enumStringValue = await _channel.invokeMethod(_setVibrateModeMethod);
          break;
        default:
          enumStringValue = "unknown";
      }

      // Map the response to the corresponding enum
      _currentRingerStatus = _toEnum(enumStringValue);

      return _currentRingerStatus;
    } on PlatformException catch (e) {
      // Handle any platform-specific exceptions
      print("Error setting sound mode: ${e.message}");
      return RingerModeStatus.unknown;
    }
  }

  /// Converts a string representation of an enum to the corresponding [RingerModeStatus] value.
  ///
  /// If the string is invalid or doesn't match any known enum value, it returns [RingerModeStatus.unknown].
  static RingerModeStatus _toEnum(String enumString) {
    try {
      // Return the enum that matches the string value, or RingerModeStatus.unknown if no match is found
      return RingerModeStatus.values.firstWhere(
        (e) => e.toString() == 'RingerModeStatus.' + enumString,
        orElse: () => RingerModeStatus.unknown,
      );
    } catch (e) {
      // If an invalid value is provided, default to unknown
      print("Error converting enum string: $enumString");
      return RingerModeStatus.unknown;
    }
  }
}
