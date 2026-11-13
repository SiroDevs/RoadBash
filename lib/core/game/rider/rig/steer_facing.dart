// Project imports:
import '../../../../common/art/rider_facing.dart';

/// Picks how far the player's rider turns from how long a direction is held.
///
/// A quick tap only banks the rider, a short hold turns him slightly and a long
/// hold turns him extremely. Corners never go past slightly.
class SteerFacing {
  static const double enterSteer = 0.25;
  static const double leaveSteer = 0.15;
  static const double fullSteer = 0.85;
  static const double tapSeconds = 0.15;
  static const double longHoldSeconds = 0.7;
  static const double stepSeconds = 0.12;
  static const double minSpeedShare = 0.1;
  static const double cornerCurve = 0.5;

  RiderFacing _current = RiderFacing.straight;
  int _heldSide = 0;
  double _heldSeconds = 0;
  double _sinceStep = 0;

  /// Facing for the current [steer], negative left and positive right.
  RiderFacing update({
    required double dt,
    required double steer,
    required double speedShare,
    required double curve,
  }) {
    final side = _pressedSide(steer, speedShare);
    if (side == _heldSide) {
      _heldSeconds += dt;
    } else {
      _heldSide = side;
      _heldSeconds = 0;
    }
    _sinceStep += dt;
    final target = _targetFor(steer.abs(), curve.abs() >= cornerCurve);
    if (target != _current && _sinceStep >= stepSeconds) {
      _sinceStep = 0;
      _current = _current.stepToward(target);
    }
    return _current;
  }

  /// The side being steered toward, or zero when idle or too slow to turn.
  int _pressedSide(double steer, double speedShare) {
    if (speedShare < minSpeedShare) return 0;
    final threshold = _heldSide == 0 ? enterSteer : leaveSteer;
    return steer.abs() < threshold ? 0 : steer.sign.toInt();
  }

  RiderFacing _targetFor(double steerStrength, bool cornering) {
    final idle = _heldSide == 0 || _heldSeconds < tapSeconds;
    if (idle) return RiderFacing.straight;
    final extreme =
        !cornering &&
        steerStrength >= fullSteer &&
        _heldSeconds >= longHoldSeconds;
    return RiderFacing.of(
      extreme ? RiderTurn.extreme : RiderTurn.slight,
      _heldSide,
    );
  }
}
