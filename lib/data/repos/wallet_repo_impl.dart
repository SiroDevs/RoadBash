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
    int place = 1,
    int timeMs = 0,
    int fine = 0,
    int crashKmh = 0,
  }) async {
    final result = await switch (end) {
      RaceEnd.finished => _api.callAuthed('rb_record_game', {
        'p_scene': scene.name,
        'p_place': place,
        'p_time_ms': timeMs,
      }),
      RaceEnd.busted => _api.callAuthed('rb_charge_race', {
        'p_outcome': 'busted',
        'p_fine': fine,
      }),
      RaceEnd.crashed => _api.callAuthed('rb_charge_race', {
        'p_outcome': 'crashed',
        'p_crash_kmh': crashKmh,
      }),
    };
    return RaceSettlement(
      balance: (result['balance'] as num).toInt(),
      prize: (result['prize'] as num?)?.toInt() ?? 0,
      fine: (result['fine'] as num?)?.toInt() ?? 0,
      hospital: (result['hospital'] as num?)?.toInt() ?? 0,
      garage: (result['garage'] as num?)?.toInt() ?? 0,
    );
  }
}
