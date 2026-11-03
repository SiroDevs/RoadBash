// Project imports:
import '../road/config/vehicle_config.dart';

/// How a rival rider is behaving at the moment.
enum RivalMood { cruise, chase, draft, overtake, defend, slip, attack }

/// Helpers on [RivalMood].
extension RivalMoodEffort on RivalMood {
  /// True when the mood makes the rival ride hard and tire.
  bool get pushing =>
      this == RivalMood.chase ||
      this == RivalMood.overtake ||
      this == RivalMood.defend ||
      this == RivalMood.attack;
}

/// What a rival rider can see around it this frame.
class RivalSight {
  double ownDistance = 0;
  double ownSpeed = 0;
  double ownLateral = 0;
  double playerDistance = 0;
  double playerSpeed = 0;
  double playerLateral = 0;
  double raceLength = 1;
  double? peerGapSeconds;
  double peerLateral = 0;

  /// How far the player is ahead of the rival; negative when the rival leads.
  double get deficit => playerDistance - ownDistance;

  /// The player's speed as a share of the top speed.
  double get playerFraction =>
      (playerSpeed / VehicleConfig.maxSpeed).clamp(0.0, 1.0).toDouble();

  /// How much of the race the rival has covered.
  double get raceFraction =>
      (ownDistance / raceLength).clamp(0.0, 1.0).toDouble();
}
