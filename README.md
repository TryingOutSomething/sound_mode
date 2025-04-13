# sound_mode

A Flutter plugin for detecting and controlling the ringer mode (Normal, Silent, Vibrate) on Android devices.  
Also supports detecting ringer mode status on iOS (read-only).

---

## Features

- Detect the current ringer mode on Android and iOS
- Toggle between **Normal**, **Silent**, and **Vibrate** modes (Android only)
- Request and manage **Do Not Disturb** permissions on Android 6.0 (API 23) and above

---

## Installation

Add `sound_mode` to your [`pubspec.yaml`](https://flutter.dev/docs/development/packages-and-plugins/using-package) file:

```yaml
dependencies:
  sound_mode: <latest_version>
```

Then run:

```bash
flutter pub get
```

---

## Android Setup

### Permissions

To allow the app to change ringer mode on Android 6.0+, you need to request **Do Not Disturb access**.  
Add the following permission to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY" />
```

Place this inside the `<manifest>` tag, not inside `<application>`.

---

## Usage

### Get current ringer mode

```dart
import 'package:sound_mode/sound_mode.dart';

String ringerStatus = await SoundMode.ringerModeStatus;
print(ringerStatus);
```

### Change ringer mode (Android only)

```dart
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

try {
  await SoundMode.setSoundMode(RingerModeStatus.silent);
} on PlatformException {
  print('Please enable the required permissions');
}
```

### Handling Do Not Disturb Access (Android 6.0+)

To change the ringer mode on devices running Android 6.0 (API level 23) and above, your app must have **Do Not Disturb access** (also known as Notification Policy Access). Without this, calls to `setSoundMode()` will fail.

#### 1. Add permission to AndroidManifest.xml

Make sure the following permission is declared:

```xml
<uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY" />
```

#### 2. Check and request permission at runtime

Use the plugin's built-in `PermissionHandler` to check if access is granted, and open the system settings page if needed:

```dart
import 'package:sound_mode/permission_handler.dart';

bool isGranted = await PermissionHandler.permissionsGranted;

if (!isGranted) {
  // This will open the system settings where the user can manually grant access
  await PermissionHandler.openDoNotDisturbSetting();
}
```

---

## iOS Support

> **Warning:** iOS support is currently **experimental and unreliable**.  
> Reading the ringer mode status may **not work consistently** across all devices and OS versions.  
> This feature also does **not work on iOS simulators** — only real devices.

We're actively looking for contributors to help improve iOS support.  
If you have experience with iOS native development or want to help debug the current implementation, feel free to [open an issue](https://github.com/your-repo-link/issues) or submit a pull request.

### Example (iOS)

A short delay is recommended before reading the ringer status for more reliable results:

```dart
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

RingerModeStatus ringerStatus = RingerModeStatus.unknown;

Future.delayed(const Duration(seconds: 1), () async {
try {
ringerStatus = await SoundMode.ringerModeStatus;
} catch (err) {
ringerStatus = RingerModeStatus.unknown;
}
print(ringerStatus);
});
```

---

## RingerModeStatus Values

| Value                      | Description                      |
|---------------------------|----------------------------------|
| `RingerModeStatus.unknown` | Unknown or unsupported status   |
| `RingerModeStatus.normal`  | Device is in Normal mode        |
| `RingerModeStatus.silent`  | Device is in Silent mode        |
| `RingerModeStatus.vibrate` | Device is in Vibrate mode       |

---

## Contributing

Contributions are welcome. Feel free to open an issue or submit a pull request on GitHub.

---

## License

This project is licensed under the [MIT License](https://choosealicense.com/licenses/mit/).

---