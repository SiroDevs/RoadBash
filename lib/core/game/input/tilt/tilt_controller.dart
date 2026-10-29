// Dart imports:
import 'dart:async';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'tilt_source.dart';

const double _minInPlane = 2.5;

/// Returns the device's roll angle from gravity, or null when flat.
double? rollFromGravity(double gravityX, double gravityY) {
  if (math.sqrt(gravityX * gravityX + gravityY * gravityY) < _minInPlane) return null;
  const quarter = math.pi / 2;
  final angle = math.atan2(gravityX, gravityY);
  final upright = (angle / quarter).roundToDouble() * quarter;
  return upright - angle;
}

/// Turns device tilt into steering and reports it to [onSteer].
class TiltController {
  TiltController({required this.onSteer});

  static const double _fullLock = 26 * math.pi / 180;
  static const double _deadZone = 2.0 * math.pi / 180;

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

  /// True while a tilt source is active.
  bool get running => _source != null;

  /// Starts listening to tilt sensor samples.
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

  /// Asks for sensor permission where the platform requires it.
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

  /// Pauses or resumes steering; pausing recentres the steering.
  void setPaused(bool paused) {
    _paused = paused;
    _value = 0;
    onSteer(0);
  }

  /// Stops listening to the tilt sensor.
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

  /// Stops tilt input and releases its resources.
  void dispose() {
    stop();
    needsPermission.dispose();
  }

  /// Subscribes to the samples of a tilt source.
  void _listen(TiltSource source) {
    _sub?.cancel();
    _sub = source.samples.listen(_onSample, onError: (Object _) {});
  }

  /// Converts a sensor sample into a steering value.
  void _onSample(TiltSample sample) {
    if (_paused) return;
    final roll = rollFromGravity(sample.x, sample.y);
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

  /// Applies the dead zone and full-lock limits to a roll angle.
  static double _shape(double roll) {
    final magnitude = roll.abs();
    if (magnitude <= _deadZone) return 0;
    final blend = math.min(1.0, (magnitude - _deadZone) / (_fullLock - _deadZone));
    return roll < 0 ? -blend : blend;
  }
}
