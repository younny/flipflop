import 'package:flipflop/constant/error.dart';
import 'package:flipflop/exception.dart';
import 'package:flipflop/utils/shared_prefs_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' show isMethodCall;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSharePrefHelper extends Mock implements SharedPrefHelper {}

void main() {
  final List<MethodCall> log = <MethodCall>[];
  const Map<String, dynamic> testValues = <String, dynamic>{
    'flutter.String': 'test',
    'flutter.bool': true,
    'flutter.List': <String>['foo','bar']
  };
  const Map<String, dynamic> testValues2 = <String, dynamic>{
    'flutter.String': 'test2',
    'flutter.bool': false,
    'flutter.List': <String>['foo2','bar2']
  };

  group("success case", () {
    SharedPrefHelper sharedPrefHelper;
    setUp(() async {
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall call) async {
            log.add(call);
            if(call.method == 'getAll') {
              return testValues;
            }
            return null;
        });
      sharedPrefHelper = await SharedPrefHelper.init();
      log.clear();
    });

    tearDown(() {
    });

    test("read", () async {
      expect(await sharedPrefHelper.get<String>("String"), testValues['flutter.String']);
      expect(await sharedPrefHelper.get<bool>("bool"), testValues['flutter.bool']);
      expect(await sharedPrefHelper.get<List>("List"), testValues['flutter.List']);
      expect(log, <Matcher>[]);
    });

    test("read with no data type", () async {
      expect(await sharedPrefHelper.get("String"), testValues['flutter.String']);
    });

    test("write", () async {
      await Future.wait([
        sharedPrefHelper.set<String>("String", testValues2['flutter.String']),
        sharedPrefHelper.set<bool>("bool", testValues2['flutter.bool']),
        sharedPrefHelper.set<List>("List", testValues2['flutter.List'])
      ]);

      expect(log, <Matcher>[
        isMethodCall('setString', arguments: <String, dynamic> {
          'key': 'flutter.String',
          'value': testValues2['flutter.String']
        }),
        isMethodCall('setBool', arguments: <String, dynamic> {
          'key': 'flutter.bool',
          'value': testValues2['flutter.bool']
        }),
        isMethodCall('setStringList', arguments: <String, dynamic> {
          'key': 'flutter.List',
          'value': testValues2['flutter.List']
        })
      ]);

      expect(await sharedPrefHelper.get<String>("String"), testValues2['flutter.String']);
      expect(await sharedPrefHelper.get<bool>("bool"), testValues2['flutter.bool']);
      expect(await sharedPrefHelper.get<List<String>>("List"), testValues2['flutter.List']);

    });

    test("make sure instance is singleton", () async {
      final SharedPrefHelper newPrefHelper = await SharedPrefHelper.init();

      expect(sharedPrefHelper, newPrefHelper);
    });
  });

  group("throws exception", () {
    SharedPrefHelper sharedPrefHelper;
    setUp(() async {
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
            if(methodCall.method == 'getAll')
              return testValues;
            return null;
      });
      sharedPrefHelper = await SharedPrefHelper.init();
    });

    tearDown(() {

    });

    test("sharedPreferences instance is null", () async {
      sharedPrefHelper.withMock(null);

      expect(() async => await sharedPrefHelper.get<String>("String"),
          throwsA(TypeMatcher<SharedPreferencesException>()
              .having((e) => e.message, "message", contains(FFError.SHARED_PREFERENCES))));

      expect(() => sharedPrefHelper.clear(),
          throwsA(TypeMatcher<SharedPreferencesException>()
              .having((e) => e.message, "message", contains(FFError.SHARED_PREFERENCES))));
    });

    test("cast with wrong data type", () async {
      expect(() async => await sharedPrefHelper.get<int>("String"),
          throwsA(TypeMatcher<SharedPreferencesException>()
              .having((e) => e.message, "message", contains(FFError.SHARED_PREFERENCES))));
    });

    test("set unavailble data type", () async {
      expect(() async => await sharedPrefHelper.set<Object>("Object", { "test": "foo" }),
          throwsA(TypeMatcher<SharedPreferencesException>()
          .having((e) => e.message, "message", contains(FFError.SHARED_PREFERENCES))));
    });

  });

}