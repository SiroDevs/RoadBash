/// The time a leaderboard covers.
enum LeaderboardPeriod {
  thisWeek('week'),
  lastWeek('last_week'),
  allTime('all');

  const LeaderboardPeriod(this.code);

  /// The name the backend knows the period by.
  final String code;
}

/// One row of the leaderboard.
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.games,
    required this.wins,
  });

  final int rank;
  final String name;
  final int games;
  final int wins;
}

/// The leaderboard of one period, with the dates it covers.
class Leaderboard {
  const Leaderboard({
    required this.period,
    required this.entries,
    this.from,
    this.to,
  });

  final LeaderboardPeriod period;
  final List<LeaderboardEntry> entries;

  /// First moment of the period, or null for all time.
  final DateTime? from;

  /// First moment after the period, or null for all time.
  final DateTime? to;
}
