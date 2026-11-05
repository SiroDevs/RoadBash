// Project imports:
import '../../domain/models/leaderboard_entry.dart';
import '../sources/remote/api_client.dart';

/// Builds a [LeaderboardEntry] from JSON.
LeaderboardEntry leaderboardEntryFromJson(Map<String, dynamic> json) =>
    LeaderboardEntry(
      rank: (json['rank'] as num).toInt(),
      name: json['name'] as String,
      games: (json['games'] as num).toInt(),
      wins: (json['wins'] as num).toInt(),
    );

/// Builds a [Leaderboard] for [period] from JSON.
Leaderboard leaderboardFromJson(
  LeaderboardPeriod period,
  Map<String, dynamic> json,
) {
  final from = json['from'] as String?;
  final to = json['to'] as String?;
  return Leaderboard(
    period: period,
    entries: json.rows(leaderboardEntryFromJson),
    from: from == null ? null : DateTime.parse(from),
    to: to == null ? null : DateTime.parse(to),
  );
}
