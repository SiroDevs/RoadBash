// Project imports:
import '../../../domain/models/scene_id.dart';

String formatTime(double seconds, {bool short = false}) {
  final tenths = (seconds * 10).round();
  final m = tenths ~/ 600;
  final rest = tenths % 600;
  final ss = '${(rest ~/ 10).toString().padLeft(2, '0')}.${rest % 10}';
  return (short && m == 0) ? ss : '$m:$ss';
}

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

class RaceResult {
  const RaceResult({required this.scene, required this.rows});

  final SceneId scene;
  final List<ResultRow> rows;

  ResultRow get player => rows.firstWhere((r) => r.isPlayer);
}
