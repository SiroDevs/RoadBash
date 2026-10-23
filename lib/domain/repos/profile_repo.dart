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
      );

  double _readVolume(String key, double fallback) {
    if (!_prefs.keyExists(key)) return fallback;
    return (_prefs.getPrefInt(key) / 100).clamp(0.0, 1.0).toDouble();
  }

  Future<void> save(PlayerProfile profile) async {
    _prefs.setPrefString(PrefConstants.playerNameKey, profile.name);
    _prefs.setPrefInt(PrefConstants.masterVolKey, (profile.master * 100).round());
    _prefs.setPrefInt(PrefConstants.tyreVolKey, (profile.music * 100).round());
    _prefs.setPrefInt(PrefConstants.engineVolKey, (profile.engine * 100).round());
    _prefs.setPrefInt('vol_effects', (profile.effects * 100).round());
    _prefs.setPrefString(PrefConstants.engineFlavourKey, profile.flavour.id);
  }
}
