// Project imports:
import '../../../domain/models/scene_id.dart';
import '../../../domain/models/traffic_offence.dart';

/// Formats seconds as minutes and seconds with tenths.
String formatTime(double seconds, {bool short = false}) {
  final tenths = (seconds * 10).round();
  final minutes = tenths ~/ 600;
  final rest = tenths % 600;
  final ss = '${(rest ~/ 10).toString().padLeft(2, '0')}.${rest % 10}';
  return (short && minutes == 0) ? ss : '$minutes:$ss';
}

/// One row of the results table.
class ResultRow {
  const ResultRow({
    required this.place,
    required this.name,
    required this.seconds,
    required this.isPlayer,
  });

  final int place;
  final String name;
  final double seconds;
  final bool isPlayer;
}

/// Final standings of a race.
class RaceResult {
  const RaceResult({
    required this.scene,
    required this.rows,
    this.busted = false,
    this.fine = 0,
    this.crashed = false,
    this.crashKmh = 0,
    this.level = 1,
    this.trafficHits = 0,
    this.bashes = 0,
    this.offences = const {},
  });

  final SceneId scene;
  final List<ResultRow> rows;

  /// True when the police arrested the player before the finish.
  final bool busted;

  /// Fine for the arrest, in shillings; 0 when not busted.
  final int fine;

  /// True when a nasty crash ended the race before the finish.
  final bool crashed;

  /// Speed of the nasty crash in km/h; 0 when there was none.
  final int crashKmh;

  /// The level the race was run at.
  final int level;

  /// How many times the player hit civilian traffic.
  final int trafficHits;

  /// How many times the player bashed a rival.
  final int bashes;

  /// The traffic offences the player committed, with the count of each.
  final Map<TrafficOffence, int> offences;

  /// The player's row in the standings.
  ResultRow get player => rows.firstWhere((r) => r.isPlayer);

  /// True when the player reached the finish line: no arrest, no crash.
  bool get finished => !busted && !crashed;

  /// True when the player crossed the line first.
  bool get won => finished && player.place == 1;
}
