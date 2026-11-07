// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/foundation.dart' show VoidCallback;

// Project imports:
import '../police/police_chase.dart';
import '../police/police_cop.dart';
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import '../road/traffic/civilian_car.dart';
import '../road/traffic/traffic_flow.dart';
import 'race_controller.dart';
import 'rival/rival_racer.dart';

/// Finds riders touching civilian vehicles and applies bumps and falls.
///
/// Running into the back of a vehicle at speed throws the rider off; a slow
/// touch only holds the rider back.
class TrafficContacts {
  TrafficContacts({
    required this.onImpact,
    required this.onHit,
  });

  /// Called with the strength of a hit on the player and whether it was a fall.
  final void Function(double strength, bool knockedOff) onImpact;

  /// Called once for every hit the player makes on a vehicle, front or side.
  final VoidCallback onHit;

  static const double _startGrace = 3;
  static const double _frontReach = 230;
  static const double _nose = 60;
  static const double _riderHalf = 0.10;
  static const double _fallClosing = VehicleConfig.maxSpeed * 0.28;
  static const double _strengthSpan = VehicleConfig.maxSpeed * 0.6;
  static const double _rearCooldown = 0.7;
  static const double _sideCooldown = 0.4;
  static const double _copCooldown = 0.6;
  static const double _rivalShove = 4;

  List<double> _wait = const [];
  double _copWait = 0;

  /// Checks every vehicle against the player, the rivals and the cop.
  void update(
    double dt,
    RaceController race,
    RoadRenderer road,
    TrafficFlow flow,
    List<RivalRacer> racers,
    PoliceChase police,
  ) {
    if (_wait.length != flow.cars.length) {
      _wait = List.filled(flow.cars.length, 0.0);
    }
    for (var i = 0; i < _wait.length; i++) {
      _wait[i] -= dt;
    }
    _copWait -= dt;

    final playerLive =
        race.raceClock >= _startGrace && !race.finished && !road.crashed;
    for (final car in flow.cars) {
      if (!car.active) continue;
      if (playerLive) _hitPlayer(car, road);
      for (final racer in racers) {
        _hitRival(dt, car, racer);
      }
    }
    if (playerLive && police.cop.active) _touchCop(road, police.cop);
  }

  // The player runs into the back or the side of a vehicle.
  void _hitPlayer(CivilianCar car, RoadRenderer road) {
    final along = car.distance - road.fullDistance;
    if (along > _frontReach || along < -car.kind.length) return;
    final offset = road.playerX - car.lateral;
    if (offset.abs() > car.halfWidth + _riderHalf) return;
    final direction = offset >= 0 ? 1.0 : -1.0;
    final closing = road.speed - car.speed;

    if (along > _nose) {
      if (closing <= 0 || _wait[car.index] > 0) return;
      final strength = (closing / _strengthSpan).clamp(0.2, 1.0).toDouble();
      final knockedOff = closing > _fallClosing;
      road.bump(
        speedLoss: 0.25 + 0.4 * strength,
        sideShove: direction * (0.5 + strength),
      );
      road.speed = math.min(road.speed, math.max(0.0, car.speed * 0.9));
      if (knockedOff) road.fall(direction, 1.8 + 1.4 * strength);
      _wait[car.index] = _rearCooldown;
      onHit();
      onImpact(strength, knockedOff);
      return;
    }

    if (_wait[car.index] > 0) return;
    road.bump(speedLoss: 0.06, sideShove: direction * 1.1);
    _wait[car.index] = _sideCooldown;
    onHit();
    onImpact(0.35, false);
  }

  // A rival rides into a vehicle: a hard hit from behind throws it off.
  void _hitRival(double dt, CivilianCar car, RivalRacer racer) {
    if (racer.fallen || racer.crossed) return;
    final along = car.distance - racer.distance;
    if (along > _frontReach || along < -car.kind.length) return;
    final offset = racer.lateral - car.lateral;
    if (offset.abs() > car.halfWidth + _riderHalf) return;
    final direction = offset >= 0 ? 1.0 : -1.0;

    if (along > _nose) {
      final closing = racer.speed - car.speed;
      if (closing <= 0) return;
      if (closing > _fallClosing) {
        racer.bump(speedLoss: 0.6, sideShove: direction);
        racer.fall(direction, 2.2);
      } else {
        racer.limitSpeed(math.max(0.0, car.speed * 0.95));
      }
      return;
    }
    racer.bump(speedLoss: 0, sideShove: direction * _rivalShove * dt);
  }

  // The player brushes against the cop riding alongside.
  void _touchCop(RoadRenderer road, PoliceCop cop) {
    final along = cop.distance - road.fullDistance;
    final offset = road.playerX - cop.lateral;
    if (along.abs() > 260 || offset.abs() > 0.3 || _copWait > 0) return;
    final direction = offset >= 0 ? 1.0 : -1.0;
    road.bump(speedLoss: 0.03, sideShove: direction * 0.9);
    cop.shoveBy(-direction * 0.9);
    _copWait = _copCooldown;
    onImpact(0.3, false);
  }
}
