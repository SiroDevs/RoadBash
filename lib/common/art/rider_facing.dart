/// How far a rear facing rider turns.
enum RiderTurn { none, slight, extreme }

/// Which way and how far a rear facing rider turns, ordered left to right.
enum RiderFacing {
  extremelyLeft,
  slightlyLeft,
  straight,
  slightlyRight,
  extremelyRight;

  static const int _centre = 2;

  /// Facing for a [turn] toward [side], negative left and positive right.
  static RiderFacing of(RiderTurn turn, int side) =>
      values[_centre + side.sign * turn.index];

  /// Negative when turned left, positive when turned right, zero when straight.
  int get side => (index - _centre).sign;

  /// How far the rider is turned.
  RiderTurn get turn => RiderTurn.values[(index - _centre).abs()];

  /// The facing one step closer to [target], passing through straight.
  RiderFacing stepToward(RiderFacing target) =>
      values[index + (target.index - index).sign];
}
