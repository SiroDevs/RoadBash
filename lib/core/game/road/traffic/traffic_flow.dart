// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../common/guardrail/guardrail_config.dart';
import '../config/vehicle_config.dart';
import '../track/road_track.dart';
import 'civilian_car.dart';
import 'traffic_profile.dart';

/// Keeps a fixed pool of civilian vehicles on the road ahead of the player.
///
/// Every lane has its own steady speed, so vehicles in one lane never catch
/// each other. A vehicle that falls behind the player is moved to the front of
/// the pack, so the road stays populated however far the race runs.
class TrafficFlow {
  TrafficFlow({
    required this.profile,
    required this.lanes,
    required this.track,
    required this.raceLength,
    required this.guarded,
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

  static const List<Color> _bodies = [
    Color(0xFFE8E8EC),
    Color(0xFF2F3A4F),
    Color(0xFFB3261E),
    Color(0xFF1F6FB5),
    Color(0xFF3C8D5A),
    Color(0xFFF2C21C),
    Color(0xFF8A8F98),
    Color(0xFF111418),
    Color(0xFFE67E22),
  ];

  static const List<Color> _accents = [
    Color(0xFFFFD60A),
    Color(0xFFFFFFFF),
    Color(0xFF39D0FF),
    Color(0xFFFF4D8D),
    Color(0xFF7CFF6B),
  ];

  final TrafficProfile profile;
  final int lanes;
  final RoadTrack track;
  final double raceLength;

  /// True on roads with a median guardrail that vehicles must keep clear of.
  final bool guarded;

  final math.Random _random;

  /// Every vehicle of the pool, whether on the road or parked out of sight.
  final List<CivilianCar> cars;

  /// Lateral position of the middle of each lane, from left to right.
  final List<double> laneCenters;

  late final List<double> laneSpeeds = [
    for (var k = 0; k < lanes; k++)
      (profile.minSpeed +
              (profile.maxSpeed - profile.minSpeed) *
                  (lanes > 1 ? k / (lanes - 1) : 0.5) +
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

    var front = playerDistance + TrafficProfile.startClear;
    for (final car in cars) {
      if (car.active && car.distance > front) front = car.distance;
    }
    final limit = raceLength - TrafficProfile.finishClear;
    for (final car in cars) {
      final spent =
          !car.active || car.distance < playerDistance - TrafficProfile.behind;
      if (!spent) continue;
      front += profile.spacing * (0.65 + 0.7 * _random.nextDouble());
      if (front > limit) {
        car.park();
      } else {
        _spawn(car, front);
      }
    }
  }

  /// Puts a vehicle in a random lane at [distance].
  void _spawn(CivilianCar car, double distance) {
    final lane = _random.nextInt(lanes);
    car.place(
      kind: _pickKind(lane),
      color: _bodies[_random.nextInt(_bodies.length)],
      accent: _accents[_random.nextInt(_accents.length)],
      distance: distance,
      lane: lane,
      lateral: laneCenters[lane],
      speed: laneSpeeds[lane],
      laneWidth: 2 / lanes,
    );
  }

  /// Picks a vehicle kind: trucks favour the slow left lane, never the fast one.
  CivilianKind _pickKind(int lane) {
    var total = 0;
    final weights = <int>[];
    for (final (kind, weight) in profile.kinds) {
      var w = weight;
      if (kind == CivilianKind.truck) {
        if (lane == 0) {
          w *= 2;
        } else if (lane == lanes - 1 && lanes > 2) {
          w = 0;
        }
      }
      weights.add(w);
      total += w;
    }
    if (total <= 0) return profile.kinds.first.$1;
    var roll = _random.nextInt(total);
    for (var i = 0; i < weights.length; i++) {
      if (roll < weights[i]) return profile.kinds[i].$1;
      roll -= weights[i];
    }
    return profile.kinds.first.$1;
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
