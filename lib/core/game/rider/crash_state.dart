// Dart imports:
import 'dart:math' as math;

/// A rider's fall: tipping over, lying still, then standing back up (unless kept down).
class CrashState {
  static const double fallTime = 0.35;
  static const double riseTime = 0.5;
  static const double lyingTilt = 1.35;
  static const double recoveryDuration = 3.2;

  double _remaining = 0;
  double _total = 0;
  double _side = 1;
  bool _stayDown = false;
  bool _recovering = false;
  double _runX = 0;
  double _runStartX = 0;
  double _bikeX = 0;
  double _steerOffset = 0;
  double _runTime = 0;

  /// True while the rider is down.
  bool get down => _remaining > 0;
  bool get recovering => _recovering;
  double get runX => _runX;
  double get side => _side;
  double get steerOffset => _steerOffset;
  double get runProgress =>
      (_runTime / recoveryDuration).clamp(0.0, 1.0).toDouble();
  double get fallProgress => down
      ? ((_total - _remaining) / fallTime).clamp(0.0, 1.0).toDouble()
      : 1.0;

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
    _bikeX = (lateral + _side * 0.15).clamp(-1.0, 1.0).toDouble();
    _runStartX = (lateral + _side * 0.35).clamp(-1.0, 1.0).toDouble();
    _runX = _runStartX;
    _steerOffset = 0;
    _runTime = 0;
    _stayDown = false;
    _remaining = 0;
  }

  /// Moves the rider toward the bike; caller supplies steering and remounts
  /// when the recovery timer completes.
  bool run(double dt, double steer) {
    if (!_recovering) return false;
    _runTime += dt;
    final progress = runProgress;
    final eased = progress * progress * (3 - 2 * progress);
    _steerOffset = (_steerOffset + steer * dt * 0.2)
        .clamp(-0.15, 0.15)
        .toDouble();
    _runX = (_runStartX + (_bikeX - _runStartX) * eased + _steerOffset)
        .clamp(-1.0, 1.0)
        .toDouble();
    return _runTime >= recoveryDuration;
  }

  /// A traffic strike knocks the runner back and costs time.
  void stumble() {
    if (!_recovering) return;
    _runTime = math.max(0, _runTime - 0.8);
  }

  void remount() {
    _recovering = false;
    _runTime = 0;
    _steerOffset = 0;
  }

  /// Counts the fall down by one frame.
  void update(double dt) {
    if (_remaining <= 0) return;
    final floor = _stayDown ? riseTime + 0.001 : 0.0;
    _remaining = math.max(floor, _remaining - dt);
  }
}
