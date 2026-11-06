// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../domain/models/scene_id.dart';
import 'civilian_car.dart';
import 'lane_gap_check.dart';

/// How busy a scene's road is, what drives on it, and whether police patrol it.
class TrafficProfile {
  const TrafficProfile({
    required this.minSpeed,
    required this.maxSpeed,
    required this.kinds,
    this.police = true,
    this.empty = false,
    this.spacing = 0,
    this.oncomingSpacing = 0,
  });

  /// No civilian vehicle appears this close to the start line.
  static const double startClear = 12000;

  /// How far ahead of the player vehicles are kept on the road.
  static const double ahead = 36000;

  /// How far behind the player a vehicle may fall before it is recycled.
  static const double behind = 3200;

  /// No civilian vehicle is placed this close to the finish line.
  static const double finishClear = 4500;

  /// Average distance between vehicles on the left lanes; zero when none.
  final double spacing;

  /// Speed of the slowest and fastest lane, as shares of the top speed.
  final double minSpeed, maxSpeed;

  /// Vehicle kinds with their relative weights.
  final List<(CivilianKind, int)> kinds;

  /// True when traffic police patrol this road.
  final bool police;

  /// True when the road has no civilian vehicles at all.
  final bool empty;

  /// Average distance between oncoming vehicles; zero when none drive toward the player.
  final double oncomingSpacing;

  /// The tightest gap asked between vehicles in different lanes.
  static const double maxClearGap = 4500;

  /// Number of vehicles needed to keep [ahead] of the player populated.
  int get poolSize => spacing <= 0 ? 0 : (ahead / spacing).ceil() + 3;

  /// Number of oncoming vehicles needed to fill the road from end to end.
  int get oncomingPoolSize => oncomingSpacing <= 0
      ? 0
      : ((ahead + behind) / (oncomingSpacing * 0.8)).ceil() + 3;

  /// Closest two vehicles in different lanes may come while the player passes.
  double get clearGap => math.min(spacing * 0.5, maxClearGap);

  /// Closest two oncoming vehicles in different lanes may come.
  double get oncomingClearGap => math.min(oncomingSpacing * 0.5, maxClearGap);

  /// Returns this road with the traffic of a level: [sameWay] vehicles per lap
  /// on the left lanes and [oncoming] on the right lanes, over a lap of
  /// [lapLength] road units.
  ///
  /// A vehicle crawling along is met less often than one standing still, and an
  /// oncoming one more often, so the gaps are scaled to make the player meet
  /// about the asked number of vehicles in a lap.
  TrafficProfile withCounts({
    required int sameWay,
    required int oncoming,
    required double lapLength,
  }) {
    final meanSpeedShare = (minSpeed + maxSpeed) / 2;
    final speedRatio = meanSpeedShare / LaneGapCheck.playerSpeedShare;
    return TrafficProfile(
      minSpeed: minSpeed,
      maxSpeed: maxSpeed,
      kinds: kinds,
      police: police,
      empty: sameWay <= 0 && oncoming <= 0,
      spacing: sameWay > 0
          ? lapLength / sameWay * math.max(0.2, 1 - speedRatio)
          : 0,
      oncomingSpacing: oncoming > 0
          ? lapLength / oncoming * (1 + speedRatio)
          : 0,
    );
  }

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

  /// Returns how many lanes carry oncoming traffic: the lanes right of the
  /// yellow line on the two-way roads, none elsewhere.
  static int oncomingLanes(SceneId scene, int lanes) => switch (scene) {
    SceneId.city || SceneId.suburbs => lanes - trafficLanes(scene, lanes),
    SceneId.thikaRoad || SceneId.jungle || SceneId.dirtRoad => 0,
  };

  /// Returns the traffic of a scene.
  static TrafficProfile of(SceneId scene) => switch (scene) {
    SceneId.city => const TrafficProfile(
      minSpeed: 0.20,
      maxSpeed: 0.42,
      kinds: [
        (CivilianKind.sedan, 6),
        (CivilianKind.matatu, 3),
        (CivilianKind.truck, 1),
      ],
    ),
    SceneId.suburbs => const TrafficProfile(
      minSpeed: 0.24,
      maxSpeed: 0.48,
      kinds: [
        (CivilianKind.sedan, 6),
        (CivilianKind.matatu, 2),
        (CivilianKind.truck, 1),
      ],
    ),
    SceneId.thikaRoad => const TrafficProfile(
      minSpeed: 0.22,
      maxSpeed: 0.45,
      kinds: [
        (CivilianKind.sedan, 4),
        (CivilianKind.matatu, 4),
        (CivilianKind.truck, 3),
      ],
    ),
    SceneId.jungle => const TrafficProfile(
      minSpeed: 0.14,
      maxSpeed: 0.30,
      kinds: [(CivilianKind.truck, 3), (CivilianKind.sedan, 1)],
      police: false,
    ),
    SceneId.dirtRoad => const TrafficProfile(
      minSpeed: 0.12,
      maxSpeed: 0.26,
      kinds: [(CivilianKind.truck, 2), (CivilianKind.matatu, 1)],
      police: false,
    ),
  };
}
