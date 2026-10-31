// Dart imports:
import 'dart:ui';

/// Kinds of ground on the road surface.
enum Terrain {
  firm(1, 0, false),
  loose(0.82, 0.05, true),
  stony(0.74, 0.14, true),
  potholed(0.6, 0.9, false),
  muddy(0.42, 0.7, true);

  const Terrain(this.speedShare, this.fallRisk, this.dusty);

  final double speedShare;
  final double fallRisk;
  final bool dusty;

  /// True for ground that covers only part of the road width.
  bool get patchOnly => this == potholed || this == muddy;

  /// True for ground that shakes the rider.
  bool get rough => this != firm && this != loose;

  /// Colour of the dust or spray a bike kicks up here.
  Color get dustTone =>
      this == muddy ? const Color(0xFF6B4A2E) : const Color(0xFFD2B48C);
}

/// The ground of one road segment and, for patches, where it lies.
class Ground {
  const Ground(this.terrain, {this.center = 0, this.half = 0});

  static const Ground firm = Ground(Terrain.firm);
  static const double _margin = 0.1;

  final Terrain terrain;
  final double center;
  final double half;

  /// True when a bike at [lateral] is riding on this ground.
  bool covers(double lateral) =>
      !terrain.patchOnly || (lateral - center).abs() <= half + _margin;
}
