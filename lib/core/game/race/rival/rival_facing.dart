// Project imports:
import '../../../../common/art/rider_facing.dart';
import '../../road/config/vehicle_config.dart';

/// Chooses which way a rival faces from where it is beside the player.
class RivalFacing {
  RivalFacing(this.index);

  static const double releaseSeconds = 0.3;
  static const double releaseStagger = 0.25;
  static const double startSeconds = 3.5;
  static const double enterSide = 0.08;
  static const double leaveSide = 0.04;
  static const double aheadMetres = 3;
  static const double aheadSlackMetres = 0.5;

  final int index;

  RiderFacing _current = RiderFacing.straight;

  /// Facing for a rival [sideOffset] road widths away and [gap] ahead.
  ///
  /// On the grid a rival faces toward the player and turns straight a moment
  /// after the start, the outer riders last. Later it faces him only while
  /// beside him and up to a few metres ahead.
  RiderFacing update({
    required double sideOffset,
    required double gap,
    required double raceClock,
  }) {
    final holding = _current != RiderFacing.straight;
    final side = holding ? leaveSide : enterSide;
    final beside = sideOffset.abs() > side;
    if (raceClock <= releaseSeconds + releaseStagger * index) {
      return _current = _toward(sideOffset, beside);
    }
    if (raceClock < startSeconds) return _current = RiderFacing.straight;
    final reach = aheadMetres + (holding ? aheadSlackMetres : 0);
    final near = gap <= reach * VehicleConfig.unitsPerMetre;
    return _current = _toward(sideOffset, beside && near);
  }

  RiderFacing _toward(double sideOffset, bool facing) {
    if (!facing) return RiderFacing.straight;
    return sideOffset < 0 ? RiderFacing.right : RiderFacing.left;
  }
}
