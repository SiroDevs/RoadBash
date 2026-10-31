// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../road/config/vehicle_config.dart';
import 'race_controller.dart';
import 'rival_sight.dart';

/// Works out how fast a rival wants to ride and how tired it gets.
class RivalPace {
  RivalPace(this.rival, math.Random random)
      : _surgeRate = 0.25 + 0.3 * random.nextDouble(),
        _surgePhase = random.nextDouble() * math.pi * 2,
        _surgeDepth = 0.02 + 0.03 * (1 - rival.focus);

  static const double _boostLimit = 0.14;
  static const double _slipstream = 0.035;
  static const double _conserve = 0.96;
  static const double _slipFactor = 0.72;
  static const double _yieldFactor = 0.92;
  static const double _sprintFrom = 0.92;
  static const double _drain = 0.07;
  static const double _recover = 0.05;
  static const double _catchHeadroom = 0.25;
  static const double _catchCeiling = 0.99;
  static const double _catchMargin = 0.03;
  static const double _catchGapBoost = 0.05;
  static const double _catchGapSpan = VehicleConfig.maxSpeed * 3;
  static const double _matchRange = 0.1;

  final RiderRival rival;
  final double _surgeRate;
  final double _surgePhase;
  final double _surgeDepth;

  double _energy = 1;
  bool _tired = false;

  /// Returns the target speed as a fraction of the top speed.
  double target(
    RivalSight sight,
    RivalMood mood,
    double clock,
    double urgency, {
    required bool yielding,
  }) {
    final surge = 1 + _surgeDepth * math.sin(_surgeRate * clock + _surgePhase);
    var fraction = rival.pace * surge;
    final sprinting = sight.raceFraction > _sprintFrom;
    if ((mood.pushing && !_tired) || sprinting) {
      fraction += rival.grit * _boostLimit * urgency;
    }
    if (mood == RivalMood.draft) fraction += _slipstream;
    if (mood == RivalMood.cruise) fraction *= _conserve;
    if (mood == RivalMood.slip) fraction *= _slipFactor;
    if (yielding) fraction *= _yieldFactor;
    if (mood == RivalMood.attack) {
      fraction = _matchPlayer(sight);
    } else if (mood != RivalMood.slip) {
      fraction = math.max(fraction, _catchUp(sight));
    }
    return fraction.clamp(0.25, 1.02).toDouble();
  }

  /// Pushing hard tires the rival; easing off lets it recover.
  void spend(double dt, bool pushing) {
    final change = pushing ? -_drain * (1.2 - rival.grit * 0.5) : _recover;
    _energy = (_energy + change * dt).clamp(0.0, 1.0).toDouble();
    if (_energy <= 0.05) _tired = true;
    if (_energy >= 0.5) _tired = false;
  }

  /// Highest speed the rival can reach when reeling a slower player in.
  double get _catchLimit => math.min(
        _catchCeiling,
        rival.pace + _catchHeadroom * (0.6 + 0.4 * rival.focus),
      );

  /// Returns the speed that closes a gap to a player who is ahead.
  double _catchUp(RivalSight sight) {
    if (sight.deficit <= 0) return 0;
    final gapShare = (sight.deficit / _catchGapSpan).clamp(0.0, 1.0).toDouble();
    final wanted = sight.playerFraction + _catchMargin + _catchGapBoost * gapShare;
    return math.min(_catchLimit, wanted);
  }

  /// Returns the speed that keeps the rival level with the player.
  double _matchPlayer(RivalSight sight) {
    final drift = (sight.deficit / VehicleConfig.maxSpeed)
        .clamp(-_matchRange, _matchRange)
        .toDouble();
    return math.min(_catchLimit, sight.playerFraction + drift);
  }
}
