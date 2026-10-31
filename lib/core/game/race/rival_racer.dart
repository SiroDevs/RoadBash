// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../rider/rider_sprite.dart';
import '../road/config/guardrail_config.dart';
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import '../road/track/road_section.dart';
import '../road/traffic/road_actor.dart';
import 'race_controller.dart';
import 'rival_brain.dart';
import 'rival_parking.dart';
import 'rival_pose_driver.dart';
import 'rival_sight.dart';

/// Computer-controlled rival drawn as a bike on the road.
class RivalRacer implements RoadActor {
  RivalRacer(this.rival, this.index, this.lanes)
      : sprite = RiderSprite(look: rival.look),
        _brain = RivalBrain(rival, index * 7919 + rival.name.hashCode) {
    final slot = _grid[index % _grid.length];
    _gridLateral = slot.$1;
    _lead = slot.$2;
    _lateral = slot.$1;
  }

  static const List<(double, double)> _grid = [
    (-0.75, 520),
    (0.1, 520),
    (0.75, 520),
    (-0.45, 1040),
    (0.45, 1040),
  ];
  static const double _edge = 0.92;
  static const double _gap = 0.4;
  static const double _reach = 3200;
  static const double _collisionReach = 450;

  final RiderRival rival;
  final int index;
  final int lanes;
  final RiderSprite sprite;
  final RivalBrain _brain;
  late final RivalPoseDriver _poseDriver = RivalPoseDriver(sprite.pose, index);
  final RivalSight _sight = RivalSight();

  List<RivalRacer> peers = const [];

  double _dist = 0, _speed = 0, _visLead = 0, _lead = 0;
  double _lateral = 0, _gridLateral = 0, _latVel = 0;
  bool _crossed = false;
  double _swing = 0;

  @override
  double get distance => _dist + _visLead;

  @override
  double get lateral => _lateral;

  /// True once the rival has finished and come to rest.
  bool get settled => _crossed && _speed == 0;

  /// Current speed of the rival.
  double get speed => _speed;

  /// True while the rival's brake light is on.
  bool get braking => sprite.pose.braking;

  /// Advances the rival for one frame.
  void update(double dt, RaceController race, RoadRenderer road) {
    if (dt <= 0) return;
    final clock = race.raceClock;
    _advance(dt, race, road);
    race.rivalTracker.report(rival.name, _dist, _speed);
    final remaining = (1 - clock / 4).clamp(0.0, 1.0).toDouble();
    _visLead = _lead * remaining * remaining;

    final seg = road.track.at(distance + road.playerZ);
    _steerLateral(dt, race, road, seg.section, clock);
    _poseDriver.update(
      dt: dt,
      speed: _speed,
      steerRate: _latVel,
      curve: seg.curve,
      atStart: clock == 0,
      crossed: _crossed,
    );
  }

  /// Moves the rival along the track by the distance it should have covered.
  void _advance(double dt, RaceController race, RoadRenderer road) {
    if (!_crossed) {
      _ride(dt, race, road);
      return;
    }
    if (_speed <= VehicleConfig.stoppedSpeed) {
      _speed = 0;
      return;
    }
    final remaining = _stopAt(race, road) - _dist;
    final decel = (_speed * _speed / (2 * math.max(remaining, 60))).clamp(
      VehicleConfig.maxSpeed * 0.6,
      VehicleConfig.maxSpeed * 3.5,
    ).toDouble();
    _speed = math.max(0.0, _speed - decel * dt);
    _dist += _speed * dt;
  }

  /// Lets the rival's brain choose a speed and rides at it.
  void _ride(double dt, RaceController race, RoadRenderer road) {
    if (race.raceClock <= 0) return;
    _brain.think(dt, _look(race, road));
    final target = _brain.speedFraction * VehicleConfig.maxSpeed;
    if (target > _speed) {
      final push = VehicleConfig.accel * _brain.launchPower * dt;
      _speed = math.min(target, _speed + push);
    } else {
      _speed = math.max(target, _speed + VehicleConfig.decel * dt);
    }
    _dist += _speed * dt;
    if (_dist < race.raceLength) return;
    _crossed = true;
    final overshoot = (_dist - race.raceLength) / math.max(_speed, 1);
    race.rivalTracker.markFinished(rival.name, race.raceClock - overshoot);
  }

  /// Fills what the rival can see: the player and the nearest rival ahead.
  RivalSight _look(RaceController race, RoadRenderer road) {
    final reference = math.max(_speed, VehicleConfig.maxSpeed * 0.3);
    _sight
      ..ownDistance = _dist
      ..ownSpeed = _speed
      ..ownLateral = _lateral
      ..playerDistance = road.fullDistance
      ..playerLateral = road.playerX
      ..raceLength = race.raceLength
      ..peerGapSeconds = null;
    for (final other in peers) {
      final gap = other._dist - _dist;
      final seconds = gap / reference;
      final nearest = _sight.peerGapSeconds;
      if (identical(other, this) || gap <= 0) continue;
      if ((other._lateral - _lateral).abs() > 0.45) continue;
      if (nearest != null && seconds >= nearest) continue;
      _sight
        ..peerGapSeconds = seconds
        ..peerLateral = other._lateral;
    }
    return _sight;
  }

  /// Returns the distance where the rival should stop after the finish.
  double _stopAt(RaceController race, RoadRenderer road) {
    if (race.finished) {
      final vision = road.speed;
      final player = road.fullDistance + vision * vision / (2 * -VehicleConfig.braking);
      return player - 180 * (1 + index ~/ 2);
    }
    return race.raceLength + (0.26 + 0.03 * index) * VehicleConfig.maxSpeed;
  }

  /// Steers the rival sideways, staying within the guardrail limit.
  void _steerLateral(
    double dt,
    RaceController race,
    RoadRenderer road,
    Section section,
    double clock,
  ) {
    final limit = road.theme.dualCarriageway
        ? GuardrailConfig.riderLimit(section)
        : null;
    final maxL = math.min(_edge, (limit ?? 9.0) - 0.12);

    double target;
    if (_crossed && race.finished) {
      target = parkingLateral(index, road.playerX, -_edge, maxL);
    } else {
      final width = 2 / lanes;
      final lane = -1 + width * ((index % lanes) + 0.5);
      final weave = width * 0.22 * math.sin(clock * 0.6 + rival.phase);
      final progress = (clock / 6).clamp(0.0, 1.0).toDouble();
      final blend = progress * progress * (3 - 2 * progress);
      target = _gridLateral + (lane + weave - _gridLateral) * blend;

      final line = _brain.preferredLine;
      if (line != null) target = line;

      final dz = distance - road.fullDistance;
      final reach = line != null ? _collisionReach : _reach;
      final close = (1 - dz.abs() / reach).clamp(0.0, 1.0).toDouble();
      final side = target - road.playerX;
      if (close > 0 && side.abs() < _gap) {
        final dir = side.abs() < 0.02 ? (index.isEven ? 1.0 : -1.0) : side.sign;
        target += dir * (_gap - side.abs()) * math.sqrt(close);
        _swing = 1;
      }
    }
    target = target.clamp(-_edge, maxL).toDouble();

    final prev = _lateral;
    final rate = _swing > 0 ? 5.0 : 2.5;
    _swing = 0;
    _lateral += (target - _lateral) * math.min(1.0, dt * rate);
    _latVel = (_lateral - prev) / dt;
  }

  @override
  void paint(Canvas canvas, Offset ground, double height) {
    sprite.paintAt(canvas, ground, height / RiderSprite.height);
  }
}
