/// Direction a rear facing rider turns toward.
enum RiderFacing {
  left,
  straight,
  right;

  /// Facing for a yaw, negative left and positive right, with a dead zone.
  static RiderFacing ofYaw(double yaw, {double threshold = 0.08}) {
    if (yaw.abs() < threshold) return straight;
    return yaw > 0 ? right : left;
  }
}
