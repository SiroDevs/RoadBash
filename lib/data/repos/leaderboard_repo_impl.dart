// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../domain/models/leaderboard_entry.dart';
import '../../domain/repos/leaderboard_repo.dart';
import '../mappers/leaderboard_mapper.dart';
import '../sources/remote/api_client.dart';

/// Reads the leaderboard from the API.
@LazySingleton(as: LeaderboardRepo)
class LeaderboardRepoImpl implements LeaderboardRepo {
  LeaderboardRepoImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<LeaderboardEntry>> top({int limit = 50}) async =>
      (await _api.call('rb_leaderboard', {'p_limit': limit})).rows(
        leaderboardEntryFromJson,
      );
}
