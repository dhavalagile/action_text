import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:action_text/action_text.dart';

void main() {
  const MethodChannel channel = MethodChannel('action_text');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    //expect(await ActionText.platformVersion, '42');
  });
}
