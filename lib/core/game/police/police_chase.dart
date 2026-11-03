// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../race/race_controller.dart';
import '../road/guardrail/guardrail_config.dart';
import '../road/road_renderer.dart';
import '../road/traffic/traffic_flow.dart';
import '../road/universal/config/vehicle_config.dart';
import 'police_cop.dart';

/// Whether a patrol is on the player's tail.
enum ChasePhase { idle, chasing }

/// Decides when a cop comes after the player, and when it makes the arrest.
///
/// Heat builds while the player rides flat out and jumps when the player hits
/// traffic. Once it is full a cop starts from behind, out of sight, with the
/// siren as the warning. The cop rides up beside the player; every second it
/// stays there fills the arrest meter, and a full meter is a bust. A rider who
/// keeps the throttle pinned can pull clear and lose the cop.
class PoliceChase {
  PoliceChase({required this.enabled, math.Random? random})
    : _random = random ?? math.Random(2026),
      cop = PoliceCop();

  /// False on roads without patrols.
  final bool enabled;

  /// The patrol rider; always part of the road's actor list.
  final PoliceCop cop;

  final math.Random _random;

  static const double _firstDelay = 16;
  static const double _speedingShare = 0.8;
  static const double _speedingSeconds = 26;
  static const double _heatDecay = 1 / 70;
  static const double _launchGap = 3600;
  static const double _topShare = 0.975;
  static const double _closeGain = 2.8;
  static const double _rangeBehind = 650;
  static const double _rangeAhead = 950;
  static const double _bustSeconds = 4.0;
  static const double _releaseSeconds = 1.6;
  static const double _giveUpGap = 6800;
  static const double _giveUpSeconds = 4;
  static const double _sideOffset = 0.55;
  static const double _edge = 0.9;
  static const double _finishClear = 9000;
  static const double _audibleRange = 7000;

  ChasePhase phase = ChasePhase.idle;

  /// Build-up toward a patrol being sent; 1 sends one.
  double heat = 0;

  /// Arrest meter, 0 to 1; a full meter is a bust.
  double bust = 0;

  /// How many times the player has hit traffic; each one adds to the fine.
  int offences = 0;

  /// True once the player has been arrested.
  bool busted = false;

  /// Cop position relative to the player; negative when behind.
  double along = 0;

  double _cooldown = _firstDelay;
  double _farTime = 0;

  /// True while a cop is after the player.
  bool get chasing => phase == ChasePhase.chasing;

  /// How loud the siren should be, from 0 to 1.
  double get closeness => (chasing || busted)
      ? (1 - along.abs() / _audibleRange).clamp(0.12, 1.0).toDouble()
      : 0;

  /// The fine for the arrest, in shillings.
  int get fine => math.min(9500, 1000 + 500 * offences);

  /// Records that the player did something a cop would care about.
  void crime(double amount) {
    if (!enabled || busted) return;
    offences++;
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
    _warm(dt, road);
    if (!chasing) {
      final left = race.raceLength - road.fullDistance;
      if (heat >= 1 && _cooldown <= 0 && left > _finishClear) _launch(road);
      return;
    }
    _pursue(dt, road, flow);
    _arrest(dt, road);
  }

  // Heat rises while the player rides at full tilt and cools off otherwise.
  void _warm(double dt, RoadRenderer road) {
    if (road.speedPercent > _speedingShare && !road.crashed) {
      heat += dt / _speedingSeconds;
    } else {
      heat -= dt * _heatDecay;
    }
    heat = heat.clamp(0.0, 1.5).toDouble();
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
    along = -_launchGap;
  }

  // Rides the cop up beside the player and keeps it there.
  void _pursue(double dt, RoadRenderer road, TrafficFlow flow) {
    along = cop.distance - road.fullDistance;
    final top = VehicleConfig.maxSpeed * _topShare;
    var want = (road.speed - along * _closeGain)
        .clamp(0.0, top)
        .toDouble();

    final seg = road.track.at(cop.distance + road.playerZ);
    final limit = road.theme.dualCarriageway
        ? GuardrailConfig.riderLimit(seg.section)
        : null;
    final maxLateral = math.min(_edge, (limit ?? 9.0) - 0.12);

    var line = road.playerX;
    if (along > -2500) {
      final side = road.playerX > 0 ? -1.0 : 1.0;
      line = road.playerX + side * _sideOffset;
      if (line.abs() > maxLateral) line = road.playerX - side * _sideOffset;
    }
    line = flow.freeLine(cop.distance, cop.lateral, line, limit: maxLateral) ??
        line;
    final cap = flow.speedCap(cop.distance, cop.lateral);
    if (cap != null) want = math.min(want, cap);

    cop.advance(
      dt,
      targetSpeed: want,
      targetLateral: line,
      maxLateral: maxLateral,
      curve: seg.curve,
    );
    along = cop.distance - road.fullDistance;
  }

  // Fills the arrest meter while the cop is next to the player.
  void _arrest(double dt, RoadRenderer road) {
    final near = along > -_rangeBehind && along < _rangeAhead;
    if (near) {
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
    along = 0;
  }
}
