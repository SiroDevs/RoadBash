/// How a rival rider is behaving at the moment.
enum RivalMood { cruise, chase, draft, overtake, defend, slip }

/// What a rival rider can see around it this frame.
class RivalSight {
  double ownDistance = 0;
  double ownSpeed = 0;
  double ownLateral = 0;
  double playerDistance = 0;
  double playerLateral = 0;
  double raceLength = 1;
  double? peerGapSeconds;
  double peerLateral = 0;

  /// How far the player is ahead of the rival; negative when the rival leads.
  double get deficit => playerDistance - ownDistance;

  /// How much of the race the rival has covered.
  double get raceFraction =>
      (ownDistance / raceLength).clamp(0.0, 1.0).toDouble();
}
