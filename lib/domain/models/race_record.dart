// Project imports:
import 'scene_id.dart';

class RaceRecord {
  const RaceRecord({
    required this.scene,
    required this.place,
    required this.timeMs,
    required this.playerName,
    required this.finishedAt,
  });

  final SceneId scene;
  final int place;
  final int timeMs;
  final String playerName;
  final DateTime finishedAt;

  bool get isWin => place == 1;
}
