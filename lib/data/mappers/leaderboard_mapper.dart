// Project imports:
import '../../domain/models/leaderboard_entry.dart';

LeaderboardEntry leaderboardEntryFromJson(Map<String, dynamic> json) =>
    LeaderboardEntry(
      rank: (json['rank'] as num).toInt(),
      name: json['name'] as String,
      games: (json['games'] as num).toInt(),
      wins: (json['wins'] as num).toInt(),
    );
