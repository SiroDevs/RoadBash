// Project imports:
import '../../../../common/art/rider_facing.dart';

/// Picks which way the player's rider faces in a corner, without flicker.
class CornerFacing {
  static const double enterYaw = 0.09;
  static const double leaveYaw = 0.04;

  RiderFacing _current = RiderFacing.straight;

  /// Facing for the current [yaw], negative left and positive right.
  RiderFacing update(double yaw) {
    final threshold = _current == RiderFacing.straight ? enterYaw : leaveYaw;
    _current = yaw.abs() < threshold
        ? RiderFacing.straight
        : RiderFacing.ofYaw(yaw, threshold: leaveYaw);
    return _current;
  }
}
