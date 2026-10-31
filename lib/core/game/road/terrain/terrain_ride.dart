// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../config/road_config.dart';
import '../config/vehicle_config.dart';
import '../track/road_track.dart';
import 'terrain.dart';

/// What the ground and the slope do to a bike each frame.
class TerrainRide {
  TerrainRide({math.Random? luck}) : _luck = luck ?? math.Random();

  static const double _fallFrom = 0.62;
  static const double _skillWeight = 1.3;

  final math.Random _luck;

  Terrain current = Terrain.firm;
  bool fell = false;

  /// Returns the speed after one frame on [segment]; sets [fell] when the
  /// bike is thrown. Faster riders fall more, skilled riders less.
  double step({
    required double dt,
    required RoadSegment segment,
    required double lateral,
    required double speed,
    required double skill,
  }) {
    fell = false;
    final slope = (segment.y2 - segment.y1) / RoadConfig.segmentLength;
    var next = speed - slope * VehicleConfig.climbDrag * dt;
    final ground = segment.ground;
    current = ground.covers(lateral) ? ground.terrain : Terrain.firm;
    if (current == Terrain.firm) return next;

    final ceiling = VehicleConfig.maxSpeed * current.speedShare;
    if (next > ceiling) {
      next = math.max(ceiling, next - VehicleConfig.terrainDrag * dt);
    }
    final share = speed / VehicleConfig.maxSpeed;
    final over = ((share - _fallFrom) / (1 - _fallFrom)).clamp(0.0, 1.0);
    final risk = current.fallRisk * over * over * (_skillWeight - skill);
    fell = _luck.nextDouble() < risk * dt;
    return next;
  }
}
