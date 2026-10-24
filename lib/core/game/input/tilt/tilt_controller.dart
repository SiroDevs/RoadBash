// Dart imports:
import 'dart:async';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'tilt_source.dart';

/// Gravity must have at least this much pull across the screen to be trusted;
/// below it the device is lying flat and has no meaningful "tilt".
const double _minInPlane = 2.5;

/// How far the device is turned like a steering wheel, in radians, clockwise
/// positive. The "straight" pose is whichever upright orientation (portrait or
/// either landscape) the device is closest to, so it works the same in every
/// screen orientation without having to ask the OS which one is active.
///
/// Returns null while the device is lying flat.
double? rollFromGravity(double x, double y) {
  if (math.sqrt(x * x + y * y) < _minInPlane) return null;
  const quarter = math.pi / 2;
  final angle = math.atan2(x, y); // 0 when upright in portrait
  final upright = (angle / quarter).roundToDouble() * quarter;
  return upright - angle;
}

/// Turns accelerometer readings into a steering value in -1..1 and feeds it to
/// [onSteer]. Turning the device clockwise steers right.
class TiltController {
  TiltController({required this.onSteer});

  static const double _fullLock = 26 * math.pi / 180;
  static const double _deadZone = 2.5 * math.pi / 180;
  static const double _smoothing = 0.28;

  final ValueChanged<double> onSteer;

  /// True while the browser still needs a tap before it will share motion data
  /// (iOS Safari). The race screen shows a button for it.
  final ValueNotifier<bool> needsPermission = ValueNotifier<bool>(false);

  /// Flips left and right.
  bool invert = false;

  TiltSource? _source;
  StreamSubscription<TiltSample>? _sub;
  double _value = 0;
  bool _paused = false;

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

  /// Call this directly from a button's onPressed.
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
    _value += (target - _value) * _smoothing;
    onSteer(_value);
  }

  static double _shape(double roll) {
    final a = roll.abs();
    if (a <= _deadZone) return 0;
    final t = math.min(1.0, (a - _deadZone) / (_fullLock - _deadZone));
    return roll < 0 ? -t : t;
  }
}
