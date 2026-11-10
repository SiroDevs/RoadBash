// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../common/objects/guardrail/guardrail_config.dart';
import '../../rider/crash_state.dart';
import '../../rider/rider_sprite.dart';
import '../../road/config/vehicle_config.dart';
import '../../road/road_renderer.dart';
import '../../road/track/road_section.dart';
import '../../road/traffic/road_actor.dart';
import '../../road/traffic/traffic_flow.dart';
import '../race_controller.dart';
import 'rival_brain.dart';
import 'rival_facing.dart';
import 'rival_ground.dart';
import 'rival_lookout.dart';
import 'rival_parking.dart';
import 'rival_pose_driver.dart';
import 'rival_sight.dart';
import 'rival_steering.dart';
import 'start_grid.dart';

/// Computer-controlled rival drawn as a bike on the road.
class RivalRacer implements RoadActor {
  RivalRacer(
    this.rival,
    this.index,
    this.lanes, {
    required int fieldSize,
    this.speedLimit = 1.0,
  }) : sprite = RiderSprite(look: rival.look),
       _brain = RivalBrain(rival, index * 7919 + rival.name.hashCode),
       _steering = RivalSteering(
         gridLateral: StartGrid.lateralFor(index, fieldSize),
         lanes: lanes,
         index: index,
         phase: rival.phase,
       );

  static const double _edge = 0.92;
  static const double _slideDecel = VehicleConfig.maxSpeed * 1.6;

  final RiderRival rival;
  final int index;
  final int lanes;

  /// The fastest the rival may go, as a share of the bike's top speed.
  final double speedLimit;
  final RiderSprite sprite;
  final RivalBrain _brain;
  final RivalSteering _steering;
  final CrashState _crash = CrashState();
  late final RivalPoseDriver _poseDriver = RivalPoseDriver(sprite.pose, index);
  final RivalLookout _lookout = RivalLookout();
  final RivalGround _ground = RivalGround();

  List<RivalRacer> peers = const [];

  /// Civilian traffic the rival steers around and slows for.
  TrafficFlow? flow;

  double _dist = 0, _speed = 0;
  bool _crossed = false;

  @override
  double get distance => _dist;

  /// Distance the rival has ridden.
  double get ridden => _dist;

  @override
  double get lateral => _steering.lateral;

  /// Sideways speed in road widths per second.
  double get lateralMotion => _steering.motion;

  /// True once the rival has finished and come to rest.
  bool get settled => _crossed && _speed == 0;

  /// True once the rival has crossed the finish line.
  bool get crossed => _crossed;

  /// True while the rival lies on the road after being knocked off.
  bool get fallen => _crash.down;

  /// How hard a hit must be to knock the rival off.
  double get knockOffLimit => 0.6 + 0.3 * rival.grit;

  /// Current speed of the rival.
  double get speed => _speed;

  /// True while the rival's brake light is on.
  bool get braking => sprite.pose.braking;

  /// Advances the rival for one frame.
  void update(double dt, RaceController race, RoadRenderer road) {
    if (dt <= 0) return;
    final clock = race.raceClock;
    _crash.update(dt);
    _advance(dt, race, road);
    race.rivalTracker.report(rival.name, _dist, _speed);

    final seg = road.track.at(distance + road.playerZ);
    _steerLateral(dt, race, road, seg.section, clock);
    _updateFacing(dt, road.playerX, road.fullDistance, clock);
    _poseDriver.update(
      dt: dt,
      speed: _speed,
      steerRate: _steering.motion,
      curve: seg.curve,
      crossed: _crossed,
    );
    sprite.pose.tumble = _crash.tilt;
    _ground.updateDust(dt, _speed, down: _crash.down);
  }

  /// Eases the rival toward the yaw its place relative to the player calls for.
  void _updateFacing(double dt, double playerLateral, double playerDistance, double raceClock) {
    final target = RivalFacing.yaw(
      sideOffset: lateral - playerLateral,
      gap: distance - playerDistance,
      index: index,
      atStart: raceClock < 3.5,
    );
    sprite.pose.perspective +=
        (target - sprite.pose.perspective) * math.min(1.0, dt * 3.5);
  }

  /// Slows the rival and shoves it sideways after a hit.
  void bump({required double speedLoss, required double sideShove}) {
    _speed *= 1 - speedLoss;
    _steering.shove += sideShove;
  }

  /// Knocks the rival off its bike toward [side] for [seconds].
  void fall(double side, double seconds) => _crash.start(side, seconds);

  /// Holds the rival's speed at or below [ceiling], as when it hits a tail.
  void limitSpeed(double ceiling) => _speed = math.min(_speed, ceiling);

  /// Tells the rival's brain it was in a collision.
  void collided({required bool attacker}) =>
      _brain.collided(attacker: attacker);

  /// Moves the rival along the track by the distance it should have covered.
  void _advance(double dt, RaceController race, RoadRenderer road) {
    if (_crash.down && !_crossed) {
      _speed = math.max(0.0, _speed - _slideDecel * dt);
      _dist += _speed * dt;
      return;
    }
    if (!_crossed) {
      _ride(dt, race, road);
      return;
    }
    if (_speed <= VehicleConfig.stoppedSpeed) {
      _speed = 0;
      return;
    }
    _speed = rivalFinishSpeed(
      dt,
      _speed,
      rivalStopDistance(race, road, index) - _dist,
    );
    _dist += _speed * dt;
  }

  /// Lets the rival's brain choose a speed and rides at it.
  void _ride(double dt, RaceController race, RoadRenderer road) {
    if (race.raceClock <= 0) return;
    _brain.think(dt, _lookout.look(this, race, road));
    var target = math.min(
      _brain.speedFraction * VehicleConfig.maxSpeed,
      VehicleConfig.maxSpeed * speedLimit,
    );
    final cap = flow?.speedCap(distance, lateral);
    if (cap != null) target = math.min(target, cap);
    if (target > _speed) {
      final push = VehicleConfig.accel * _brain.launchPower * dt;
      _speed = math.min(target, _speed + push);
    } else {
      _speed = math.max(target, _speed + VehicleConfig.decel * dt);
    }
    _dist += _speed * dt;
    _speed = _ground.ride(dt, road, _dist, lateral, _speed, rival.focus);
    if (_ground.fell) _crash.start(index.isEven ? 1.0 : -1.0, 2.0);
    if (_dist < race.raceLength) return;
    _crossed = true;
    final overshoot = (_dist - race.raceLength) / math.max(_speed, 1);
    race.rivalTracker.markFinished(rival.name, race.raceClock - overshoot);
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
    final maxLateral = math.min(_edge, (limit ?? 9.0) - 0.12);
    final parked = _crossed && race.finished;
    double? line = parked
        ? parkingLateral(index, road.playerX, -_edge, maxLateral)
        : _brain.preferredLine ?? _ground.goodLine(road, distance);
    if (!parked && !_crash.down) {
      line = flow?.freeLine(distance, lateral, line, limit: maxLateral) ?? line;
    }
    _steering.update(
      dt: dt,
      clock: clock,
      speedRatio: (_speed / VehicleConfig.maxSpeed).clamp(0.0, 1.0).toDouble(),
      along: distance - road.fullDistance,
      closing: road.speed - _speed,
      playerLateral: road.playerX,
      line: line,
      parked: parked,
      attacking: _brain.mood == RivalMood.attack,
      frozen: _crash.down,
      aggression: rival.aggression,
      minLateral: -_edge,
      maxLateral: maxLateral,
    );
  }

  @override
  void paint(Canvas canvas, Offset ground, double height) {
    sprite.paintAt(canvas, ground, height / RiderSprite.height);
    _ground.dust.paint(canvas, ground, height, _ground.terrain.dustTone);
  }
}
