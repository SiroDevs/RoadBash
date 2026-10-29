// Dart imports:
import 'dart:math' as math;

// Project imports:
import 'engine_tune.dart';

/// Mixes engine layers into one voice driven by rpm.
class EngineVoice {
  EngineVoice(this.baseHz, this.tune)
    : volumes = List.filled(baseHz.length, 0.0),
      rates = List.filled(baseHz.length, 1.0),
      _weights = List.filled(baseHz.length, 0.0);

  static const double idleLoad = 0.0;

  static const double _minRate = 0.5;
  static const double _maxRate = 2.0;

  final List<double> baseHz;
  final EngineTune tune;
  final List<double> volumes;
  final List<double> rates;
  final List<double> _weights;

  double _rpm = 0.16;
  double _load = 0;
  double _shift = 0;
  double _shiftLen = 0.15;
  double _clock = 0;
  int _gear = 1;

  /// Updates layer volumes and pitch from rpm, gear and throttle.
  void update(
    double dt, {
    required double rpm,
    required int gear,
    required bool throttle,
    required bool brake,
    required bool locked,
    required bool stopped,
  }) {
    _clock += dt;

    if (gear != _gear && !locked) {
      _shiftLen = gear > _gear ? tune.shiftUp : tune.shiftDown;
      _shift = _shiftLen;
    }
    _gear = gear;
    _shift = math.max(0.0, _shift - dt);
    _rpm += (rpm - _rpm) * math.min(1.0, dt * 20);

    final limiter = throttle && !locked && _rpm > 0.97;
    final flutter = math.sin(_clock * 2 * math.pi * tune.limiterHz);
    var fire = tune.fireMin + tune.fireSpan * _rpm;
    if (limiter) fire *= 1 + tune.limiterDepth * flutter;

    final target = (stopped && !throttle)
        ? idleLoad
        : (brake ? 0.3 : (throttle ? 1.0 : tune.coastLoad));
    _load += (target - _load) * math.min(1.0, dt * 9);

    var duck = 1.0;
    if (_shift > 0) {
      final progress = 1 - _shift / _shiftLen;
      duck = tune.duckDepth + (1 - tune.duckDepth) * progress * progress;
    }
    var gain = _load * duck * (0.55 + 0.45 * _rpm) * tune.trim;
    if (limiter) {
      gain *= 0.9 + 0.1 * math.sin(_clock * 2 * math.pi * tune.limiterHz + 1.3);
    }

    _crossfade(fire);
    for (var i = 0; i < baseHz.length; i++) {
      volumes[i] = gain * _weights[i];
      rates[i] = (fire / baseHz[i]).clamp(_minRate, _maxRate).toDouble();
    }
  }

  /// Blends the layers around a firing rate.
  void _crossfade(double fire) {
    final count = baseHz.length;
    for (var i = 0; i < count; i++) {
      _weights[i] = 0;
    }
    if (fire <= baseHz.first) {
      _weights[0] = 1;
    } else if (fire >= baseHz.last) {
      _weights[count - 1] = 1;
    } else {
      var index = 0;
      while (fire >= baseHz[index + 1]) {
        index++;
      }
      final fraction =
          (math.log(fire) - math.log(baseHz[index])) /
          (math.log(baseHz[index + 1]) - math.log(baseHz[index]));
      _weights[index] = math.cos(fraction * math.pi / 2);
      _weights[index + 1] = math.sin(fraction * math.pi / 2);
    }
  }
}
