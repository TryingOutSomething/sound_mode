# sound_mode

A [Flutter plugin](https://pub.dev/packages/sound_mode) to manage a device's sound mode on Android.


## Usage 
Add `sound_mode` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

Add the following permission to `AndroidManifest.xml` for the app to appear in the 'Do Not Disturb Access' list
```
<manifest ... >
    <uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY"/>
    
    <application ... >
    ...
</manifest>
```

## Features
1. Detect device's current sound mode
2. Able to toggle between Normal, Silent & Vibrate mode
3. Grant Do No Disturb permissions for devices above platform version `Android 6.0 (API 23)` 

## Example
To get the device's current sound mode:
 
```dart
String ringerStatus = await SoundMode.ringerModeStatus;
print(ringerStatus);
```

To change the device's sound mode:

```dart
import 'package:sound_mode/utils/sound_profiles.dart';

// Handle Platform Exceptions for devices running above Android 6.0 
try {
  await SoundMode.setSoundMode(Profiles.SILENT);
} on PlatformException {
  print('Please enable permissions required');
}
```

##### List of modes available
| Mode  | Description |
|---|---|
| Profiles.NORMAL  | Sets the device to normal mode  |
| Profiles.SILENT  | Sets the device to silent mode  |
| Profiles.VIBRATE  | Sets the device to vibrate mode  |

#### For Android 6.0 and above
For devices with Android 6.0 and above, it is required for the user to grant Do No Disturb Access to set their device's sound mode. 

To check if the user has granted the permissions and prompt for approval
```dart
import 'package:sound_mode/permission_handler.dart';

bool isGranted = await PermissionHandler.permissionsGranted;

if (!isGranted) {
  // Opens the Do Not Disturb Access settings to grant the access
  await PermissionHandler.openDoNotDisturbSetting();
}
``` 

### For iOS version
Currently, it is possible to get the device's ringer mode status. Thanks to [wanghaiyang5241](https://github.com/wanghaiyang5241) for adding the iOS implementation.

For iOS, the following lines of code can be added to use it in flutter
```dart
if (Platform.isIOS) {
    await Future.delayed(Duration(milliseconds: 1000), () async {
        ringerStatus = await SoundMode.ringerModeStatus;
    });
}
```

## Contributing
Feel free to edit the plugin and submit a pull request or open an issue on github to leave a feedback

## License
[MIT](https://choosealicense.com/licenses/mit/) 
