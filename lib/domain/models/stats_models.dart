enum StatsRange {
  today(1),
  week(7),
  month(28),
  quarter(90),
  year(365);

  const StatsRange(this.days);

  final int days;

  int get heatmapDays => days < 7 ? 7 : days;
}

class PeriodStats {
  const PeriodStats({
    required this.days,
    required this.visitors,
    required this.players,
    required this.games,
  });

  factory PeriodStats.fromJson(Map<String, dynamic> json) => PeriodStats(
    days: (json['days'] as num).toInt(),
    visitors: (json['visitors'] as num).toInt(),
    players: (json['players'] as num).toInt(),
    games: (json['games'] as num).toInt(),
  );

  final int days;
  final int visitors;
  final int players;
  final int games;
}

class StatsSummary {
  const StatsSummary({
    required this.online,
    required this.onlinePlayers,
    required this.totalPlayers,
    required this.totalGames,
    required this.totalVisitors,
    required this.periods,
  });

  factory StatsSummary.fromJson(Map<String, dynamic> json) => StatsSummary(
    online: (json['online'] as num).toInt(),
    onlinePlayers: (json['online_players'] as num).toInt(),
    totalPlayers: (json['total_players'] as num).toInt(),
    totalGames: (json['total_games'] as num).toInt(),
    totalVisitors: (json['total_visitors'] as num).toInt(),
    periods: [
      for (final p in json['periods'] as List)
        PeriodStats.fromJson(Map<String, dynamic>.from(p as Map)),
    ],
  );

  final int online;
  final int onlinePlayers;
  final int totalPlayers;
  final int totalGames;
  final int totalVisitors;
  final List<PeriodStats> periods;

  PeriodStats? forDays(int days) {
    for (final p in periods) {
      if (p.days == days) return p;
    }
    return null;
  }
}

class StatsPoint {
  const StatsPoint({
    required this.time,
    required this.visitors,
    required this.players,
    required this.games,
  });

  factory StatsPoint.fromJson(Map<String, dynamic> json) => StatsPoint(
    time: DateTime.parse(json['t'] as String),
    visitors: (json['visitors'] as num).toInt(),
    players: (json['players'] as num).toInt(),
    games: (json['games'] as num).toInt(),
  );

  final DateTime time;
  final int visitors;
  final int players;
  final int games;
}

class HeatCell {
  const HeatCell({
    required this.day,
    required this.hour,
    required this.visitors,
    required this.players,
  });

  factory HeatCell.fromJson(Map<String, dynamic> json) => HeatCell(
    day: (json['dow'] as num).toInt(),
    hour: (json['hour'] as num).toInt(),
    visitors: (json['visitors'] as num).toInt(),
    players: (json['players'] as num).toInt(),
  );

  final int day;
  final int hour;
  final int visitors;
  final int players;
}
