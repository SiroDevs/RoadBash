abstract final class RoadConfig {
  static const double segmentLength = 200;
  static const double roadWidth = 2000;
  static const double cameraHeight = 1000;
  static const double cameraDepth = 0.84;
  static const double horizonRatio = 0.42;
  static const int drawDistance = 200;
  static const int decorDistance = 100;
  static const int rumbleLength = 3;

  static const double maxSpeed = segmentLength * 60;
  static const double topSpeedKmh = 240;
  static const double accel = maxSpeed / 5;
  static const double braking = -maxSpeed * 1.1;
  static const double decel = -maxSpeed / 3;
  static const double offRoadDecel = -maxSpeed / 2;
  static const double offRoadLimit = maxSpeed / 4;
  static const double centrifugal = 0.3;
  static const double stoppedSpeed = maxSpeed * 0.02;

  /// One world unit in kilometres, for the "Length" label only.
  static const double unitKm = 0.0000044;
}
