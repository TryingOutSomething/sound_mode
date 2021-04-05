import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/sound_profiles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _soundMode = 'Unknown';
  String? _permissionStatus;

  @override
  void initState() {
    super.initState();
    getCurrentSoundMode();
    getPermissionStatus();
  }

  Future<void> getCurrentSoundMode() async {
    String? ringerStatus;
    try {
      ringerStatus = await SoundMode.ringerModeStatus;
      if (Platform.isIOS) {
        //because i no push meesage form ios to flutter,so need read two times
        await Future.delayed(Duration(milliseconds: 1000), () async {
          ringerStatus = await SoundMode.ringerModeStatus;
        });
      }
    } catch (err) {
      ringerStatus = 'Failed to get device\'s ringer status.$err';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _soundMode = ringerStatus;
    });
  }

  Future<void> getPermissionStatus() async {
    bool? permissionStatus = false;
    try {
      permissionStatus = await (PermissionHandler.permissionsGranted as FutureOr<bool>);
      print(permissionStatus);
    } catch (err) {
      print(err);
    }

    setState(() {
      _permissionStatus =
          permissionStatus! ? "Permissions Enabled" : "Permissions not granted";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Running on: $_soundMode\n $_permissionStatus'),
              RaisedButton(
                onPressed: () => setNormalMode(),
                child: Text('Set Normal mode'),
              ),
              RaisedButton(
                onPressed: () => setSilentMode(),
                child: Text('Set Silent mode'),
              ),
              RaisedButton(
                onPressed: () => setVibrateMode(),
                child: Text('Set Vibrate mode'),
              ),
              RaisedButton(
                onPressed: () => openDoNotDisturbSettings(),
                child: Text('Open Do Not Access Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setSilentMode() async {
    String? message;

    try {
      message = await SoundMode.setSoundMode(Profiles.SILENT);

      setState(() {
        _soundMode = message;
      });
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> setNormalMode() async {
    String? message;

    try {
      message = await SoundMode.setSoundMode(Profiles.NORMAL);
      setState(() {
        _soundMode = message;
      });
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> setVibrateMode() async {
    String? message;

    try {
      message = await SoundMode.setSoundMode(Profiles.VIBRATE);

      setState(() {
        _soundMode = message;
      });
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> openDoNotDisturbSettings() async {
    await PermissionHandler.openDoNotDisturbSetting();
  }
}
