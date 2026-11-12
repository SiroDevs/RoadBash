// Project imports:
import '../../../../common/art/rider_facing.dart';
import '../../road/config/vehicle_config.dart';

/// Chooses which way a rival faces from where it is beside the player.
class RivalFacing {
  static const double startSeconds = 3.5;
  static const double enterSide = 0.08;
  static const double leaveSide = 0.04;
  static const double aheadMetres = 3;
  static const double aheadSlackMetres = 0.5;

  RiderFacing _current = RiderFacing.straight;

  /// Facing for a rival [sideOffset] road widths away and [gap] ahead.
  ///
  /// A rival turns toward the player only while beside him and up to a few
  /// metres ahead, and rides straight from the start and everywhere else.
  RiderFacing update({
    required double sideOffset,
    required double gap,
    required double raceClock,
  }) {
    final holding = _current != RiderFacing.straight;
    final side = holding ? leaveSide : enterSide;
    final reach = aheadMetres + (holding ? aheadSlackMetres : 0);
    final beside = sideOffset.abs() > side;
    final near = gap <= reach * VehicleConfig.unitsPerMetre;
    if (raceClock < startSeconds || !beside || !near) {
      return _current = RiderFacing.straight;
    }
    return _current = sideOffset < 0 ? RiderFacing.right : RiderFacing.left;
  }
}
