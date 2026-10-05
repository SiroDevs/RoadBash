// Dart imports:
import 'dart:math' as math;

// Project imports:
import 'road_track.dart';

/// Reusable projected point (avoids allocating every frame).
class ProjPoint {
  double x = 0, y = 0, w = 0, z = 0;

  /// Screen pixels per world unit, vertically (for heights).
  double k = 0;
}

/// A segment that survived projection this frame, ready to be drawn.
class VisSeg {
  late RoadSegment seg;
  int n = 0; // how many segments away from the camera
  double x1 = 0, y1 = 0, w1 = 0, k1 = 0; // near edge
  double x2 = 0, y2 = 0, w2 = 0, k2 = 0; // far edge

  /// Highest screen line already covered by nearer road (hill occlusion).
  double clip = 0;
}

/// Cheap deterministic pseudo-random number in [0, 1) for [n].
double roadRand(int n) {
  final s = math.sin(n * 12.9898) * 43758.5453;
  return s - s.floorToDouble();
}
