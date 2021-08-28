# sound_mode
You can get the sound mode status on IOS & Android!
On Android you can also manage the device's sound mode.

## Android Usage 
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
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

// Handle Platform Exceptions for devices running above Android 6.0 
try {
  await SoundMode.setSoundMode(RingerModeStatus.silent);
} on PlatformException {
  print('Please enable permissions required');
}
```

##### List of modes available
| Mode  | Description |
|---|---|
| RingerModeStatus.normal  | Sets the device to normal mode  |
| RingerModeStatus.silent  | Sets the device to silent mode  |
| RingerModeStatus.vibrate  | Sets the device to vibrate mode  |

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

## iOS Usage
Currently, it is possible to get the device's ringer mode status.
For iOS, the following lines of code can be added to use it in flutter
```dart
ringerStatus = await SoundMode.ringerModeStatus;
```


## List of ringerModeStatus statuses
| Status  | Description |
|---|---|
| RingerModeStatus.unknown  | Don't know the status  |
| RingerModeStatus.normal  | Device is in normal mode  |
| RingerModeStatus.silent  | Device is in silent mode  |
| RingerModeStatus.vibrate  | Device is in vibrate mode  |

## Contributing
Feel free to edit the plugin and submit a pull request or open an issue on github to leave a feedback

## License
[MIT](https://choosealicense.com/licenses/mit/) 
