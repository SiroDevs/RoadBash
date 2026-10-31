// Project imports:
import 'road_config.dart';

/// Bike speed, acceleration and steering constants.
abstract final class VehicleConfig {
  static const double maxSpeed = RoadConfig.segmentLength * 60;
  static const double topSpeedKmh = 240;
  static const double accel = maxSpeed / 5.4;
  static const double braking = -maxSpeed * 1.1;
  static const double decel = -maxSpeed / 3.4;
  static const double offRoadDecel = -maxSpeed / 2;
  static const double offRoadLimit = maxSpeed / 4;
  static const double stoppedSpeed = maxSpeed * 0.02;

  static const double steerAttack = 5.0;
  static const double steerRelease = 7.5;
  static const double steerRate = 1.9;
  static const double steerHighSpeedDamp = 0.45;

  static const double centrifugal = 0.22;
  static const double maxOffRoad = 1.45;

  static const double railImpactKeep = 0.9;
  static const double railScrape = -maxSpeed / 3;

  static const double crashDrag = -maxSpeed * 1.4;
  static const double shoveDecay = 4;

  static const double climbDrag = maxSpeed * 0.75;
  static const double terrainDrag = maxSpeed * 1.3;
  static const double playerSkill = 0.5;
}
