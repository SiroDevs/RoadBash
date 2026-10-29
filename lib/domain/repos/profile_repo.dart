// Project imports:
import '../models/player_profile.dart';

/// Contract for loading and saving the player profile.
abstract interface class ProfileRepo {
  Future<PlayerProfile> load();
  Future<void> save(PlayerProfile profile);
}
