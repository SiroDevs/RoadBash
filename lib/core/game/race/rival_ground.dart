// Project imports:
import '../rider/dust_trail.dart';
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import '../road/terrain/terrain.dart';
import '../road/terrain/terrain_ride.dart';

/// A rival's contact with the ground: terrain drag, falls and dust.
class RivalGround {
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
