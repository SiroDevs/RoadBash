// Dart imports:
import 'dart:async';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'tilt_source.dart';

const double _minInPlane = 2.5;

double? rollFromGravity(double x, double y) {
  if (math.sqrt(x * x + y * y) < _minInPlane) return null;
  const quarter = math.pi / 2;
  final angle = math.atan2(x, y);
  final upright = (angle / quarter).roundToDouble() * quarter;
  return upright - angle;
}

class TiltController {
  TiltController({required this.onSteer});

  static const double _fullLock = 26 * math.pi / 180;
  static const double _deadZone = 2.0 * math.pi / 180;

  /// Smoothing time constant in seconds. Time based rather than per-sample, so
  /// it feels the same whether the browser delivers 30, 60 or 100 readings a
  /// second (phone browsers vary a lot). The old per-sample 0.28 on top of the
  /// road's own steering ramp made tilt feel like it lagged by half a second.
  static const double _tau = 0.035;

  final ValueChanged<double> onSteer;

  final ValueNotifier<bool> needsPermission = ValueNotifier<bool>(false);

  bool invert = false;

  TiltSource? _source;
  StreamSubscription<TiltSample>? _sub;
  double _value = 0;
  bool _paused = false;
  final Stopwatch _clock = Stopwatch();
  int _lastMicros = 0;

  bool get running => _source != null;

  void start() {
    if (_source != null) return;
    final source = createTiltSource();
    _source = source;
    if (source.needsPermission) {
      needsPermission.value = true;
    } else {
      _listen(source);
    }
  }

  Future<void> requestPermission() async {
    final source = _source;
    if (source == null) return;
    final granted = await source.requestPermission();
    if (_source != source) return;
    if (granted) {
      needsPermission.value = false;
      _listen(source);
    }
  }

  void setPaused(bool paused) {
    _paused = paused;
    _value = 0;
    onSteer(0);
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
    _source?.dispose();
    _source = null;
    _value = 0;
    _lastMicros = 0;
    needsPermission.value = false;
    onSteer(0);
  }

  void dispose() {
    stop();
    needsPermission.dispose();
  }

  void _listen(TiltSource source) {
    _sub?.cancel();
    _sub = source.samples.listen(_onSample, onError: (Object _) {});
  }

  void _onSample(TiltSample s) {
    if (_paused) return;
    final roll = rollFromGravity(s.x, s.y);
    if (roll == null) return;
    final target = _shape(invert ? -roll : roll);
    if (!_clock.isRunning) _clock.start();
    final now = _clock.elapsedMicroseconds;
    // First reading, or one after a long gap: jump straight to it.
    final dt = _lastMicros == 0 ? 1.0 : (now - _lastMicros) / 1e6;
    _lastMicros = now == 0 ? 1 : now;
    final alpha = 1 - math.exp(-math.min(dt, 1.0) / _tau);
    _value += (target - _value) * alpha;
    onSteer(_value);
  }

  static double _shape(double roll) {
    final a = roll.abs();
    if (a <= _deadZone) return 0;
    final t = math.min(1.0, (a - _deadZone) / (_fullLock - _deadZone));
    return roll < 0 ? -t : t;
  }
}
