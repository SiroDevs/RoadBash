// Dart imports:
import 'dart:math' as math;

/// A rider's fall: tipping over, lying still, then standing back up (unless kept down).
class CrashState {
  static const double fallTime = 0.35;
  static const double riseTime = 0.5;
  static const double lyingTilt = 1.35;
  static const double recoveryDuration = 3.2;
  static const double mountDuration = 0.6;
  static const double returnDuration = 0.75;

  double _remaining = 0;
  double _total = 0;
  double _side = 1;
  bool _stayDown = false;
  bool _recovering = false;
  double _runX = 0;
  double _runStartX = 0;
  double _bikeX = 0;
  double _crashX = 0;
  double _steerOffset = 0;
  double _runTime = 0;
  double _mountTime = 0;
  double _returnTime = 0;
  bool _mounting = false;
  bool _returning = false;

  /// True while the rider is down.
  bool get down => _remaining > 0;
  bool get recovering => _recovering;
  bool get running => _recovering && !_mounting && !_returning;
  bool get mounting => _recovering && _mounting;
  bool get returning => _recovering && _returning;
  double get runX => _runX;
  double get bikeX => _bikeX;
  double get side => _side;
  double get steerOffset => _steerOffset;
  double get runProgress =>
      (_runTime / recoveryDuration).clamp(0.0, 1.0).toDouble();
  double get mountProgress =>
      (_mountTime / mountDuration).clamp(0.0, 1.0).toDouble();
  double get returnProgress =>
      (_returnTime / returnDuration).clamp(0.0, 1.0).toDouble();
  double get crashX => _crashX;
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
  void start(double side, double seconds, {double lateral = 0}) {
    _side = side >= 0 ? 1 : -1;
    _total = math.max(seconds, fallTime + riseTime);
    _remaining = _total;
    _crashX = lateral;
    _bikeX = _side * 1.18;
    _runStartX = _side * 1.52;
    _runX = lateral;
    _stayDown = false;
    _recovering = false;
    _mounting = false;
    _returning = false;
  }

  /// Keeps the rider on the ground once the fall is over.
  void keepDown() => _stayDown = true;

  /// Starts the playable run back to the stopped bike after a wipeout.
  void startRecovery(double lateral) {
    _recovering = true;
    _crashX = lateral;
    _bikeX = _side * 1.18;
    _runStartX = _side * 1.52;
    _runX = _runStartX;
    _steerOffset = 0;
    _runTime = 0;
    _mountTime = 0;
    _returnTime = 0;
    _mounting = false;
    _returning = false;
    _stayDown = false;
    _remaining = 0;
  }

  /// Moves the rider toward the bike; caller supplies steering and remounts
  /// when the recovery timer completes.
  bool run(double dt, double steer) {
    if (!_recovering) return false;
    if (_mounting) {
      _mountTime += dt;
      if (_mountTime >= mountDuration) {
        _mounting = false;
        _returning = true;
        _returnTime = 0;
      }
      return false;
    }
    if (_returning) {
      _returnTime += dt;
      return _returnTime >= returnDuration;
    }
    _runTime += dt;
    final progress = runProgress;
    final eased = progress * progress * (3 - 2 * progress);
    _steerOffset = (_steerOffset + steer * dt * 0.2)
        .clamp(-0.15, 0.15)
        .toDouble();
    _runX = _runStartX + (_bikeX - _runStartX) * eased + _steerOffset;
    if (_runTime >= recoveryDuration) {
      _runTime = recoveryDuration;
      _runX = _bikeX;
      _mounting = true;
    }
    return false;
  }

  /// A traffic strike knocks the runner back and costs time.
  void stumble() {
    if (!running) return;
    _runTime = math.max(0, _runTime - 0.8);
  }

  void remount() {
    _recovering = false;
    _runTime = 0;
    _steerOffset = 0;
    _mounting = false;
    _returning = false;
    _mountTime = 0;
    _returnTime = 0;
  }

  /// Counts the fall down by one frame.
  void update(double dt) {
    if (_remaining <= 0) return;
    final floor = _stayDown ? riseTime + 0.001 : 0.0;
    _remaining = math.max(floor, _remaining - dt);
  }
}
