// Project imports:
import 'track/road_track.dart';

class ProjectionPoint {
  double x = 0, y = 0, w = 0, z = 0;

  double k = 0;
}

class VisionSeg {
  late RoadSegment seg;
  int n = 0;
  double x1 = 0, y1 = 0, w1 = 0, k1 = 0;
  double x2 = 0, y2 = 0, w2 = 0, k2 = 0;

  double clip = 0;

  double fog = 0;
}

// k is 1/z, so interpolate 1/k to keep buildings from bending.
class SpanPoint {
  double x = 0, y = 0, k = 0;

  void lerp(VisionSeg near, VisionSeg far, double t, double cx, double horizonY) {
    final an = (near.x1 - cx) / near.k1, af = (far.x1 - cx) / far.k1;
    final bn = (near.y1 - horizonY) / near.k1, bf = (far.y1 - horizonY) / far.k1;
    k = 1 / ((1 - t) / near.k1 + t / far.k1);
    x = cx + k * (an + (af - an) * t);
    y = horizonY + k * (bn + (bf - bn) * t);
  }
}
