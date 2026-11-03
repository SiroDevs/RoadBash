// Dart imports:
import 'dart:math' as math;

/// Steers one rival across the road: lane keeping, dodging and shoves.
class RivalSteering {
  RivalSteering({
    required this.gridLateral,
    required this.lanes,
    required this.index,
    required this.phase,
  }) : lateral = gridLateral;

  static const double _gap = 0.4;
  static const double _release = 0.1;
  static const double _dodgeReach = 3200;
  static const double _lineReach = 450;
  static const double _maxVelocity = 0.85;
  static const double _fullAuthority = 0.25;
  static const double _parkedAuthority = 0.5;
  static const double _gain = 2.5;
  static const double _inertia = 7;
  static const double _shoveDecay = 4;
  static const double _launchBlend = 6;
  static const double _weaveStart = 6;

  final double gridLateral;
  final int lanes;
  final int index;
  final double phase;

  double lateral;
  double motion = 0;
  double shove = 0;

  double _velocity = 0;
  double _dodgeSide = 0;

  /// Moves the rival sideways for one frame.
  void update({
    required double dt,
    required double clock,
    required double speedRatio,
    required double along,
    required double closing,
    required double playerLateral,
    required double? line,
    required bool parked,
    required bool attacking,
    required bool frozen,
    required double aggression,
    required double minLateral,
    required double maxLateral,
  }) {
    if (parked && speedRatio <= 0) {
      _velocity = 0;
      shove = 0;
      motion = 0;
      return;
    }
    var steerVelocity = 0.0;
    if (!frozen) {
      var target = line ?? _laneTarget(clock);
      if (!parked && !attacking) {
        target = _dodge(target, along, closing, playerLateral, line != null, minLateral, maxLateral);
      } else {
        _dodgeSide = 0;
      }
      target = target.clamp(minLateral, maxLateral).toDouble();
      final authority = parked
          ? _parkedAuthority
          : (speedRatio / _fullAuthority).clamp(0.0, 1.0).toDouble();
      final drive = attacking ? 0.55 + 0.45 * aggression : 1.0;
      final wanted = ((target - lateral) * _gain)
          .clamp(-_maxVelocity, _maxVelocity)
          .toDouble();
      steerVelocity = wanted * authority * drive;
    }
    _velocity += (steerVelocity - _velocity) * math.min(1.0, dt * _inertia);
    shove *= math.exp(-_shoveDecay * dt);
    final previous = lateral;
    lateral = (lateral + (_velocity + shove) * dt)
        .clamp(minLateral, maxLateral)
        .toDouble();
    motion = (lateral - previous) / dt;
  }

  /// Returns the lane line for this rival, easing off the grid after the start.
  double _laneTarget(double clock) {
    final width = 2 / lanes;
    final lane = -1 + width * ((index % lanes) + 0.5);
    final weaveIn = ((clock - _weaveStart) / _weaveStart).clamp(0.0, 1.0).toDouble();
    final weave = width * 0.15 * math.sin(clock * 0.6 + phase) * weaveIn;
    final progress = (clock / _launchBlend).clamp(0.0, 1.0).toDouble();
    final blend = progress * progress * (3 - 2 * progress);
    return gridLateral + (lane + weave - gridLateral) * blend;
  }

  /// Keeps the rival clear of the player, committing to one side while close.
  double _dodge(
    double target,
    double along,
    double closing,
    double playerLateral,
    bool hasLine,
    double minLateral,
    double maxLateral,
  ) {
    final reach = hasLine ? _lineReach : _dodgeReach;
    final approaching = along >= 0 ? closing > 0 : closing < 0;
    if (!approaching || along.abs() > reach) {
      _dodgeSide = 0;
      return target;
    }
    final offset = lateral - playerLateral;
    if (_dodgeSide == 0) {
      if (offset.abs() >= _gap) return target;
      _dodgeSide = offset.abs() < 0.02 ? (index.isEven ? 1.0 : -1.0) : offset.sign;
    } else if (offset.abs() > _gap + _release) {
      _dodgeSide = 0;
      return target;
    }
    final wanted = (playerLateral + _dodgeSide * _gap)
        .clamp(minLateral, maxLateral)
        .toDouble();
    final nearness = (1 - along.abs() / reach).clamp(0.0, 1.0).toDouble();
    return target + (wanted - target) * math.sqrt(math.max(nearness, 0.25));
  }
}
