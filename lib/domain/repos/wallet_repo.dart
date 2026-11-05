// Project imports:
import '../models/race_settlement.dart';
import '../models/scene_id.dart';

/// Contract for the wallet and for settling a race with the server.
abstract interface class WalletRepo {
  /// The wallet balance; it can be negative.
  Future<int> balance();

  /// Records a race and pays or charges what the level's rules say: the prize
  /// and bonuses for a win, the fine of an arrest, the bills of a nasty crash
  /// and a fine for every hit on traffic.
  Future<RaceSettlement> settle(
    RaceEnd end, {
    required SceneId scene,
    required int level,
    int place = 1,
    int timeMs = 0,
    bool newBest = false,
    bool clean = false,
    int trafficHits = 0,
    int crashKmh = 0,
  });
}
