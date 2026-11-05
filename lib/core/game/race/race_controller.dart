// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../domain/models/level_rules.dart';
import '../../../domain/models/scene_id.dart';
import '../rider/look/rider_look.dart';
import '../rider/look/rider_looks.dart';
import '../road/config/road_config.dart';
import '../road/config/vehicle_config.dart';
import 'race_result.dart';
import 'rival/rival_tracker.dart';

/// A rival rider's name, pace, phase, look and temperament.
class RiderRival {
  const RiderRival(
    this.name,
    this.pace,
    this.phase, [
    this.look = RiderLook.main,
    this.aggression = 0.5,
    this.focus = 0.5,
    this.grit = 0.5,
  ]);

  final String name;
  final double pace;
  final double phase;
  final RiderLook look;
  final double aggression;
  final double focus;
  final double grit;
}

/// Tracks the countdown, laps, finish and rival positions.
class RaceController {
  RaceController({
    required this.scene,
    required this.laps,
    required this.lapLength,
    this.runOut = 0,
    required this.playerName,
    required this.rules,
    this.rivals = defaultRivals,
    double briefingSeconds = 0,
  }) : briefing = briefingSeconds;

  static const List<RiderRival> defaultRivals = [
    RiderRival('Mike', 0.86, 0.0, RiderLooks.mike, 0.8, 0.8, 0.7),
    RiderRival('Bose', 0.82, 1.7, RiderLooks.bose, 0.5, 0.6, 0.8),
    RiderRival('Sam', 0.78, 3.1, RiderLooks.sam, 0.65, 0.4, 0.5),
    RiderRival('Kamau', 0.72, 4.4, RiderLooks.kamau, 0.3, 0.85, 0.4),
    RiderRival('Brayo', 0.66, 5.6, RiderLooks.brayo, 0.9, 0.3, 0.6),
  ];

  /// Rivals for a level: the slowest line up first, so each level adds a
  /// faster rider, and every rider's pace follows the level's speed limit.
  static List<RiderRival> lineup(LevelRules rules) {
    final share = rules.speedShare(VehicleConfig.topSpeedKmh);
    return [
      for (final r in defaultRivals.reversed.take(rules.rivals))
        RiderRival(
          r.name,
          r.pace * share,
          r.phase,
          r.look,
          r.aggression,
          r.focus,
          r.grit,
        ),
    ];
  }

  final SceneId scene;
  final int laps;
  final double lapLength;

  /// The rules of the level being raced.
  final LevelRules rules;

  final double runOut;
  final String playerName;
  final List<RiderRival> rivals;
  final RivalTracker rivalTracker = RivalTracker();

  double countdown = 3.0, elapsed = 0, raceClock = 0;
  double finishTime = 0, progress = 0;
  int lap = 1, position = 1;
  RiderRival? nearest;
  bool finished = false, playerAhead = true;
  double gapSeconds = 0;

  /// True when the police arrested the player; the race ends without a finish.
  bool busted = false;

  /// Fine for the arrest, in shillings.
  int fine = 0;

  /// True when a nasty crash ended the race; the rider did not get up.
  bool crashedOut = false;

  /// Speed of the nasty crash, in km/h.
  int crashKmh = 0;

  /// Seconds left of the pre-race briefing that shows the level's hints.
  double briefing;

  /// How many times the player hit traffic and bashed a rival.
  int trafficHits = 0, bashes = 0;

  /// Total race distance.
  double get raceLength => lapLength * laps - runOut;
  /// True when the scene is run in laps rather than as one long road.
  bool get countsLaps => laps > 1;

  /// Kilometres left to the finish line.
  double remainingKm(double playerDistance) =>
      math.max(0.0, raceLength - playerDistance) * RoadConfig.unitKm;

  /// True while the race is underway.
  bool get running => countdown <= 0 && !finished;

  /// Ends the race with an arrest.
  void bust(int fine) {
    if (finished) return;
    busted = true;
    this.fine = fine;
    finished = true;
    finishTime = elapsed;
  }

  /// True when the race ended without a finish: an arrest or a nasty crash.
  bool get endedEarly => busted || crashedOut;

  /// Ends the race with a nasty crash at [kmh].
  void crashOut(int kmh) {
    if (finished) return;
    crashedOut = true;
    crashKmh = kmh;
    finished = true;
    finishTime = elapsed;
  }

  /// Advances the briefing, countdown, clock and finish state.
  void update(double dt, double playerDistance, double playerSpeed) {
    if (briefing > 0) {
      briefing -= dt;
      return;
    }
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
      final signed = rivalTracker.distanceOf(r.name) - playerDistance;
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

  /// Builds the final standings with the player and rivals.
  RaceResult buildResult() {
    final times = <(String, double, bool)>[
      (playerName, finishTime, true),
      for (final r in rivals) (r.name, rivalTracker.finishTimeOf(r.name, raceLength, elapsed), false),
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
      busted: busted,
      fine: fine,
      crashed: crashedOut,
      crashKmh: crashKmh,
      level: rules.level,
      trafficHits: trafficHits,
      bashes: bashes,
    );
  }
}
