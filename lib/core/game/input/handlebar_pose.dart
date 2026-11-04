/// The two handlebar sides.
enum HandlebarSide { left, right }

/// Held state and vertical position of both handlebars.
class HandlebarPose {
  const HandlebarPose({
    this.leftHeld = false,
    this.rightHeld = false,
    this.leftOffset = 0,
    this.rightOffset = 0,
  });

  static const rest = HandlebarPose();
  static const double steerDeadzone = 0.08;

  final bool leftHeld, rightHeld;
  final double leftOffset, rightOffset;

  /// True while the right bar is held.
  bool get throttle => rightHeld;

  /// Steering from -1 to 1, only while both bars are held.
  double get steer {
    if (!leftHeld || !rightHeld) return 0;
    final raw = (rightOffset - leftOffset) / 2;
    if (raw.abs() < steerDeadzone) return 0;
    return raw.clamp(-1.0, 1.0).toDouble();
  }

  /// Returns whether a side is held.
  bool isHeld(HandlebarSide side) =>
      side == HandlebarSide.left ? leftHeld : rightHeld;

  /// Returns a side's vertical position, from -1 (up) to 1 (down).
  double offsetOf(HandlebarSide side) =>
      side == HandlebarSide.left ? leftOffset : rightOffset;
}
