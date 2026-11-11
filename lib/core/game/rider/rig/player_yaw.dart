// Project imports:
import '../art/sheet/part_motion.dart';

/// Turns steering, speed and road curve into the player's yaw, with no hard gate.
abstract final class PlayerYaw {
  static const double maxYaw = 0.3;

  /// Target yaw, negative left and positive right; zero on straights.
  static double target({
    required double steer,
    required double curve,
    required double speedShare,
  }) {
    final demand = (steer * 0.7 + curve * 0.06).clamp(-1.0, 1.0).toDouble();
    final pull = PartMotion.smooth(0.15, 0.7, demand.abs());
    final pace = PartMotion.smooth(0.35, 1.0, speedShare);
    return demand.sign * pull * pace * maxYaw;
  }
}
