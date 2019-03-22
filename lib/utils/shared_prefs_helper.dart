import 'package:collection/collection.dart';
import 'package:flipflop/constant/error.dart';
import 'package:flipflop/exception.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences _sharedPreferences;

  SharedPreferences get sharedPreferences => _sharedPreferences;

  static final SharedPrefHelper _instance = SharedPrefHelper._();

  factory SharedPrefHelper() => _instance;

  SharedPrefHelper._();

  Future<SharedPreferences> pref() async {
    if(_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
      return _sharedPreferences;
    }
    return _sharedPreferences;
  }

  Future<T> get<T>(String key) async {
    if(_sharedPreferences == null) {
      throw SharedPreferencesException("${FFError.SHARED_PREFERENCES} Instance is null.");
    }
    T result;
    try {
      result = _sharedPreferences.get(key);
    } catch (e) {
      throw SharedPreferencesException("${FFError.SHARED_PREFERENCES} ${e.toString()}");
    }
    return result;
  }

  Future<bool> set<T>(String key, dynamic value) async {
    if(_sharedPreferences == null) {
      throw SharedPreferencesException("${FFError.SHARED_PREFERENCES} Instance is null.");
    }

    switch (T) {
      case String:
        return _sharedPreferences.setString(key, value);
      case bool:
        return _sharedPreferences.setBool(key, value);
      case List:
        return _sharedPreferences.setStringList(key, value);
      case int:
        return _sharedPreferences.setInt(key, value);
      case double:
        return _sharedPreferences.setDouble(key, value);
      default:
        throw SharedPreferencesException("${FFError.SHARED_PREFERENCES} Incorrect type");
    }
  }

  void clear() async {
    if(_sharedPreferences == null) {
      throw SharedPreferencesException("${FFError.SHARED_PREFERENCES} Instance is null.");
    }

    _sharedPreferences.clear();
  }

  @visibleForTesting
  void withMock(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }
}