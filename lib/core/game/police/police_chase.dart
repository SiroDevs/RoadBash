// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../race/race_controller.dart';
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import '../road/traffic/traffic_flow.dart';
import 'cop_pursuit.dart';
import 'police_cop.dart';

/// Whether a patrol is on the player's tail.
enum ChasePhase { idle, chasing }

/// Decides when a cop comes after the player, and when it makes the arrest.
///
/// Heat only builds when the player endangers other road users: it jumps when
/// the player bashes a rival, and speed or wrong-side riding add none.
/// Past halfway the race has shown how the player rides; if the heat is full a
/// cop starts from behind, out of sight, with the siren as the warning. A
/// patrol lasts about [_patrolSeconds]. A rider who keeps up speed is only
/// trailed until the cop gives up. A rider who slows down, stops or
/// crashes gets the cop alongside and then in front, blocking the way; every
/// second the cop stays close then fills the arrest meter, and a full meter is
/// a bust. A cop that ends up in the rider's path also fills it.
class PoliceChase {
  PoliceChase({
    required this.enabled,
    this.fineAmount = 0,
    math.Random? random,
  })
    : _random = random ?? math.Random(2026),
      cop = PoliceCop();

  /// False on roads without patrols.
  final bool enabled;

  /// The fine for an arrest, in shillings.
  final int fineAmount;

  /// The patrol rider; always part of the road's actor list.
  final PoliceCop cop;

  final math.Random _random;
  final CopPursuit _pursuit = const CopPursuit();

  static const double _firstDelay = 16;
  static const double _judgeShare = 0.75;
  static const double _bashHeat = 0.4;
  static const double _heatDecay = 1 / 70;
  static const double _launchGap = 3600;
  static const double _keepUpShare = 0.7;
  static const double _blockRange = 1500;
  static const double _blockWidth = 0.35;
  static const double _patrolSeconds = 25;
  static const double _rangeBehind = 300;
  static const double _rangeAhead = 500;
  static const double _bustSeconds = 4.0;
  static const double _releaseSeconds = 1.6;
  static const double _giveUpGap = 4000;
  static const double _giveUpSeconds = 10;
  static const double _finishClear = 9000;
  static const double _audibleRange = 7000;

  ChasePhase phase = ChasePhase.idle;

  /// Build-up toward a patrol being sent; 1 sends one.
  double heat = 0;

  /// Arrest meter, 0 to 1; a full meter is a bust.
  double bust = 0;

  /// True once the player has been arrested.
  bool busted = false;

  /// Cop position relative to the player; negative when behind.
  double along = 0;

  double _cooldown = _firstDelay;
  double _farTime = 0;
  double _patrolTime = 0;

  /// True while a cop is after the player.
  bool get chasing => phase == ChasePhase.chasing;

  /// How loud the siren should be, from 0 to 1.
  double get closeness => (chasing || busted)
      ? (1 - along.abs() / _audibleRange).clamp(0.12, 1.0).toDouble()
      : 0;

  /// The fine for the arrest, in shillings.
  int get fine => fineAmount;

  /// Records that the player bashed a rival.
  void bash() => crime(_bashHeat);

  /// Adds [amount] of heat for something that endangered other road users.
  void crime(double amount) {
    if (!enabled || busted) return;
    heat = math.min(1.5, heat + amount);
    _cooldown = math.min(_cooldown, 3.0);
  }

  /// Advances the patrol for one frame.
  void update(
    double dt,
    RaceController race,
    RoadRenderer road,
    TrafficFlow flow,
  ) {
    if (!enabled || dt <= 0) return;
    if (busted) {
      _pursue(dt, road, flow);
      return;
    }
    if (race.finished) {
      if (chasing) _stand();
      return;
    }
    if (!race.running) return;

    _cooldown = math.max(0.0, _cooldown - dt);
    final judged = road.fullDistance >= race.raceLength * _judgeShare;
    if (judged) heat = math.max(0.0, heat - dt * _heatDecay);
    if (!chasing) {
      final left = race.raceLength - road.fullDistance;
      final ready = judged && heat >= 1 && _cooldown <= 0;
      if (ready && left > _finishClear) _launch(road);
      return;
    }
    _pursue(dt, road, flow);
    _arrest(dt, road);
  }

  // Sends a cop from behind the player.
  void _launch(RoadRenderer road) {
    cop.launch(
      distance: road.fullDistance - _launchGap,
      lateral: road.playerX.clamp(-0.8, 0.8).toDouble(),
      speed: math.max(road.speed, VehicleConfig.maxSpeed * 0.6),
    );
    phase = ChasePhase.chasing;
    bust = 0;
    heat = 0;
    _farTime = 0;
    _patrolTime = 0;
    along = -_launchGap;
  }

  // True while the player holds a speed the cop cannot arrest.
  bool _keepsUp(RoadRenderer road) =>
      !road.crashed && !road.stopped && road.speedPercent >= _keepUpShare;

  // True when the cop is ahead of the player, in the way.
  bool _blocksPath(RoadRenderer road) =>
      along > 0 &&
      along < _blockRange &&
      (cop.lateral - road.playerX).abs() < _blockWidth;

  // Moves the cop to where it belongs for the way the player is riding.
  void _pursue(double dt, RoadRenderer road, TrafficFlow flow) {
    final stance = busted
        ? CopStance.escort
        : (_keepsUp(road) ? CopStance.trail : CopStance.block);
    along = _pursuit.ride(dt, cop, road, flow, stance);
  }

  // Fills the arrest meter while the cop is close to a rider who has slowed
  // down, stopped or crashed, or whose path the cop is blocking.
  void _arrest(double dt, RoadRenderer road) {
    final keepsUp = _keepsUp(road);
    _patrolTime += dt;
    if (_patrolTime >= _patrolSeconds && bust <= 0) {
      _release();
      return;
    }
    final near = along > -_rangeBehind && along < _rangeAhead;
    if (near && (!keepsUp || _blocksPath(road))) {
      final rush = (road.crashed || road.stopped) ? 1.6 : 1.0;
      bust += dt * rush / _bustSeconds;
    } else {
      bust -= dt / _releaseSeconds;
    }
    bust = bust.clamp(0.0, 1.0).toDouble();
    if (bust >= 1) {
      busted = true;
      return;
    }
    _farTime = along < -_giveUpGap ? _farTime + dt : 0;
    if (_farTime >= _giveUpSeconds) _release();
  }

  // The cop gives up and rides off; the next patrol is a while away.
  void _release() {
    _stand();
    _cooldown = 22 + 14 * _random.nextDouble();
  }

  void _stand() {
    cop.park();
    phase = ChasePhase.idle;
    heat = 0;
    bust = 0;
    _farTime = 0;
    _patrolTime = 0;
    along = 0;
  }
}
