// Project imports:
import '../../rider/dust_trail.dart';
import '../../road/config/vehicle_config.dart';
import '../../road/ground/terrain.dart';
import '../../road/ground/terrain_ride.dart';
import '../../road/road_renderer.dart';

/// A rival's contact with the ground: terrain drag, falls and dust.
class RivalGround {
  static const double _lookAhead = 600;

  final TerrainRide _ride = TerrainRide();
  final DustTrail dust = DustTrail();

  /// True when the last step threw the rival off.
  bool get fell => _ride.fell;

  /// The ground the rival is riding on.
  Terrain get terrain => _ride.current;

  /// Returns the rival's speed after the ground and slope have had their say.
  double ride(
    double dt,
    RoadRenderer road,
    double ridden,
    double lateral,
    double speed,
    double skill,
  ) => _ride.step(
    dt: dt,
    segment: road.track.at(ridden + road.playerZ),
    lateral: lateral,
    speed: speed,
    skill: skill,
  );

  /// Returns the firm vehicle line a little way ahead, if the ground has one.
  double? goodLine(RoadRenderer road, double ridden) {
    final ground = road.track.at(ridden + road.playerZ + _lookAhead).ground;
    return ground.hasLane ? ground.laneCenter : null;
  }

  /// Keeps the dust going while the rival rolls over loose ground.
  void updateDust(double dt, double speed, {required bool down}) {
    final share = (speed / VehicleConfig.maxSpeed).clamp(0.0, 1.0);
    dust.update(
      dt,
      emitting: !down && _ride.current.dusty && share > 0.12,
      strength: share,
    );
  }
}
