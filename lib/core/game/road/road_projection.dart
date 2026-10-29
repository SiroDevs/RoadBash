// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import 'config/road_config.dart';
import 'track/road_track.dart';

class ProjectionPoint {
  double x = 0, y = 0, w = 0, z = 0;

  double k = 0;

  // Projects a world point onto the screen.
  void project(
    double wy,
    double wz,
    double camX,
    double camY,
    double camZ,
    Vector2 size,
    double spread,
  ) {
    final depth = wz - camZ;
    final scale = RoadConfig.cameraDepth / depth;
    final unit = size.y / 2;
    z = depth;
    x = size.x / 2 + scale * (0 - camX) * unit * spread;
    y = size.y * RoadConfig.horizonRatio - scale * (wy - camY) * unit;
    w = scale * RoadConfig.roadWidth * unit * spread;
    k = scale * unit;
  }
}

class VisionSeg {
  late RoadSegment seg;
  int n = 0;
  double x1 = 0, y1 = 0, w1 = 0, k1 = 0;
  double x2 = 0, y2 = 0, w2 = 0, k2 = 0;

  double clip = 0;

  double fog = 0;

  // Fog amount for the segment [index] rows ahead of the camera.
  static double fogAt(int index) {
    const start = RoadConfig.fogStart, end = RoadConfig.fogEnd;
    final amount = (index / RoadConfig.drawDistance - start) / (end - start);
    return amount < 0 ? 0.0 : (amount > 1 ? 1.0 : amount);
  }

  void fill(
    RoadSegment segment,
    int index,
    ProjectionPoint near,
    ProjectionPoint far,
    double clipY,
  ) {
    seg = segment;
    n = index;
    x1 = near.x;
    y1 = near.y;
    w1 = near.w;
    k1 = near.k;
    x2 = far.x;
    y2 = far.y;
    w2 = far.w;
    k2 = far.k;
    clip = clipY;
    fog = fogAt(index);
  }
}

class SpanPoint {
  double x = 0, y = 0, k = 0;

  void lerp(VisionSeg near, VisionSeg far, double fraction, double cx, double horizonY) {
    final an = (near.x1 - cx) / near.k1, af = (far.x1 - cx) / far.k1;
    final bn = (near.y1 - horizonY) / near.k1, bf = (far.y1 - horizonY) / far.k1;
    k = 1 / ((1 - fraction) / near.k1 + fraction / far.k1);
    x = cx + k * (an + (af - an) * fraction);
    y = horizonY + k * (bn + (bf - bn) * fraction);
  }
}
