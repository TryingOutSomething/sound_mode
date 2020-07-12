import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_mode/enums/sound_profiles.dart';
import 'package:sound_mode/sound_mode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _soundMode = 'Unknown';

  @override
  void initState() {
    super.initState();
    getCurrentSoundMode();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getCurrentSoundMode() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SoundMode.ringerModeStatus;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _soundMode = platformVersion;
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
              Text('Running on: $_soundMode\n'),
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
    String message;

    try {
      message = await SoundMode.setSoundMode(Profiles.SILENT);

      setState(() {
        _soundMode = message;
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> setNormalMode() async {
    String message;

    try {
      message = await SoundMode.setSoundMode(Profiles.NORMAL);

      setState(() {
        _soundMode = message;
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> setVibrateMode() async {
    String message;

    try {
      message = await SoundMode.setSoundMode(Profiles.VIBRATE);

      setState(() {
        _soundMode = message;
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> openDoNotDisturbSettings() async {
    await SoundMode.openDoNotDisturbSetting();
  }
}
