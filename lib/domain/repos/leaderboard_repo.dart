// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../core/supabase/api_client.dart';
import '../models/leaderboard_entry.dart';

@lazySingleton
class LeaderboardRepo {
  LeaderboardRepo(this._api);

  final ApiClient _api;

  Future<List<LeaderboardEntry>> top({int limit = 50}) async {
    final res = await _api.call('rb_leaderboard', {'p_limit': limit});
    return [
      for (final e in res['data'] as List)
        LeaderboardEntry.fromJson(Map<String, dynamic>.from(e as Map)),
    ];
  }
}
