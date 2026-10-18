// Dart imports:
import 'dart:math' as math;

/// Turns the bike's state into a volume and playback rate for each engine
/// layer. Pure maths with no audio calls, so it is easy to unit test.
class EngineVoice {
  EngineVoice(this.baseHz)
    : volumes = List.filled(baseHz.length, 0.0),
      rates = List.filled(baseHz.length, 1.0),
      _weights = List.filled(baseHz.length, 0.0);

  /// Firing frequency in Hz at rpm 0, and how much rpm 1 adds to it.
  static const double fireMin = 26;
  static const double fireSpan = 190;

  /// Loudness when stopped with no throttle. 0 = silent until you hit gas.
  static const double idleLoad = 0.0;

  static const double _shiftUpSecs = 0.15;
  static const double _shiftDownSecs = 0.1;
  static const double _limiterHz = 17;
  static const double _minRate = 0.5;
  static const double _maxRate = 2.0;

  final List<double> baseHz;
  final List<double> volumes;
  final List<double> rates;
  final List<double> _weights;

  double _rpm = 0.16;
  double _load = 0;
  double _shift = 0;
  double _shiftLen = _shiftUpSecs;
  double _clock = 0;
  int _gear = 1;

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

    // A shift is a short throttle lift: the sound ducks, then swells back.
    // The pitch drop (up) or rev-match jump (down) comes from the rpm model.
    if (gear != _gear && !locked) {
      _shiftLen = gear > _gear ? _shiftUpSecs : _shiftDownSecs;
      _shift = _shiftLen;
    }
    _gear = gear;
    _shift = math.max(0.0, _shift - dt);
    _rpm += (rpm - _rpm) * math.min(1.0, dt * 20);

    // Flat out in top gear the engine bounces off its rev limiter.
    final limiter = throttle && !locked && _rpm > 0.97;
    var fire = fireMin + fireSpan * _rpm;
    if (limiter) {
      fire *= 1 + 0.018 * math.sin(_clock * 2 * math.pi * _limiterHz);
    }

    final target = (stopped && !throttle)
        ? idleLoad
        : (brake ? 0.3 : (throttle ? 1.0 : 0.5));
    _load += (target - _load) * math.min(1.0, dt * 9);

    var duck = 1.0;
    if (_shift > 0) {
      final p = 1 - _shift / _shiftLen;
      duck = 0.35 + 0.65 * p * p;
    }
    var gain = _load * duck * (0.55 + 0.45 * _rpm);
    if (limiter) {
      gain *= 0.9 + 0.1 * math.sin(_clock * 2 * math.pi * _limiterHz + 1.3);
    }

    _crossfade(fire);
    for (var i = 0; i < baseHz.length; i++) {
      volumes[i] = gain * _weights[i];
      rates[i] = (fire / baseHz[i]).clamp(_minRate, _maxRate).toDouble();
    }
  }

  /// Equal-power crossfade between the two loops either side of [fire].
  void _crossfade(double fire) {
    final n = baseHz.length;
    for (var i = 0; i < n; i++) {
      _weights[i] = 0;
    }
    if (fire <= baseHz.first) {
      _weights[0] = 1;
    } else if (fire >= baseHz.last) {
      _weights[n - 1] = 1;
    } else {
      var i = 0;
      while (fire >= baseHz[i + 1]) {
        i++;
      }
      final f =
          (math.log(fire) - math.log(baseHz[i])) /
          (math.log(baseHz[i + 1]) - math.log(baseHz[i]));
      _weights[i] = math.cos(f * math.pi / 2);
      _weights[i + 1] = math.sin(f * math.pi / 2);
    }
  }
}
