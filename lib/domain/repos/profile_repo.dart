// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../common/constants/pref_constants.dart';
import '../../data/app_database.dart';
import '../../data/entities/profile_entity.dart';
import '../models/engine_flavour.dart';
import '../models/player_profile.dart';
import 'prefs_repo.dart';

@lazySingleton
class ProfileRepo {
  ProfileRepo(this._db, this._prefs);

  final AppDatabase _db;
  final PrefsRepo _prefs;

  Future<PlayerProfile> load() async {
    final flavour = EngineFlavour.fromId(
      _prefs.getPrefString(PrefConstants.engineFlavourKey),
    );
    final e = await _db.profileDao.find();
    if (e == null) return PlayerProfile(flavour: flavour);
    return PlayerProfile(
      name: e.name,
      master: e.master / 100,
      music: e.music / 100,
      engine: e.engine / 100,
      effects: e.effects / 100,
      flavour: flavour,
    );
  }

  Future<void> save(PlayerProfile p) async {
    _prefs.setPrefString(PrefConstants.engineFlavourKey, p.flavour.id);
    await _db.profileDao.save(
      ProfileEntity(
        1,
        p.name,
        (p.master * 100).round(),
        (p.music * 100).round(),
        (p.engine * 100).round(),
        (p.effects * 100).round(),
      ),
    );
  }
}
