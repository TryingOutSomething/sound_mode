import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sound_mode/utils/constants.dart';

class PermissionHandler {
  static const String _OPEN_DO_NOT_DISTURB_SETTING_FUNCTION_NAME =
      "openToDoNotDisturbSettings";

  static const String _GET_PERMISSION_STATUS_FUNCTION_NAME =
      "getPermissionStatus";

  static const MethodChannel _channel =
      const MethodChannel(Constants.METHOD_CHANNEL_NAME);

  static Future<bool> get permissionsGranted async {
    return await _channel.invokeMethod(_GET_PERMISSION_STATUS_FUNCTION_NAME);
  }

  static Future<void> openDoNotDisturbSetting() async {
    await _channel.invokeMethod(_OPEN_DO_NOT_DISTURB_SETTING_FUNCTION_NAME);
  }
}
