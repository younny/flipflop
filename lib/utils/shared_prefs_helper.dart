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
    try {
      dynamic result = await _sharedPreferences.get(key);
      return result;
    } catch(e) {
      return "" as T;
    }
  }

  Future set<T>(String key, dynamic value) async {
    try {
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
          return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void clear() async {
    try {
      _sharedPreferences.clear();
    } catch (e) {
      print(e);
    }
  }

  @visibleForTesting
  void withMock(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }
}