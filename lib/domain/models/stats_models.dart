/// Time ranges for the stats screen.
enum StatsRange {
  today(1),
  week(7),
  month(28),
  quarter(90),
  year(365);

  const StatsRange(this.days);

  final int days;

  /// Number of days shown in the heatmap, at least 7.
  int get heatmapDays => days < 7 ? 7 : days;
}

/// Visitor and player totals for a period.
class PeriodStats {
  const PeriodStats({
    required this.days,
    required this.visitors,
    required this.players,
    required this.games,
  });

  final int days;
  final int visitors;
  final int players;
  final int games;
}

/// Overall stats: online count and totals per period.
class StatsSummary {
  const StatsSummary({
    required this.online,
    required this.onlinePlayers,
    required this.totalPlayers,
    required this.totalGames,
    required this.totalVisitors,
    required this.periods,
  });

  final int online;
  final int onlinePlayers;
  final int totalPlayers;
  final int totalGames;
  final int totalVisitors;
  final List<PeriodStats> periods;

  /// Returns the stats for a period of [days], or null.
  PeriodStats? forDays(int days) {
    for (final p in periods) {
      if (p.days == days) return p;
    }
    return null;
  }
}

/// Visitors and players at one point in time.
class StatsPoint {
  const StatsPoint({
    required this.time,
    required this.visitors,
    required this.players,
    required this.games,
  });

  final DateTime time;
  final int visitors;
  final int players;
  final int games;
}

/// Activity at one day and hour of the heatmap.
class HeatCell {
  const HeatCell({
    required this.day,
    required this.hour,
    required this.visitors,
    required this.players,
  });

  final int day;
  final int hour;
  final int visitors;
  final int players;
}
