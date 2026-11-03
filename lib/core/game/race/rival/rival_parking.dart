// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../road/config/vehicle_config.dart';
import '../../road/road_renderer.dart';
import '../race_controller.dart';

/// Returns the sideways position where a rival parks beside the player.
double parkingLateral(int index, double playerX, double minLateral, double maxLateral) {
  final side = index.isEven ? 1.0 : -1.0;
  final offset = 0.42 + 0.4 * (index ~/ 2);
  final lane = playerX + side * offset;
  if (lane >= minLateral && lane <= maxLateral) return lane;
  return playerX - side * offset;
}

/// Returns the distance where a rival should stop after crossing the line.
double rivalStopDistance(RaceController race, RoadRenderer road, int index) {
  if (race.finished) {
    final braking = road.speed * road.speed / (2 * -VehicleConfig.braking);
    return road.fullDistance + braking - 180 * (1 + index ~/ 2);
  }
  return race.raceLength + (0.26 + 0.03 * index) * VehicleConfig.maxSpeed;
}

/// Returns the speed of a rival braking to stop within [remaining] units.
double rivalFinishSpeed(double dt, double speed, double remaining) {
  final decel = (speed * speed / (2 * math.max(remaining, 60)))
      .clamp(VehicleConfig.maxSpeed * 0.6, VehicleConfig.maxSpeed * 3.5)
      .toDouble();
  return math.max(0.0, speed - decel * dt);
}
