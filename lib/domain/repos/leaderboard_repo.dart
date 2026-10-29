// Project imports:
import '../models/leaderboard_entry.dart';

/// Contract for reading the leaderboard.
abstract interface class LeaderboardRepo {
  Future<List<LeaderboardEntry>> top({int limit = 50});
}
