// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../common/objects/guardrail/guardrail_config.dart';
import '../../rider/crash_state.dart';
import '../../road/config/vehicle_config.dart';
import '../../road/road_renderer.dart';
import '../../road/traffic/traffic_flow.dart';
import '../race_controller.dart';
import 'rival_brain.dart';
import 'rival_ground.dart';
import 'rival_parking.dart';
import 'rival_sight.dart';
import 'rival_steering.dart';

/// Picks the line a rival aims for and steers it there within the road limits.
class RivalLane {
  RivalLane({
    required this.index,
    required this.rival,
    required this.steering,
    required this.brain,
    required this.ground,
    required this.crash,
  });

  static const double edge = 0.92;

  final int index;
  final RiderRival rival;
  final RivalSteering steering;
  final RivalBrain brain;
  final RivalGround ground;
  final CrashState crash;

  /// Steers the rival sideways, staying within the guardrail limit.
  void steer(
    double dt,
    RaceController race,
    RoadRenderer road, {
    required double distance,
    required double speed,
    required bool crossed,
    required TrafficFlow? flow,
  }) {
    final section = road.track.at(distance + road.playerZ).section;
    final limit = road.theme.dualCarriageway
        ? GuardrailConfig.riderLimit(section)
        : null;
    final maxLateral = math.min(edge, (limit ?? 9.0) - 0.12);
    final parked = crossed && race.finished;
    final lateral = steering.lateral;
    double? line = parked
        ? parkingLateral(index, road.playerX, -edge, maxLateral)
        : brain.preferredLine ?? ground.goodLine(road, distance);
    if (!parked && !crash.down) {
      line = flow?.freeLine(distance, lateral, line, limit: maxLateral) ?? line;
    }
    steering.update(
      dt: dt,
      clock: race.raceClock,
      speedRatio: (speed / VehicleConfig.maxSpeed).clamp(0.0, 1.0).toDouble(),
      along: distance - road.fullDistance,
      closing: road.speed - speed,
      playerLateral: road.playerX,
      line: line,
      parked: parked,
      attacking: brain.mood == RivalMood.attack,
      frozen: crash.down,
      aggression: rival.aggression,
      minLateral: -edge,
      maxLateral: maxLateral,
    );
  }
}
