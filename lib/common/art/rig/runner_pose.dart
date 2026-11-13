// Dart imports:
import 'dart:math' as math;

/// Joint angles of one leg: thigh from vertical, knee flex and foot trim.
class LegJoints {
  const LegJoints({this.thigh = 0, this.flex = 0.2, this.foot = 0});

  /// Thigh angle from straight down, forward positive.
  final double thigh;

  /// Knee flex, the shin folding backward under the thigh.
  final double flex;

  /// Extra foot rotation about the ankle.
  final double foot;

  /// Blends two leg poses.
  static LegJoints lerp(LegJoints from, LegJoints to, double amount) =>
      LegJoints(
        thigh: from.thigh + (to.thigh - from.thigh) * amount,
        flex: from.flex + (to.flex - from.flex) * amount,
        foot: from.foot + (to.foot - from.foot) * amount,
      );
}

/// Everything the runner figure needs to draw one frame.
class RunnerPose {
  const RunnerPose({
    this.far = const LegJoints(),
    this.near = const LegJoints(),
    this.armFar = 0,
    this.armNear = 0,
    this.lean = 0,
    this.bounce = 0,
  });

  final LegJoints far;
  final LegJoints near;
  final double armFar;
  final double armNear;
  final double lean;
  final double bounce;

  /// Blends two body poses.
  static RunnerPose lerp(RunnerPose from, RunnerPose to, double amount) =>
      RunnerPose(
        far: LegJoints.lerp(from.far, to.far, amount),
        near: LegJoints.lerp(from.near, to.near, amount),
        armFar: from.armFar + (to.armFar - from.armFar) * amount,
        armNear: from.armNear + (to.armNear - from.armNear) * amount,
        lean: from.lean + (to.lean - from.lean) * amount,
        bounce: from.bounce + (to.bounce - from.bounce) * amount,
      );
}

/// Builds running poses with alternating legs and opposite arm swing.
class RunGait {
  static const double stride = 0.62;
  static const double armSwing = 0.9;

  /// Leg joints at a point of the stride cycle, 0 to 1.
  static LegJoints leg(double cycle) {
    final unit = cycle - cycle.floorToDouble();
    final thigh = -stride * math.cos(2 * math.pi * unit);
    final swinging = unit < 0.5;
    final flex = swinging
        ? 0.25 + 1.15 * math.sin(2 * math.pi * unit)
        : 0.25 + 0.2 * math.sin(2 * math.pi * (unit - 0.5));
    final foot = swinging ? 0.25 * math.sin(2 * math.pi * unit) : -0.1;
    return LegJoints(thigh: thigh, flex: flex, foot: foot);
  }

  /// The whole body at a point of the stride cycle.
  static RunnerPose at(
    double cycle, {
    double restFar = 0.76,
    double restNear = -0.37,
  }) {
    final far = leg(cycle);
    final near = leg(cycle + 0.5);
    return RunnerPose(
      far: far,
      near: near,
      armFar: armSwing * (far.thigh - restFar),
      armNear: armSwing * (near.thigh - restNear),
      lean: 0.07,
      bounce: -2.2 * math.sin(2 * math.pi * cycle).abs(),
    );
  }
}
