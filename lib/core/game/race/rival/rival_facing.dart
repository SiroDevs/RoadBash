// Project imports:
import '../../rider/art/sheet/part_motion.dart';

/// Turns a rival's place relative to the player into a yaw toward the player.
abstract final class RivalFacing {
  static const double maxYaw = 0.25;
  static const double levelBand = 0.06;
  static const double aheadFrom = 24;
  static const double aheadTo = 204;

  /// Yaw for a rival [sideOffset] road widths from the player and [gap] ahead.
  static double yaw({
    required double sideOffset,
    required double gap,
    required int index,
    required bool atStart,
  }) {
    final direction = sideOffset.abs() > levelBand
        ? -sideOffset.sign
        : (index.isEven ? 1.0 : -1.0);
    final amount = atStart
        ? 1.0
        : 1 - PartMotion.smooth(aheadFrom, aheadTo, gap);
    return direction * amount * maxYaw;
  }
}
