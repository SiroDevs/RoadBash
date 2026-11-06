// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../config/vehicle_config.dart';
import 'civilian_car.dart';

/// A lane and a distance along the road where a vehicle can be placed.
typedef LaneSlot = ({int lane, double distance});

/// Picks the lane that keeps a new vehicle furthest from the traffic around it.
///
/// Where vehicles will be when the player reaches them is known as soon as one
/// is placed, because every lane drives at a steady speed.
class LaneGapCheck {
  const LaneGapCheck({required this.firstLane, required this.laneCount});

  static const double meetWindowSeconds = 2;
  static const double sampleSeconds = 0.25;
  static const double playerSpeedShare = 0.6;
  static const double minClosingSpeed = 1000;
  static const int maxPushes = 3;

  final int firstLane;
  final int laneCount;

  /// Finds the roomiest lane near [distance], moving up the road by [push] while every lane is crowded.
  LaneSlot findSlot({
    required List<CivilianCar> cars,
    required List<double> laneSpeeds,
    required int firstChoice,
    required double distance,
    required double playerDistance,
    required double clearGap,
    required double push,
    required double limit,
  }) {
    var position = distance;
    var best = (lane: firstChoice, gap: 0.0);
    for (var attempt = 0; attempt <= maxPushes; attempt++) {
      best = _roomiestLane(cars, laneSpeeds, firstChoice, position, playerDistance);
      final lastTry = attempt == maxPushes || position + push > limit;
      if (best.gap >= clearGap || lastTry) break;
      position += push;
    }
    return (lane: best.lane, distance: position);
  }

  ({int lane, double gap}) _roomiestLane(
    List<CivilianCar> cars,
    List<double> laneSpeeds,
    int firstChoice,
    double distance,
    double playerDistance,
  ) {
    var bestLane = firstChoice;
    var bestGap = -1.0;
    for (var offset = 0; offset < laneCount; offset++) {
      final lane = (firstChoice - firstLane + offset) % laneCount + firstLane;
      final speed = laneSpeeds[lane - firstLane];
      final gap = _closestGap(cars, lane, distance, speed, playerDistance);
      if (gap > bestGap) {
        bestGap = gap;
        bestLane = lane;
      }
    }
    return (lane: bestLane, gap: bestGap);
  }

  // Closest any vehicle gets while the player rides past the new vehicle.
  double _closestGap(
    List<CivilianCar> cars,
    int lane,
    double distance,
    double speed,
    double playerDistance,
  ) {
    final closing = VehicleConfig.maxSpeed * playerSpeedShare - speed;
    final meetSeconds = math.max(
      0.0,
      (distance - playerDistance) / math.max(closing, minClosingSpeed),
    );
    var closest = _gapAt(cars, distance, speed, 0);
    final last = meetSeconds + meetWindowSeconds;
    for (
      var seconds = math.max(0.0, meetSeconds - meetWindowSeconds);
      seconds <= last;
      seconds += sampleSeconds
    ) {
      closest = math.min(closest, _gapAt(cars, distance, speed, seconds));
    }
    return closest;
  }

  double _gapAt(
    List<CivilianCar> cars,
    double distance,
    double speed,
    double seconds,
  ) {
    final position = distance + speed * seconds;
    var closest = double.infinity;
    for (final car in cars) {
      if (!car.active || car.lane < firstLane) continue;
      if (car.lane >= firstLane + laneCount) continue;
      final gap = (car.distance + car.speed * seconds - position).abs();
      closest = math.min(closest, gap);
    }
    return closest;
  }
}
