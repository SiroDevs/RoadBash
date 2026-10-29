// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../domain/models/engine_flavour.dart';
import '../../domain/models/player_profile.dart';
import '../../domain/repos/profile_repo.dart';
import '../sources/local/pref_keys.dart';
import '../sources/local/prefs_source.dart';

@LazySingleton(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl(this._prefs);

  final PrefsSource _prefs;

  @override
  Future<PlayerProfile> load() async => PlayerProfile(
    name: _prefs.getString(PrefKeys.playerName),
    master: _readVolume(PrefKeys.masterVol, 1.0),
    music: _readVolume(PrefKeys.tyreVol, 0.7),
    engine: _readVolume(PrefKeys.engineVol, 0.8),
    effects: _readVolume(PrefKeys.effectsVol, 0.8),
    flavour: EngineFlavour.fromId(_prefs.getString(PrefKeys.engineFlavour)),
    useScreenTouch: _readFlag(PrefKeys.useScreenTouch, false),
    mute: _readFlag(PrefKeys.mute, false),
    musicOn: _readFlag(PrefKeys.musicOn, true),
    effectsOn: _readFlag(PrefKeys.effectsOn, true),
    engineOn: _readFlag(PrefKeys.engineOn, true),
    invertTilt: _readFlag(PrefKeys.invertTilt, false),
    language: _prefs.getString(PrefKeys.language),
  );

  double _readVolume(String key, double fallback) {
    if (!_prefs.keyExists(key)) return fallback;
    return (_prefs.getInt(key) / 100).clamp(0.0, 1.0).toDouble();
  }

  bool _readFlag(String key, bool fallback) {
    if (!_prefs.keyExists(key)) return fallback;
    return _prefs.getInt(key) == 1;
  }

  void _writeVolume(String key, double value) =>
      _prefs.setInt(key, (value * 100).round());

  void _writeFlag(String key, bool value) => _prefs.setInt(key, value ? 1 : 0);

  @override
  Future<void> save(PlayerProfile profile) async {
    _prefs.setString(PrefKeys.playerName, profile.name);
    _writeVolume(PrefKeys.masterVol, profile.master);
    _writeVolume(PrefKeys.tyreVol, profile.music);
    _writeVolume(PrefKeys.engineVol, profile.engine);
    _writeVolume(PrefKeys.effectsVol, profile.effects);
    _prefs.setString(PrefKeys.engineFlavour, profile.flavour.id);
    _writeFlag(PrefKeys.useScreenTouch, profile.useScreenTouch);
    _writeFlag(PrefKeys.mute, profile.mute);
    _writeFlag(PrefKeys.musicOn, profile.musicOn);
    _writeFlag(PrefKeys.effectsOn, profile.effectsOn);
    _writeFlag(PrefKeys.engineOn, profile.engineOn);
    _writeFlag(PrefKeys.invertTilt, profile.invertTilt);
    _prefs.setString(PrefKeys.language, profile.language);
  }
}
