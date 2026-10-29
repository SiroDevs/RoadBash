// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../domain/models/scene_id.dart';
import 'race_result.dart';
import '../rider/look/rider_look.dart';
import '../rider/look/rider_looks.dart';
import '../road/config/vehicle_config.dart';

class RiderRival {
  const RiderRival(this.name, this.pace, this.phase, [this.look = RiderLook.main]);

  final String name;
  final double pace;
  final double phase;
  final RiderLook look;
}

class RaceController {
  RaceController({
    required this.scene,
    required this.laps,
    required this.lapLength,
    this.runOut = 0,
    required this.playerName,
    this.rivals = defaultRivals,
  });

  static const List<RiderRival> defaultRivals = [
    RiderRival('Mike', 0.86, 0.0, RiderLooks.mike),
    RiderRival('Bose', 0.82, 1.7, RiderLooks.bose),
    RiderRival('Sam', 0.78, 3.1, RiderLooks.sam),
    RiderRival('Kamau', 0.72, 4.4, RiderLooks.kamau),
    RiderRival('Brayo', 0.66, 5.6, RiderLooks.brayo),
  ];

  static const double _surgeAmp = 2500;
  static const double _surgeFreq = 0.35;

  final SceneId scene;
  final int laps;
  final double lapLength;

  /// Road after the finish line that the last lap still has left, which is
  /// not part of the race.
  final double runOut;
  final String playerName;
  final List<RiderRival> rivals;

  double countdown = 3.0, elapsed = 0, raceClock = 0;
  double finishTime = 0, progress = 0;
  int lap = 1, position = 1;
  RiderRival? nearest;
  bool finished = false, playerAhead = true;
  double gapSeconds = 0;

  double get raceLength => lapLength * laps - runOut;
  bool get running => countdown <= 0 && !finished;

  double rivalDistance(RiderRival r, double t) =>
      r.pace * VehicleConfig.maxSpeed * t +
      _surgeAmp * (math.sin(_surgeFreq * t + r.phase) - math.sin(r.phase));

  double rivalFinishTime(RiderRival r) {
    var lo = 0.0;
    var hi = raceLength / (r.pace * VehicleConfig.maxSpeed) + 20;
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
    raceClock += dt;
    if (finished) return;
    elapsed += dt;
    progress = math.min(1.0, playerDistance / raceLength);
    lap = math.min(laps, playerDistance ~/ lapLength + 1);

    var ahead = 0;
    var bestDiff = double.infinity;
    var bestSigned = 0.0;
    RiderRival? best;
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
