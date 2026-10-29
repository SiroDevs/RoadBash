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
