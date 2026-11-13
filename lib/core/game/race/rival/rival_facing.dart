// Project imports:
import '../../../../common/art/rider_facing.dart';
import '../../road/config/vehicle_config.dart';

/// Chooses how far a rival turns toward the player from the gap between them.
///
/// A rival ahead of the player turns extremely when it is just ahead, then
/// slightly, then rides straight as the gap grows. The player closing in on it
/// runs the same steps in reverse. Level with or behind the player it turns
/// only slightly, as when overtaking or being overtaken.
class RivalFacing {
  static const double extremeMetres = 1.5;
  static const double slightMetres = 4;
  static const double slackMetres = 0.5;
  static const double enterSide = 0.08;
  static const double leaveSide = 0.04;
  static const double stepSeconds = 0.15;

  RiderFacing _current = RiderFacing.straight;
  double _sinceStep = 0;

  /// Facing for a rival [sideOffset] road widths away and [gap] ahead.
  RiderFacing update({
    required double dt,
    required double sideOffset,
    required double gap,
  }) {
    _sinceStep += dt;
    final target = _targetFor(sideOffset, gap);
    if (target != _current && _sinceStep >= stepSeconds) {
      _sinceStep = 0;
      _current = _current.stepToward(target);
    }
    return _current;
  }

  RiderFacing _targetFor(double sideOffset, double gap) {
    final holding = _current != RiderFacing.straight;
    final beside = sideOffset.abs() > (holding ? leaveSide : enterSide);
    if (!beside) return RiderFacing.straight;
    final turn = _turnFor(gap / VehicleConfig.unitsPerMetre, holding);
    return RiderFacing.of(turn, sideOffset < 0 ? 1 : -1);
  }

  RiderTurn _turnFor(double metresAhead, bool holding) {
    final slack = holding ? slackMetres : 0.0;
    final behindLimit = _current.turn == RiderTurn.extreme ? -slackMetres : 0.0;
    if (metresAhead < behindLimit) {
      return metresAhead >= -(slightMetres + slack)
          ? RiderTurn.slight
          : RiderTurn.none;
    }
    if (metresAhead <= extremeMetres + slack) return RiderTurn.extreme;
    if (metresAhead <= slightMetres + slack) return RiderTurn.slight;
    return RiderTurn.none;
  }
}
