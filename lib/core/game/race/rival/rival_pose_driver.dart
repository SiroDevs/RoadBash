// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../common/art/rider_frame.dart';
import '../../../../common/art/rider_pose.dart';
import '../../road/config/vehicle_config.dart';

/// Animates a rival's rider pose from its speed, steering and the road curve.
class RivalPoseDriver {
  RivalPoseDriver(this.pose, this.seed);

  final RiderPose pose;
  final int seed;

  double _time = 0;

  /// Updates the pose for one frame.
  void update({
    required double dt,
    required double speed,
    required double steerRate,
    required double curve,
    required bool crossed,
  }) {
    final speedRatio = (speed / VehicleConfig.maxSpeed)
        .clamp(0.0, 1.0)
        .toDouble();
    final stopped = speed < VehicleConfig.stoppedSpeed;
    final resting = stopped;
    final braking = crossed && !stopped;
    final ease = math.min(1.0, dt * 8);
    _time += dt;

    pose.speed = speedRatio;
    pose.braking = braking;
    pose.steer +=
        ((steerRate / 0.7).clamp(-1.0, 1.0).toDouble() - pose.steer) * ease;
    pose.foot += ((resting ? 1.0 : 0.0) - pose.foot) * math.min(1.0, dt * 5);
    final bank =
        (pose.steer * 0.30 + curve * 0.040) * (0.3 + 0.7 * speedRatio) -
        0.12 * pose.foot;
    final lean = bank.clamp(-RiderFrame.maxLean, RiderFrame.maxLean).toDouble();
    pose.lean += (lean - pose.lean) * math.min(1.0, dt * 6);
    final pitch = braking ? -1.0 : 0.5;
    pose.pitch += (pitch * speedRatio - pose.pitch) * math.min(1.0, dt * 6);
    pose.bob =
        math.sin(_time * 13 + seed) * 1.1 * speedRatio +
        math.max(0.0, -pose.pitch) * 2.5;
    if (!stopped) pose.phase = (pose.phase + speedRatio * dt * 3) % 1;
  }
}
