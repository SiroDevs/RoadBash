// Dart imports:
import 'dart:math' as math;

// Project imports:
import 'civilian_car.dart';

/// Lets riders look at the traffic around them: what blocks a line, which lane
/// is free, and how fast they can go without running into a vehicle.
mixin TrafficLookout {
  static const double _freeReach = 7500;
  static const double _brakeReach = 9500;
  static const double _brakeRate = 2600;
  static const double _bumper = 230;
  static const double _margin = 0.14;
  static const double _capMargin = 0.16;

  /// Every vehicle of the pool, whether on the road or parked out of sight.
  List<CivilianCar> get cars;

  /// Lateral position of the middle of each lane, from left to right.
  List<double> get laneCenters;

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
      final allowed = math.max(
        0.0,
        car.speed + math.sqrt(2 * _brakeRate * math.max(0.0, room)),
      );
      cap = cap == null ? allowed : math.min(cap, allowed);
    }
    return cap;
  }
}
