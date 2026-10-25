class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.games,
    required this.wins,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        rank: (json['rank'] as num).toInt(),
        name: json['name'] as String,
        games: (json['games'] as num).toInt(),
        wins: (json['wins'] as num).toInt(),
      );

  final int rank;
  final String name;
  final int games;
  final int wins;
}
