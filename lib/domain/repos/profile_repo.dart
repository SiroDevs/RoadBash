// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../common/constants/pref_constants.dart';
import '../models/engine_flavour.dart';
import '../models/player_profile.dart';
import 'prefs_repo.dart';

@lazySingleton
class ProfileRepo {
  ProfileRepo(this._prefs);

  final PrefsRepo _prefs;

  Future<PlayerProfile> load() async => PlayerProfile(
    name: _prefs.getPrefString(PrefConstants.playerNameKey),
    master: _readVolume(PrefConstants.masterVolKey, 1.0),
    music: _readVolume(PrefConstants.tyreVolKey, 0.7),
    engine: _readVolume(PrefConstants.engineVolKey, 0.8),
    effects: _readVolume('vol_effects', 0.8),
    flavour: EngineFlavour.fromId(
      _prefs.getPrefString(PrefConstants.engineFlavourKey),
    ),
    useScreenTouch: _readFlag(PrefConstants.useScreenTouchKey, false),
    mute: _readFlag(PrefConstants.muteKey, false),
    musicOn: _readFlag(PrefConstants.musicOnKey, true),
    effectsOn: _readFlag(PrefConstants.effectsOnKey, true),
    engineOn: _readFlag(PrefConstants.engineOnKey, true),
    invertTilt: _readFlag(PrefConstants.invertTiltKey, false),
  );

  double _readVolume(String key, double fallback) {
    if (!_prefs.keyExists(key)) return fallback;
    return (_prefs.getPrefInt(key) / 100).clamp(0.0, 1.0).toDouble();
  }

  /// Switches are stored as 0 / 1 (not with setPrefBool, which forgets `false`
  /// and would turn the "on by default" switches back on after a restart).
  bool _readFlag(String key, bool fallback) {
    if (!_prefs.keyExists(key)) return fallback;
    return _prefs.getPrefInt(key) == 1;
  }

  void _writeFlag(String key, bool value) =>
      _prefs.setPrefInt(key, value ? 1 : 0);

  Future<void> save(PlayerProfile profile) async {
    _prefs.setPrefString(PrefConstants.playerNameKey, profile.name);
    _prefs.setPrefInt(PrefConstants.masterVolKey, (profile.master * 100).round());
    _prefs.setPrefInt(PrefConstants.tyreVolKey, (profile.music * 100).round());
    _prefs.setPrefInt(PrefConstants.engineVolKey, (profile.engine * 100).round());
    _prefs.setPrefInt('vol_effects', (profile.effects * 100).round());
    _prefs.setPrefString(PrefConstants.engineFlavourKey, profile.flavour.id);
    _writeFlag(PrefConstants.useScreenTouchKey, profile.useScreenTouch);
    _writeFlag(PrefConstants.muteKey, profile.mute);
    _writeFlag(PrefConstants.musicOnKey, profile.musicOn);
    _writeFlag(PrefConstants.effectsOnKey, profile.effectsOn);
    _writeFlag(PrefConstants.engineOnKey, profile.engineOn);
    _writeFlag(PrefConstants.invertTiltKey, profile.invertTilt);
  }
}
