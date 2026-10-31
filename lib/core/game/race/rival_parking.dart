// Project imports:
import '../road/config/vehicle_config.dart';

/// Returns the sideways position where a rival parks beside the player.
double parkingLateral(int index, double playerX, double minLateral, double maxLateral) {
  final side = index.isEven ? 1.0 : -1.0;
  final offset = 0.42 + 0.4 * (index ~/ 2);
  final lane = playerX + side * offset;
  if (lane >= minLateral && lane <= maxLateral) return lane;
  return playerX - side * offset;
}

/// Returns the distance where a rival should stop after crossing the line.
double rivalStopDistance({
  required bool raceFinished,
  required double raceLength,
  required double playerDistance,
  required double playerSpeed,
  required int index,
}) {
  if (raceFinished) {
    final braking = playerSpeed * playerSpeed / (2 * -VehicleConfig.braking);
    return playerDistance + braking - 180 * (1 + index ~/ 2);
  }
  return raceLength + (0.26 + 0.03 * index) * VehicleConfig.maxSpeed;
}
