// Dart imports:
import 'dart:math' as math;

/// A rider's fall: tipping over, lying still, then standing back up.
class CrashState {
  static const double fallTime = 0.35;
  static const double riseTime = 0.5;
  static const double lyingTilt = 1.35;

  double _remaining = 0;
  double _total = 0;
  double _side = 1;

  /// True while the rider is down.
  bool get down => _remaining > 0;

  /// Sideways tilt of the bike in radians, signed by the side it fell to.
  double get tilt {
    if (!down) return 0;
    final elapsed = _total - _remaining;
    var share = 1.0;
    if (elapsed < fallTime) {
      final fall = elapsed / fallTime;
      share = 1 - (1 - fall) * (1 - fall);
    } else if (_remaining < riseTime) {
      share = _remaining / riseTime;
    }
    return _side * lyingTilt * share;
  }

  /// Starts a fall toward [side] (1 right, -1 left) lasting [seconds].
  void start(double side, double seconds) {
    _side = side >= 0 ? 1 : -1;
    _total = math.max(seconds, fallTime + riseTime);
    _remaining = _total;
  }

  /// Counts the fall down by one frame.
  void update(double dt) {
    if (_remaining > 0) _remaining = math.max(0.0, _remaining - dt);
  }
}
