// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import 'race_controller.dart';
import 'rival_racer.dart';

/// Finds bikes touching the player and applies bumps, shoves and falls.
class RiderContacts {
  RiderContacts({required this.onImpact});

  final void Function(double strength, bool knockedOff) onImpact;

  static const double _alongReach = 380;
  static const double _bodyLength = 150;
  static const double _sideReach = 0.34;
  static const double _tailReach = 0.2;
  static const double _closingFull = 0.8;
  static const double _minClosing = 0.12;
  static const double _minStrength = 0.12;
  static const double _speedFalloff = 4;
  static const double _tailSpan = VehicleConfig.maxSpeed * 0.4;
  static const double _tailGrip = 0.6;
  static const double _tailShove = 0.9;
  static const double _startGrace = 3;
  static const double _cooldown = 0.5;
  static const double _edgeStart = 0.8;
  static const double _edgeSqueeze = 1.25;
  static const double _playerKnockOffLimit = 0.8;
  static const double _victimSlowdown = 0.3;
  static const double _attackerSlowdown = 0.08;
  static const double _victimShove = 1.6;
  static const double _attackerShove = 0.5;

  double _previousPlayerX = double.nan;
  final Map<RivalRacer, double> _cooldowns = {};

  /// Checks every rival against the player for one frame.
  void update(
    double dt,
    RaceController race,
    RoadRenderer road,
    List<RivalRacer> racers,
  ) {
    final moved = _previousPlayerX.isNaN || dt <= 0
        ? 0.0
        : (road.playerX - _previousPlayerX) / dt;
    _previousPlayerX = road.playerX;
    if (race.raceClock < _startGrace || race.finished || road.crashed) return;
    for (final racer in racers) {
      final wait = (_cooldowns[racer] ?? 0) - dt;
      _cooldowns[racer] = wait;
      if (racer.fallen || racer.crossed) continue;
      _touch(racer, road, moved, wait <= 0);
    }
  }

  /// Handles one rival that may be touching the player.
  void _touch(RivalRacer racer, RoadRenderer road, double moved, bool ready) {
    final along = racer.distance - road.fullDistance;
    final offset = racer.lateral - road.playerX;
    if (along.abs() > _alongReach || offset.abs() > _sideReach) return;
    final direction = offset >= 0 ? 1.0 : -1.0;
    if (offset.abs() < _tailReach && along.abs() > _bodyLength) {
      _rearEnd(racer, road, along, direction, ready);
      return;
    }
    if (!ready) return;
    final playerApproach = moved * direction;
    final rivalApproach = -racer.lateralMotion * direction;
    final closing = playerApproach + rivalApproach;
    if (closing < _minClosing) return;

    final relative = (racer.speed - road.speed).abs();
    final matched = 1 / (1 + _speedFalloff * relative / VehicleConfig.maxSpeed);
    final overlap = 1 - along.abs() / _alongReach;
    final playerAttacks = playerApproach >= rivalApproach;
    final victimSide = playerAttacks ? direction : -direction;
    final victimLateral = playerAttacks ? racer.lateral : road.playerX;
    var strength = (closing / _closingFull).clamp(0.0, 1.0) * matched * (0.6 + 0.4 * overlap);
    if (victimSide * victimLateral > _edgeStart) strength *= _edgeSqueeze;
    strength = strength.clamp(0.0, 1.0).toDouble();
    if (strength < _minStrength) return;

    final limit = playerAttacks ? racer.knockOffLimit : _playerKnockOffLimit;
    final knockedOff = strength >= limit;
    final downTime = 1.6 + 1.2 * strength;
    final loss = _victimSlowdown * strength;
    final recoil = _attackerSlowdown * strength;
    if (playerAttacks) {
      racer.bump(speedLoss: loss, sideShove: victimSide * strength * _victimShove);
      road.bump(speedLoss: recoil, sideShove: -victimSide * strength * _attackerShove);
      if (knockedOff) racer.fall(victimSide, downTime);
    } else {
      road.bump(speedLoss: loss, sideShove: victimSide * strength * _victimShove);
      racer.bump(speedLoss: recoil, sideShove: -victimSide * strength * _attackerShove);
      if (knockedOff) road.fall(victimSide, downTime);
    }
    racer.collided(attacker: !playerAttacks);
    _cooldowns[racer] = _cooldown;
    onImpact(strength, knockedOff);
  }

  /// Stops the faster bike running through the tail of the one ahead.
  void _rearEnd(
    RivalRacer racer,
    RoadRenderer road,
    double along,
    double direction,
    bool ready,
  ) {
    final playerFollows = along > 0;
    final followerSpeed = playerFollows ? road.speed : racer.speed;
    final leaderSpeed = playerFollows ? racer.speed : road.speed;
    final closing = followerSpeed - leaderSpeed;
    if (closing <= 0) return;
    final strength = (closing / _tailSpan).clamp(0.0, 1.0).toDouble();
    final held = leaderSpeed + closing * (1 - _tailGrip);
    final shove = (playerFollows ? -direction : direction) * strength * _tailShove;
    if (playerFollows) {
      road.speed = math.min(road.speed, held);
      road.shove += shove;
    } else {
      racer.limitSpeed(held);
      racer.bump(speedLoss: 0, sideShove: shove);
    }
    if (!ready || strength < _minStrength) return;
    _cooldowns[racer] = _cooldown;
    onImpact(strength * 0.6, false);
  }
}
