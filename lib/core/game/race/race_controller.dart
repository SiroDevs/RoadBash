// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../domain/models/scene_id.dart';
import '../road/road_config.dart';
import 'race_result.dart';

/// A computer rider. It has no sprite yet: its progress is a formula, which
/// is enough to drive the HUD position and the gap timer.
class Rival {
  const Rival(this.name, this.pace, this.phase);

  final String name;
  final double pace;
  final double phase;
}

/// Countdown, race clock, rival progress, position and finishing.
class RaceController {
  RaceController({
    required this.scene,
    required this.laps,
    required this.lapLength,
    required this.playerName,
    this.rivals = defaultRivals,
  });

  static const List<Rival> defaultRivals = [
    Rival('Mike', 0.86, 0.0),
    Rival('Bose', 0.82, 1.7),
    Rival('Sam', 0.78, 3.1),
    Rival('Kamau', 0.72, 4.4),
    Rival('Achieng', 0.66, 5.6),
  ];

  static const double _surgeAmp = 2500;
  static const double _surgeFreq = 0.35;

  final SceneId scene;
  final int laps;
  final double lapLength;
  final String playerName;
  final List<Rival> rivals;

  double countdown = 3.0;
  double elapsed = 0;
  bool finished = false;
  double finishTime = 0;
  double progress = 0;
  int lap = 1;
  int position = 1;
  Rival? nearest;
  bool playerAhead = true;
  double gapSeconds = 0;

  double get raceLength => lapLength * laps;
  bool get running => countdown <= 0 && !finished;

  double rivalDistance(Rival r, double t) =>
      r.pace * RoadConfig.maxSpeed * t +
      _surgeAmp * (math.sin(_surgeFreq * t + r.phase) - math.sin(r.phase));

  /// Time at which [r] crosses the line, found by bisection.
  double rivalFinishTime(Rival r) {
    var lo = 0.0;
    var hi = raceLength / (r.pace * RoadConfig.maxSpeed) + 20;
    for (var i = 0; i < 40; i++) {
      final mid = (lo + hi) / 2;
      if (rivalDistance(r, mid) < raceLength) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return hi;
  }

  void update(double dt, double playerDistance, double playerSpeed) {
    if (countdown > 0) {
      countdown -= dt;
      return;
    }
    if (finished) return;
    elapsed += dt;
    progress = math.min(1.0, playerDistance / raceLength);
    lap = math.min(laps, playerDistance ~/ lapLength + 1);

    var ahead = 0;
    var bestDiff = double.infinity;
    var bestSigned = 0.0;
    Rival? best;
    for (final r in rivals) {
      final signed = rivalDistance(r, elapsed) - playerDistance;
      if (signed > 0) ahead++;
      if (signed.abs() < bestDiff) {
        bestDiff = signed.abs();
        bestSigned = signed;
        best = r;
      }
    }
    position = ahead + 1;
    nearest = best;
    playerAhead = bestSigned <= 0;
    gapSeconds = math.min(99.999, bestDiff / math.max(playerSpeed, 3000));

    if (playerDistance >= raceLength) {
      finished = true;
      finishTime = elapsed;
    }
  }

  RaceResult buildResult() {
    final times = <(String, double, bool)>[
      (playerName, finishTime, true),
      for (final r in rivals) (r.name, rivalFinishTime(r), false),
    ]..sort((a, b) => a.$2.compareTo(b.$2));
    return RaceResult(
      scene: scene,
      rows: [
        for (var i = 0; i < times.length; i++)
          ResultRow(
            place: i + 1,
            name: times[i].$1,
            seconds: times[i].$2,
            isPlayer: times[i].$3,
          ),
      ],
    );
  }
}
