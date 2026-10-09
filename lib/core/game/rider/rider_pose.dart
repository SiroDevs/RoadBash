/// Everything the rider painter needs to know for one frame. The component
/// works these out from the road; the painter only draws them.
class RiderPose {
  /// Bank angle in radians. Positive leans right.
  double lean = 0;

  /// Rear wheel rotation, 0 to 1 and wrapping.
  double phase = 0;

  /// Off-road jitter, in design-box units.
  double shake = 0;

  /// Suspension travel, in design-box units. Positive squats.
  double bob = 0;

  /// -1 under hard braking (nose dives, tail lifts) to 1 under power.
  double pitch = 0;

  /// 0 with both feet up, 1 with the left boot planted on the road.
  double foot = 0;

  /// Road speed, 0 to 1. Drives the tuck and the wheel blur.
  double speed = 0;

  /// Steering input, for the small counter-lean of the head and the bars.
  double steer = 0;

  bool braking = false;
}
