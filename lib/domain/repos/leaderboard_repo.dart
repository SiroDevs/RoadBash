// Project imports:
import '../models/leaderboard_entry.dart';

abstract interface class LeaderboardRepo {
  Future<List<LeaderboardEntry>> top({int limit = 50});
}
