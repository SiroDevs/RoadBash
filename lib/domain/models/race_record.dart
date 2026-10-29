// Project imports:
import 'scene_id.dart';

/// One finished race saved to the player's history.
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

  /// True when the player finished first.
  bool get isWin => place == 1;
}
