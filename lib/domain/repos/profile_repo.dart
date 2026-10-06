// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../data/local/app_database.dart';
import '../../data/local/entities/profile_entity.dart';
import '../models/player_profile.dart';

@lazySingleton
class ProfileRepo {
  ProfileRepo(this._db);

  final AppDatabase _db;

  Future<PlayerProfile> load() async {
    final e = await _db.profileDao.find();
    if (e == null) return const PlayerProfile();
    return PlayerProfile(
      name: e.name,
      master: e.master / 100,
      music: e.music / 100,
      engine: e.engine / 100,
      effects: e.effects / 100,
    );
  }

  Future<void> save(PlayerProfile p) => _db.profileDao.save(ProfileEntity(
        1,
        p.name,
        (p.master * 100).round(),
        (p.music * 100).round(),
        (p.engine * 100).round(),
        (p.effects * 100).round(),
      ));
}
