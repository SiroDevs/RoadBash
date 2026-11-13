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

  /// True while either gas grip is held.
  bool get throttle => leftHeld || rightHeld;

  /// True while either bar is held.
  bool get anyHeld => leftHeld || rightHeld;

  /// Lean from -1 (left) to 1 (right); right bar down or left bar up leans right.
  double get lean {
    if (leftHeld && rightHeld) {
      return ((rightOffset - leftOffset) / 2).clamp(-1.0, 1.0).toDouble();
    }
    if (rightHeld) return rightOffset;
    if (leftHeld) return -leftOffset;
    return 0;
  }

  /// Steering from -1 to 1; either bar steers because the bars move together.
  double get steer {
    final value = lean;
    return value.abs() < steerDeadzone ? 0 : value;
  }

  /// Returns whether a side is held.
  bool isHeld(HandlebarSide side) =>
      side == HandlebarSide.left ? leftHeld : rightHeld;
}
