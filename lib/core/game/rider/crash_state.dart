// Dart imports:
import 'dart:math' as math;

/// A rider's fall: tipping over, lying still, then standing back up (unless kept down).
class CrashState {
  static const double fallTime = 0.35;
  static const double riseTime = 0.5;
  static const double lyingTilt = 1.35;

  double _remaining = 0;
  double _total = 0;
  double _side = 1;
  bool _stayDown = false;
  bool _recovering = false;
  double _runX = 0;
  double _runTime = 0;

  /// True while the rider is down.
  bool get down => _remaining > 0;
  bool get recovering => _recovering;
  double get runX => _runX;

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

  /// Keeps the rider on the ground once the fall is over.
  void keepDown() => _stayDown = true;

  /// Starts the playable run back to the stopped bike after a wipeout.
  void startRecovery(double lateral) {
    _recovering = true;
    _runX = lateral;
    _runTime = 0;
    _stayDown = false;
    _remaining = 0;
  }

  /// Moves the rider toward the bike; caller supplies steering and remounts
  /// when the recovery timer completes.
  bool run(double dt, double steer) {
    if (!_recovering) return false;
    _runTime += dt;
    _runX = (_runX + steer * dt * 0.75).clamp(-1.0, 1.0).toDouble();
    return _runTime >= 3.2;
  }

  void remount() {
    _recovering = false;
    _runTime = 0;
  }

  /// Counts the fall down by one frame.
  void update(double dt) {
    if (_remaining <= 0) return;
    final floor = _stayDown ? riseTime + 0.001 : 0.0;
    _remaining = math.max(floor, _remaining - dt);
  }
}
