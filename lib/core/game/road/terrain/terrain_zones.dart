// Dart imports:
import 'dart:math' as math;

// Project imports:
import 'terrain.dart';

/// A stretch of road with one kind of ground, given as fractions of the course.
class TerrainZone {
  const TerrainZone(
    this.from,
    this.to,
    this.terrain, {
    this.center = 0,
    this.half = 0,
  });

  final double from;
  final double to;
  final Terrain terrain;
  final double center;
  final double half;

  /// Returns the ground at [progress] (0 to 1) along the zone; mud pools taper.
  Ground groundAt(double progress) {
    final width = terrain == Terrain.muddy
        ? half * math.sin(progress * math.pi)
        : half;
    return Ground(terrain, center: center, half: width);
  }
}
