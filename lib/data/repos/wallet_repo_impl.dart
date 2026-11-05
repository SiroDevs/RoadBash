// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../domain/models/race_settlement.dart';
import '../../domain/models/scene_id.dart';
import '../../domain/repos/wallet_repo.dart';
import '../sources/remote/api_client.dart';

/// Reads the wallet and settles races through the API.
@LazySingleton(as: WalletRepo)
class WalletRepoImpl implements WalletRepo {
  WalletRepoImpl(this._api);

  final ApiClient _api;

  @override
  Future<int> balance() async {
    final result = await _api.callAuthed('rb_my_wallet');
    return (result['balance'] as num).toInt();
  }

  @override
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
  }) async {
    final result = await _api.callAuthed('rb_settle_race', {
      'p_scene': scene.name,
      'p_level': level,
      'p_outcome': end.name,
      'p_place': place,
      'p_time_ms': timeMs,
      'p_new_best': newBest,
      'p_clean': clean,
      'p_traffic_hits': trafficHits,
      'p_crash_kmh': crashKmh,
    });
    int amount(String key) => (result[key] as num?)?.toInt() ?? 0;
    return RaceSettlement(
      balance: amount('balance'),
      prize: amount('prize'),
      bestBonus: amount('best_bonus'),
      cleanBonus: amount('clean_bonus'),
      traffic: amount('traffic'),
      fine: amount('fine'),
      hospital: amount('hospital'),
      garage: amount('garage'),
    );
  }
}
