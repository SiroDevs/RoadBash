// Project imports:
import '../../../domain/models/scene_id.dart';

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
  const RaceResult({required this.scene, required this.rows});

  final SceneId scene;
  final List<ResultRow> rows;

  /// The player's row in the standings.
  ResultRow get player => rows.firstWhere((r) => r.isPlayer);
}
