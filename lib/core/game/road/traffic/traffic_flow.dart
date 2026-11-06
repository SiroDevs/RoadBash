// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../common/objects/guardrail/guardrail_config.dart';
import '../config/vehicle_config.dart';
import '../track/road_track.dart';
import 'civilian_car.dart';
import 'civilian_palette.dart';
import 'lane_wall_check.dart';
import 'traffic_profile.dart';

/// Keeps a fixed pool of civilian vehicles on the road ahead of the player.
///
/// Every lane has its own steady speed, so vehicles in one lane never catch
/// each other. A vehicle left behind the player is moved to the front of the
/// pack, and is placed so traffic never lines up across every lane.
class TrafficFlow {
  TrafficFlow({
    required this.profile,
    required this.lanes,
    required this.track,
    required this.raceLength,
    required this.guarded,
    required this.trafficLanes,
    int seed = 1,
  }) : _random = math.Random(seed),
       cars = List.generate(profile.poolSize, CivilianCar.new),
       laneCenters = [
         for (var k = 0; k < lanes; k++) -1 + (2 / lanes) * (k + 0.5),
       ];

  static const double _freeReach = 7500;
  static const double _brakeReach = 9500;
  static const double _brakeRate = 2600;
  static const double _bumper = 230;
  static const double _margin = 0.14;
  static const double _capMargin = 0.16;
  static const int _maxPushes = 3;
  static const double _pushShare = 0.35;

  final TrafficProfile profile;
  final int lanes;
  final RoadTrack track;
  final double raceLength;

  /// True on roads with a median guardrail that vehicles must keep clear of.
  final bool guarded;

  /// How many lanes from the left edge the traffic drives in; it keeps left.
  final int trafficLanes;

  final math.Random _random;
  final List<CivilianCar> _spent = [];
  late final LaneWallCheck _wallCheck = LaneWallCheck(
    lanes: trafficLanes,
    roadLanes: lanes,
  );

  /// Every vehicle of the pool, whether on the road or parked out of sight.
  final List<CivilianCar> cars;

  /// Lateral position of the middle of each lane, from left to right.
  final List<double> laneCenters;

  late final List<double> laneSpeeds = [
    for (var k = 0; k < trafficLanes; k++)
      (profile.minSpeed +
              (profile.maxSpeed - profile.minSpeed) *
                  (trafficLanes > 1 ? k / (trafficLanes - 1) : 0.5) +
              (_random.nextDouble() - 0.5) * 0.03) *
          VehicleConfig.maxSpeed,
  ];

  /// Moves the vehicles and recycles the ones left behind.
  void update(double dt, double playerDistance, double playerZ) {
    for (final car in cars) {
      if (!car.active) continue;
      car.drive(dt);
      if (guarded) _hugLane(car, playerZ);
    }
    _recycle(playerDistance);
  }

  /// Moves vehicles left behind, and any not yet on the road, to the front.
  void _recycle(double playerDistance) {
    final cutoff = playerDistance - TrafficProfile.behind;
    _spent.clear();
    for (final car in cars) {
      if (!car.active || car.distance < cutoff) _spent.add(car);
    }
    if (_spent.isEmpty) return;
    for (final car in _spent) {
      car.park();
    }

    var front = playerDistance + TrafficProfile.startClear;
    for (final car in cars) {
      if (car.active && car.distance > front) front = car.distance;
    }
    for (final car in _spent) {
      front += profile.spacing * (0.8 + 0.4 * _random.nextDouble());
      if (front > _finishLimit) {
        car.park();
      } else {
        front = _spawn(car, front);
      }
    }
  }

  double get _finishLimit => raceLength - TrafficProfile.finishClear;

  /// Puts a vehicle on the road and returns where it was placed.
  ///
  /// Lanes that would line the vehicle up with traffic in every other lane are
  /// skipped; with none clear it moves a little further up the road.
  double _spawn(CivilianCar car, double distance) {
    final first = _random.nextInt(trafficLanes);
    final push = profile.spacing * _pushShare;
    var position = distance;
    var lane = first;
    for (var attempt = 0; attempt <= _maxPushes; attempt++) {
      final free = _wallCheck.freeLane(
        cars: cars,
        laneSpeeds: laneSpeeds,
        first: first,
        distance: position,
      );
      final lastTry = attempt == _maxPushes || position + push > _finishLimit;
      if (free != null || lastTry) {
        lane = free ?? first;
        break;
      }
      position += push;
    }
    car.place(
      kind: profile.pickKind(lane, trafficLanes, _random),
      color: CivilianPalette.randomBody(_random),
      accent: CivilianPalette.randomAccent(_random),
      distance: position,
      lane: lane,
      lateral: laneCenters[lane],
      speed: laneSpeeds[lane],
      laneWidth: 2 / lanes,
    );
    return position;
  }

  /// Keeps a vehicle clear of the median guardrail.
  void _hugLane(CivilianCar car, double playerZ) {
    final section = track.at(car.distance + playerZ).section;
    final limit = GuardrailConfig.riderLimit(section);
    final centre = laneCenters[car.lane];
    car.target = limit == null
        ? centre
        : math.min(centre, limit - car.halfWidth - 0.08);
  }

  /// True when a vehicle blocks [lateral] between just beside [distance] and
  /// [reach] units ahead of it.
  bool blocked(
    double distance,
    double lateral,
    double reach, {
    double margin = _margin,
  }) {
    for (final car in cars) {
      if (!car.active) continue;
      final gap = car.distance - distance;
      if (gap < -car.kind.length || gap > reach) continue;
      if ((car.lateral - lateral).abs() < car.halfWidth + margin) return true;
    }
    return false;
  }

  /// Returns a line that avoids the traffic ahead.
  ///
  /// Gives back [wanted] when the way is clear, a free lane when it is not, or
  /// [wanted] anyway when every lane is blocked, so the caller must slow down.
  double? freeLine(
    double distance,
    double lateral,
    double? wanted, {
    double limit = 0.92,
  }) {
    final goal = wanted ?? lateral;
    final goalBlocked = blocked(distance, goal, _freeReach);
    final nowBlocked = blocked(distance, lateral, _freeReach);
    if (!goalBlocked && !nowBlocked) return wanted;
    if (!goalBlocked) return goal;
    double? best;
    var bestCost = double.infinity;
    for (final centre in laneCenters) {
      final x = centre.clamp(-limit, limit).toDouble();
      if (blocked(distance, x, _freeReach)) continue;
      final cost = (x - lateral).abs() + 0.5 * (x - goal).abs();
      if (cost < bestCost) {
        bestCost = cost;
        best = x;
      }
    }
    return best ?? wanted;
  }

  /// The fastest a rider at [distance] and [lateral] can go and still stop
  /// behind the vehicle ahead, or null when the way is clear.
  double? speedCap(double distance, double lateral) {
    double? cap;
    for (final car in cars) {
      if (!car.active || car.distance < distance) continue;
      final room = car.distance - distance - _bumper;
      if (room > _brakeReach) continue;
      if ((car.lateral - lateral).abs() >= car.halfWidth + _capMargin) continue;
      final allowed =
          car.speed + math.sqrt(2 * _brakeRate * math.max(0.0, room));
      cap = cap == null ? allowed : math.min(cap, allowed);
    }
    return cap;
  }
}
