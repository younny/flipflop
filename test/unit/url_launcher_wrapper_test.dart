import 'package:flipflop/constant/keys.dart';
import 'package:flipflop/utils/url_launcher_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:test/test.dart';

void main() {
  final List<MethodCall> log = [];

  group("success", () {
    setUp(() async {
      const MethodChannel('plugins.flutter.io/url_launcher')
          .setMockMethodCallHandler((MethodCall call) async {
        log.add(call);
        if(call.method == 'canLaunch') {
          return true;
        }
        else if(call.method == 'launch') {
          return true;
        }
        return null;
      });
    });

    tearDown(() {
      log.clear();

    });

    test("open default email app", () async {
      bool success = await launchURL(Keys.URL_EMAIL_TYPE, "blah@blah.com");
      expect(log.first.method, "canLaunch");
      expect(log.last.method, "launch");
      expect(success, isTrue);
    });

    test("open default browser app", () async {
      bool success = await launchURL(Keys.URL_BROWSER_TYPE, "www.flutter.io");
      expect(log.first.method, "canLaunch");
      expect(log.last.method, "launch");
      expect(success, isTrue);
    });
  });

  group("failure", () {
    setUp(() async {
      const MethodChannel('plugins.flutter.io/url_launcher')
          .setMockMethodCallHandler((MethodCall call) async {
        log.add(call);
        if(call.method == 'canLaunch') {
          return false;
        }
        else if(call.method == 'launch') {
          return true;
        }
        return null;
      });
    });

    tearDown(() {
      log.clear();

    });

    test("send wrong type", () async {
      expect(() async => await launchURL("test", "blah@blah.com"), throwsException);
    });

    test("cannot find app", () async {
      expect(() async => await launchURL(Keys.URL_EMAIL_TYPE, "blah@blah.com"), throwsException);
    });

  });
}