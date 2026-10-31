// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../rider/crash_state.dart';
import 'config/guardrail_config.dart';
import 'config/vehicle_config.dart';
import 'scene_theme.dart';
import 'track/road_track.dart';

// Rider speed, steering and engine state with its update rules.
mixin RoadDynamics {
  SceneTheme get theme;

  double speed = 0;
  double playerX = -0.25;
  double steer = 0;
  double appliedSteer = 0;
  double rpm = 0.16;
  double curveFelt = 0;
  bool analogSteer = false;
  bool throttle = false;
  bool brake = false;
  bool locked = true;
  bool skidding = false;
  bool railContact = false;
  int gear = 1;
  double shove = 0;
  bool _railLatched = false;

  final CrashState crash = CrashState();

  static const double _analogRate = 24;

  /// Speed as a share of the top speed.
  double get speedPercent => speed / VehicleConfig.maxSpeed;
  /// Speed in kilometres per hour.
  double get speedKmh => speedPercent * VehicleConfig.topSpeedKmh;
  /// True while the rider is thrown off the bike.
  bool get crashed => crash.down;
  /// True when the rider has left the road.
  bool get offRoad => playerX < -1 || playerX > 1;
  /// True when the bike is almost stopped.
  bool get stopped => speed < VehicleConfig.stoppedSpeed;
  /// True when stopped without throttle, so the rider has a foot down.
  bool get restingOnFoot => stopped && !throttle && !crashed;
  /// Engine load from the pedals: braking, idling or full throttle.
  double get engineLoad => brake ? 0.3 : (throttle ? 1.0 : 0.5);

  // Advances speed, lateral position and skid state by one frame.
  void stepDynamics(double dt, RoadSegment segment, double speedRatio) {
    crash.update(dt);
    final authority = 1 - VehicleConfig.steerHighSpeedDamp * speedRatio;
    playerX +=
        dt * VehicleConfig.steerRate * appliedSteer * speedRatio * authority;
    playerX -=
        dt * VehicleConfig.centrifugal * segment.curve * speedRatio * speedRatio;

    playerX += shove * dt;
    shove *= math.exp(-VehicleConfig.shoveDecay * dt);

    if (crashed) {
      speed += VehicleConfig.crashDrag * dt;
    } else if (brake) {
      speed += VehicleConfig.braking * dt;
    } else if (throttle) {
      speed += VehicleConfig.accel * dt;
    } else {
      speed += VehicleConfig.decel * dt;
    }
    if (offRoad && speed > VehicleConfig.offRoadLimit) {
      speed += VehicleConfig.offRoadDecel * dt;
    }
    const edge = VehicleConfig.maxOffRoad;
    playerX = math.max(-edge, math.min(edge, playerX));
    speed = math.max(0.0, math.min(VehicleConfig.maxSpeed, speed));
    hitGuardrail(segment, dt);

    final sharpTurn =
        appliedSteer.abs() > 0.4 &&
        speedRatio > 0.8 &&
        segment.curve.abs() > 2.5;
    final cornering = brake || sharpTurn;
    skidding =
        (speed > VehicleConfig.maxSpeed * 0.3 && cornering) ||
        (railContact && speed > VehicleConfig.maxSpeed * 0.15) ||
        (crashed && speed > VehicleConfig.maxSpeed * 0.1);
    updateEngine(dt, speedRatio);
  }

  /// Takes a hit from another bike: loses speed and is shoved sideways.
  void bump({required double speedLoss, required double sideShove}) {
    speed *= 1 - speedLoss;
    shove += sideShove;
  }

  /// Throws the rider off the bike toward [side] for [seconds].
  void fall(double side, double seconds) => crash.start(side, seconds);

  // Eases the applied steering toward the requested target.
  void steerToward(double dt, double target) {
    final clamped = target.clamp(-1.0, 1.0).toDouble();
    final rate = analogSteer
        ? _analogRate
        : (clamped.abs() > appliedSteer.abs()
              ? VehicleConfig.steerAttack
              : VehicleConfig.steerRelease);
    appliedSteer += (clamped - appliedSteer) * math.min(1.0, dt * rate);
  }

  /// Eases the engine speed toward a target.
  void settleRpm(double dt, double target) =>
      rpm += (target - rpm) * math.min(1.0, dt * 8);

  /// Updates the gear and engine speed from the road speed.
  void updateEngine(double dt, double speedRatio) {
    const gears = 6;
    gear = math.min(gears, 1 + (speedRatio * gears).floor());
    final inGear = math.min(
      1.0,
      math.max(0.0, speedRatio * gears - (gear - 1)),
    );
    settleRpm(dt * 1.25, stopped && !throttle ? 0.16 : 0.28 + 0.72 * inGear);
  }

  // The median guardrail is solid; pushing against it costs speed.
  void hitGuardrail(RoadSegment segment, double dt) {
    final limit = theme.dualCarriageway
        ? GuardrailConfig.riderLimit(segment.section)
        : null;
    if (limit == null || playerX <= limit) {
      railContact = false;
      if (limit == null || playerX < limit - 0.05) _railLatched = false;
      return;
    }
    playerX = limit;
    railContact = true;
    if (!_railLatched) {
      _railLatched = true;
      speed *= VehicleConfig.railImpactKeep;
    }
    speed = math.max(0.0, speed + VehicleConfig.railScrape * dt);
    if (appliedSteer > 0) appliedSteer = 0;
  }
}
