// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import '../../common/constants/pref_constants.dart';

@singleton
abstract class PrefsRepo {
  @factoryMethod
  factory PrefsRepo(SharedPreferences prefsRepository) = PrefsRepoImp;

  ThemeMode getThemeMode();

  Future<void> updateThemeMode(ThemeMode themeMode);

  bool getPrefBool(String settingsKey);
  int getPrefInt(String settingsKey);
  String getPrefString(String settingsKey);

  void setPrefBool(String settingsKey, bool settingsValue);
  void setPrefInt(String settingsKey, int settingsValue);
  void setPrefString(String settingsKey, String settingsValue);

  void clearData();
  void removeKeyPair(String settingsKey);
  bool keyExists(String settingsKey);
}

class PrefsRepoImp implements PrefsRepo {
  final SharedPreferences sharedPrefs;

  PrefsRepoImp(this.sharedPrefs);

  @override
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await sharedPrefs.setString(
      PrefConstants.appThemeKey,
      themeMode.toString(),
    );
  }

  @override
  ThemeMode getThemeMode() {
    switch (sharedPrefs.getString(PrefConstants.appThemeKey)) {
      case 'ThemeMode.light':
        return ThemeMode.light;

      case 'ThemeMode.dark':
        return ThemeMode.dark;

      default:
        return ThemeMode.system;
    }
  }

  @override
  void clearData() {
    sharedPrefs.remove(PrefConstants.appThemeKey);
    sharedPrefs.remove(PrefConstants.darkModeKey);
  }

  @override
  void removeKeyPair(String key) {
    sharedPrefs.remove(key);
  }

  @override
  bool keyExists(String key) {
    return sharedPrefs.containsKey(key);
  }

  @override
  bool getPrefBool(String settingsKey) {
    return sharedPrefs.getBool(settingsKey) ?? false;
  }

  @override
  int getPrefInt(String settingsKey) {
    return sharedPrefs.getInt(settingsKey) ?? 0;
  }

  @override
  String getPrefString(String settingsKey) {
    return sharedPrefs.getString(settingsKey) ?? '';
  }

  @override
  void setPrefBool(String settingsKey, bool settingsValue) async {
    if (!settingsValue) {
      sharedPrefs.remove(settingsKey);
      return;
    }
    await sharedPrefs.setBool(settingsKey, settingsValue);
  }

  @override
  void setPrefInt(String settingsKey, int settingsValue) async {
    if (settingsValue.isNegative) {
      sharedPrefs.remove(settingsKey);
      return;
    }
    await sharedPrefs.setInt(settingsKey, settingsValue);
  }

  @override
  void setPrefString(String settingsKey, String settingsValue) async {
    if (settingsValue.isEmpty) {
      sharedPrefs.remove(settingsKey);
      return;
    }
    await sharedPrefs.setString(settingsKey, settingsValue);
  }
}
