import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('sound_mode');

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      return null;
    });
  });

  tearDown(() {
    channel.setMethodCallHandler(null);
  });

//  test('getPlatformVersion', () async {
//    expect(await SoundMode.platformVersion, '42');
//  });
}
