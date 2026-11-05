// Project imports:
import '../models/race_settlement.dart';
import '../models/scene_id.dart';

/// Contract for the wallet and for settling a race with the server.
abstract interface class WalletRepo {
  /// The wallet balance; it can be negative.
  Future<int> balance();

  /// Records a finished race and pays its prize, or charges a fine or a crash.
  Future<RaceSettlement> settle(
    RaceEnd end, {
    required SceneId scene,
    int place = 1,
    int timeMs = 0,
    int fine = 0,
    int crashKmh = 0,
  });
}
