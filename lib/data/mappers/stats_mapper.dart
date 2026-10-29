// Project imports:
import '../../domain/models/stats_models.dart';

int _int(Map<String, dynamic> json, String key) => (json[key] as num).toInt();

PeriodStats periodStatsFromJson(Map<String, dynamic> json) => PeriodStats(
  days: _int(json, 'days'),
  visitors: _int(json, 'visitors'),
  players: _int(json, 'players'),
  games: _int(json, 'games'),
);

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

StatsPoint statsPointFromJson(Map<String, dynamic> json) => StatsPoint(
  time: DateTime.parse(json['t'] as String),
  visitors: _int(json, 'visitors'),
  players: _int(json, 'players'),
  games: _int(json, 'games'),
);

HeatCell heatCellFromJson(Map<String, dynamic> json) => HeatCell(
  day: _int(json, 'dow'),
  hour: _int(json, 'hour'),
  visitors: _int(json, 'visitors'),
  players: _int(json, 'players'),
);
