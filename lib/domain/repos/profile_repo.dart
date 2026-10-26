import '../models/player_profile.dart';

abstract interface class ProfileRepo {
  Future<PlayerProfile> load();
  Future<void> save(PlayerProfile profile);
}
