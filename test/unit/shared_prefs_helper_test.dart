import 'package:flutter/services.dart';
import 'package:flipflop/utils/shared_prefs_helper.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall call) async {
          if(call.method == 'getAll') {
            return <String, dynamic>{
              "flutter.test-key": "test"
            };
          }
          return null;
    });
  });

  test("get shared preference", () async {
    String value = await getPrefs<String>("test-key");
    expect(value, equals("test"));
  });

  test("set shared preference", () async {
    await setPrefs("test-key", "ko");

    String value = await getPrefs<String>("test-key");
    expect(value, equals("ko"));
  });
}