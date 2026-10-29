// Package imports:
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around local storage.
@singleton
class PrefsSource {
  PrefsSource(this._prefs);

  final SharedPreferences _prefs;

  /// Returns true when a value exists for the key.
  bool keyExists(String key) => _prefs.containsKey(key);

  /// Returns the boolean for a key, or false.
  bool getBool(String key) => _prefs.getBool(key) ?? false;
  /// Returns the integer for a key, or 0.
  int getInt(String key) => _prefs.getInt(key) ?? 0;
  /// Returns the string for a key, or empty.
  String getString(String key) => _prefs.getString(key) ?? '';

  /// Saves true, or removes the key when false.
  void setBool(String key, bool value) =>
      value ? _prefs.setBool(key, value) : _prefs.remove(key);

  /// Saves a non-negative integer, or removes the key.
  void setInt(String key, int value) =>
      value.isNegative ? _prefs.remove(key) : _prefs.setInt(key, value);

  /// Saves a non-empty string, or removes the key.
  void setString(String key, String value) =>
      value.isEmpty ? _prefs.remove(key) : _prefs.setString(key, value);

  /// Removes the value for a key.
  void remove(String key) => _prefs.remove(key);
}
