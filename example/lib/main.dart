import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RingerModeStatus _soundMode = RingerModeStatus.unknown;
  String? _permissionStatus;

  @override
  void initState() {
    super.initState();
    getCurrentSoundMode();
    getPermissionStatus();
  }

  Future<void> getCurrentSoundMode() async {
    RingerModeStatus ringerStatus;
    try {
      ringerStatus = await SoundMode.ringerModeStatus;
      if (Platform.isIOS) {
        //because i no push meesage form ios to flutter,so need read two times
        await Future.delayed(Duration(milliseconds: 1000), () async {
          ringerStatus = await SoundMode.ringerModeStatus;
        });
      }
    } catch (err) {
      ringerStatus = RingerModeStatus.unknown;
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
      permissionStatus = await PermissionHandler.permissionsGranted;
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
              ElevatedButton(
                onPressed: () => setNormalMode(),
                child: Text('Set Normal mode'),
              ),
              ElevatedButton(
                onPressed: () => setSilentMode(),
                child: Text('Set Silent mode'),
              ),
              ElevatedButton(
                onPressed: () => setVibrateMode(),
                child: Text('Set Vibrate mode'),
              ),
              ElevatedButton(
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
    RingerModeStatus status;

    try {
      status = await SoundMode.setSoundMode(RingerModeStatus.silent);

      setState(() {
        _soundMode = status;
      });
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> setNormalMode() async {
    RingerModeStatus status;

    try {
      status = await SoundMode.setSoundMode(RingerModeStatus.normal);
      setState(() {
        _soundMode = status;
      });
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> setVibrateMode() async {
    RingerModeStatus status;

    try {
      status = await SoundMode.setSoundMode(RingerModeStatus.vibrate);

      setState(() {
        _soundMode = status;
      });
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> openDoNotDisturbSettings() async {
    await PermissionHandler.openDoNotDisturbSetting();
  }
}
