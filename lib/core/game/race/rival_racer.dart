// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../rider/rider_painter.dart';
import '../rider/rider_sprite.dart';
import '../road/config/guardrail_config.dart';
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import '../road/track/road_section.dart';
import '../road/traffic/road_actor.dart';
import 'race_controller.dart';
import 'shown_offset.dart';

/// Computer-controlled rival drawn as a bike on the road.
class RivalRacer implements RoadActor {
  RivalRacer(this.rival, this.index, this.lanes)
      : sprite = RiderSprite(look: rival.look) {
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

  final RiderRival rival;
  final int index;
  final int lanes;
  final RiderSprite sprite;

  final ShownOffset _shown = ShownOffset();
  double _dist = 0, _speed = 0, _visLead = 0, _lead = 0;
  double _drawnDistance = 0;
  double _lateral = 0, _gridLateral = 0, _latVel = 0, _t = 0;
  bool _crossed = false;
  double _swing = 0;

  @override
  double get distance => _drawnDistance;

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
    final remaining = (1 - clock / 4).clamp(0.0, 1.0).toDouble();
    _visLead = _lead * remaining * remaining;
    final offset = _shown.follow(dt, _dist + _visLead - road.fullDistance);
    _drawnDistance = road.fullDistance + offset;

    final seg = road.track.at(distance + road.playerZ);
    _steerLateral(dt, race, road, seg.section, clock);
    _pose(dt, seg.curve, clock);
  }

  /// Moves the rival along the track by the distance it should have covered.
  void _advance(double dt, RaceController race, RoadRenderer road) {
    if (!_crossed) {
      final distance = race.rivalDistance(rival, race.raceClock);
      _speed = (distance - _dist) / dt;
      _dist = distance;
      _crossed = distance >= race.raceLength;
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
      target = _parkAt(road.playerX, maxL);
    } else {
      final width = 2 / lanes;
      final lane = -1 + width * ((index % lanes) + 0.5);
      final weave = width * 0.22 * math.sin(clock * 0.6 + rival.phase);
      final progress = (clock / 6).clamp(0.0, 1.0).toDouble();
      final blend = progress * progress * (3 - 2 * progress);
      target = _gridLateral + (lane + weave - _gridLateral) * blend;

      final dz = distance - road.fullDistance;
      final close = (1 - dz.abs() / _reach).clamp(0.0, 1.0).toDouble();
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

  /// Returns the sideways position where the rival parks near the player.
  double _parkAt(double playerX, double maxL) {
    final side = index.isEven ? 1.0 : -1.0;
    final off = 0.42 + 0.4 * (index ~/ 2);
    final laneX = playerX + side * off;
    if (laneX >= -_edge && laneX <= maxL) return laneX;
    return playerX - side * off;
  }

  /// Updates the rider pose from speed, curve and clock.
  void _pose(double dt, double curve, double clock) {
    final pose = sprite.pose;
    final sp = (_speed / VehicleConfig.maxSpeed).clamp(0.0, 1.0).toDouble();
    final stopped = _speed < VehicleConfig.stoppedSpeed;
    final resting = stopped && (clock == 0 || _crossed);
    final braking = _crossed && !stopped;
    final ease = math.min(1.0, dt * 8);
    _t += dt;

    pose.speed = sp;
    pose.braking = braking;
    pose.steer += ((_latVel / 0.7).clamp(-1.0, 1.0).toDouble() - pose.steer) * ease;
    pose.foot += ((resting ? 1.0 : 0.0) - pose.foot) * math.min(1.0, dt * 5);
    final bank = (pose.steer * 0.30 + curve * 0.040) * (0.3 + 0.7 * sp) -
        0.12 * pose.foot;
    final lean = bank.clamp(-RiderPainter.maxLean, RiderPainter.maxLean).toDouble();
    pose.lean += (lean - pose.lean) * math.min(1.0, dt * 6);
    final pitch = braking ? -1.0 : 0.5;
    pose.pitch += (pitch * sp - pose.pitch) * math.min(1.0, dt * 6);
    pose.bob = math.sin(_t * 13 + index) * 1.1 * sp +
        math.max(0.0, -pose.pitch) * 2.5;
    pose.phase = (pose.phase + _speed * dt / 900) % 1;
  }

  @override
  void paint(Canvas canvas, Offset ground, double height) {
    sprite.paintAt(canvas, ground, height / RiderSprite.height);
  }
}
