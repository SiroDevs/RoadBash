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

  final int day;
  final int hour;
  final int visitors;
  final int players;
}
