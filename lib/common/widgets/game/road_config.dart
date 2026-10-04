/// Tunable constants for the pseudo-3D road and the rider physics.
abstract final class RoadConfig {
  // Camera / projection
  static const double segmentLength = 200;
  static const double roadWidth = 1600; // world half-width
  static const double cameraHeight = 1000;
  static const double cameraDepth = 0.84; // 1 / tan(100deg / 2)
  static const double playerZ = cameraHeight * cameraDepth;
  static const double horizonRatio = 0.42;
  static const int drawDistance = 250;

  // Road look
  static const int rumbleLength = 3;
  static const int lanes = 3;

  // Rider physics
  static const double maxSpeed = segmentLength * 60; // 60 segments / second
  static const double accel = maxSpeed / 5;
  static const double braking = -maxSpeed;
  static const double decel = -maxSpeed / 5;
  static const double offRoadDecel = -maxSpeed / 2;
  static const double offRoadLimit = maxSpeed / 4;
  static const double centrifugal = 0.3;
}
