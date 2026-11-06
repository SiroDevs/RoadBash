// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../domain/models/level_rules.dart';
import '../../../../domain/models/scene_id.dart';
import 'civilian_car.dart';

/// How busy a scene's road is, what drives on it, and whether police patrol it.
class TrafficProfile {
  const TrafficProfile({
    required this.spacing,
    required this.minSpeed,
    required this.maxSpeed,
    required this.kinds,
    this.police = true,
    this.empty = false,
  });

  /// No civilian vehicle appears this close to the start line.
  static const double startClear = 12000;

  /// How far ahead of the player vehicles are kept on the road.
  static const double ahead = 36000;

  /// How far behind the player a vehicle may fall before it is recycled.
  static const double behind = 3200;

  /// No civilian vehicle is placed this close to the finish line.
  static const double finishClear = 4500;

  /// Average distance between vehicles, in road units.
  final double spacing;

  /// Speed of the slowest and fastest lane, as shares of the top speed.
  final double minSpeed, maxSpeed;

  /// Vehicle kinds with their relative weights.
  final List<(CivilianKind, int)> kinds;

  /// True when traffic police patrol this road.
  final bool police;

  /// True when the road has no civilian vehicles at all.
  final bool empty;

  /// Widens every road's gaps so the traffic stays thin enough to ride through.
  static const double gapStretch = 1.3;

  /// Number of vehicles needed to keep [ahead] of the player populated.
  int get poolSize => empty ? 0 : (ahead / spacing).ceil() + 3;

  /// Returns this road with the traffic of a level: the gaps between vehicles
  /// grow or shrink, or the road empties.
  TrafficProfile withDensity(TrafficDensity density) => TrafficProfile(
    spacing:
        spacing * gapStretch * (density.isNone ? 1 : density.spacingFactor),
    minSpeed: minSpeed,
    maxSpeed: maxSpeed,
    kinds: kinds,
    police: police,
    empty: density.isNone,
  );

  /// Picks a vehicle kind for [lane] of [laneCount] lanes by weight. Trucks
  /// favour the slow left lane, never the fast one of the lanes traffic uses.
  CivilianKind pickKind(int lane, int laneCount, math.Random random) {
    var total = 0;
    final weights = <int>[];
    for (final (kind, weight) in kinds) {
      var adjusted = weight;
      if (kind == CivilianKind.truck) {
        if (lane == 0) {
          adjusted *= 2;
        } else if (lane == laneCount - 1 && laneCount > 2) {
          adjusted = 0;
        }
      }
      weights.add(adjusted);
      total += adjusted;
    }
    if (total <= 0) return kinds.first.$1;
    var roll = random.nextInt(total);
    for (var index = 0; index < weights.length; index++) {
      if (roll < weights[index]) return kinds[index].$1;
      roll -= weights[index];
    }
    return kinds.first.$1;
  }

  /// Returns how many lanes the traffic of a scene uses, counted from the left
  /// edge. Traffic keeps left: on the two-way roads that is the lanes left of
  /// the yellow line, on Thika Road the whole carriageway, and on the roads
  /// with no yellow line the left lane.
  static int trafficLanes(SceneId scene, int lanes) => switch (scene) {
    SceneId.city || SceneId.suburbs => math.max(1, lanes ~/ 2),
    SceneId.thikaRoad => lanes,
    SceneId.jungle || SceneId.dirtRoad => 1,
  };

  /// Returns the traffic of a scene.
  static TrafficProfile of(SceneId scene) => switch (scene) {
    SceneId.city => const TrafficProfile(
      spacing: 6500,
      minSpeed: 0.20,
      maxSpeed: 0.42,
      kinds: [
        (CivilianKind.sedan, 6),
        (CivilianKind.matatu, 3),
        (CivilianKind.truck, 1),
      ],
    ),
    SceneId.suburbs => const TrafficProfile(
      spacing: 9000,
      minSpeed: 0.24,
      maxSpeed: 0.48,
      kinds: [
        (CivilianKind.sedan, 6),
        (CivilianKind.matatu, 2),
        (CivilianKind.truck, 1),
      ],
    ),
    SceneId.thikaRoad => const TrafficProfile(
      spacing: 6000,
      minSpeed: 0.22,
      maxSpeed: 0.45,
      kinds: [
        (CivilianKind.sedan, 4),
        (CivilianKind.matatu, 4),
        (CivilianKind.truck, 3),
      ],
    ),
    SceneId.jungle => const TrafficProfile(
      spacing: 16000,
      minSpeed: 0.14,
      maxSpeed: 0.30,
      kinds: [(CivilianKind.truck, 3), (CivilianKind.sedan, 1)],
      police: false,
    ),
    SceneId.dirtRoad => const TrafficProfile(
      spacing: 14000,
      minSpeed: 0.12,
      maxSpeed: 0.26,
      kinds: [(CivilianKind.truck, 2), (CivilianKind.matatu, 1)],
      police: false,
    ),
  };
}
