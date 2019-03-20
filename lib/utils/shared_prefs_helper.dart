import 'package:shared_preferences/shared_preferences.dart';

Future getPrefs<T>(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return await sharedPreferences.get(key);
}

Future setPrefs(String key, dynamic value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return await sharedPreferences.setString(key, value);
}