// Project imports:
import '../../domain/models/stats_models.dart';

/// Reads an integer from JSON, defaulting to 0.
int _int(Map<String, dynamic> json, String key) => (json[key] as num).toInt();

/// Builds [PeriodStats] from JSON.
PeriodStats periodStatsFromJson(Map<String, dynamic> json) => PeriodStats(
  days: _int(json, 'days'),
  visitors: _int(json, 'visitors'),
  players: _int(json, 'players'),
  games: _int(json, 'games'),
);

/// Builds a [StatsSummary] from JSON.
StatsSummary statsSummaryFromJson(Map<String, dynamic> json) => StatsSummary(
  online: _int(json, 'online'),
  onlinePlayers: _int(json, 'online_players'),
  totalPlayers: _int(json, 'total_players'),
  totalGames: _int(json, 'total_games'),
  totalVisitors: _int(json, 'total_visitors'),
  periods: [
    for (final p in json['periods'] as List)
      periodStatsFromJson(Map<String, dynamic>.from(p as Map)),
  ],
);

/// Builds a [StatsPoint] from JSON.
StatsPoint statsPointFromJson(Map<String, dynamic> json) => StatsPoint(
  time: DateTime.parse(json['t'] as String),
  visitors: _int(json, 'visitors'),
  players: _int(json, 'players'),
  games: _int(json, 'games'),
);

/// Builds a [HeatCell] from JSON.
HeatCell heatCellFromJson(Map<String, dynamic> json) => HeatCell(
  day: _int(json, 'dow'),
  hour: _int(json, 'hour'),
  visitors: _int(json, 'visitors'),
  players: _int(json, 'players'),
);
