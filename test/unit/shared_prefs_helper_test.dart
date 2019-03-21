import 'package:flipflop/utils/shared_prefs_helper.dart';
import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' show isMethodCall;
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
      sharedPrefHelper = SharedPrefHelper();
      log.clear();
    });

    tearDown(() {
      sharedPrefHelper
          .pref()
          .then((pref) => sharedPrefHelper.clear());
    });

    test("read", () async {
      await sharedPrefHelper.pref();

      expect(await sharedPrefHelper.get("String"), testValues['flutter.String']);
      expect(await sharedPrefHelper.get("bool"), testValues['flutter.bool']);
      expect(await sharedPrefHelper.get("List"), testValues['flutter.List']);
      expect(log, <Matcher>[
        isMethodCall('getAll', arguments: null)
      ]);
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

      expect(await sharedPrefHelper.get("String"), testValues2['flutter.String']);
      expect(await sharedPrefHelper.get("bool"), testValues2['flutter.bool']);
      expect(await sharedPrefHelper.get("List"), testValues2['flutter.List']);

    });

    test("make sure instance is singleton", () async {
      final SharedPrefHelper newPrefHelper = SharedPrefHelper();
      await newPrefHelper.pref();
      expect(sharedPrefHelper, newPrefHelper);
    });
  });

  group("throws exception case", () {
    SharedPrefHelper sharedPrefHelper;
    Map<String, dynamic> errorResult = {
    };
    setUp(() async {
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
            if(methodCall.method == 'getAll')
              return errorResult;
            return null;
      });
      sharedPrefHelper = SharedPrefHelper();
      sharedPrefHelper.withMock(null);
      log.clear();
    });

    tearDown(() {
      sharedPrefHelper
          .pref()
          .then((pref) => sharedPrefHelper.clear());
    });

    test("try get when sharedPreferences instance is null", () async {
      sharedPrefHelper.withMock(null);

      dynamic result = await sharedPrefHelper.get("String");

      expect(result, '');
    });


  });

}