import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class PrefsSource {
  PrefsSource(this._prefs);

  final SharedPreferences _prefs;

  bool keyExists(String key) => _prefs.containsKey(key);

  bool getBool(String key) => _prefs.getBool(key) ?? false;
  int getInt(String key) => _prefs.getInt(key) ?? 0;
  String getString(String key) => _prefs.getString(key) ?? '';

  void setBool(String key, bool value) =>
      value ? _prefs.setBool(key, value) : _prefs.remove(key);

  void setInt(String key, int value) =>
      value.isNegative ? _prefs.remove(key) : _prefs.setInt(key, value);

  void setString(String key, String value) =>
      value.isEmpty ? _prefs.remove(key) : _prefs.setString(key, value);

  void remove(String key) => _prefs.remove(key);
}
