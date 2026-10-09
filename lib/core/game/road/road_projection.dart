// Project imports:
import 'road_track.dart';

class ProjPoint {
  double x = 0, y = 0, w = 0, z = 0;

  /// Screen pixels per world unit, vertically.
  double k = 0;
}

class VisSeg {
  late RoadSegment seg;
  int n = 0;
  double x1 = 0, y1 = 0, w1 = 0, k1 = 0;
  double x2 = 0, y2 = 0, w2 = 0, k2 = 0;

  /// Highest screen line already covered by nearer road (hill occlusion).
  double clip = 0;

  /// 0 at the camera, 1 once fully swallowed by the horizon haze.
  double fog = 0;
}

/// A point interpolated between the near edges of two visible segments.
///
/// Screen x and y are not linear in world depth, so a plain lerp bends
/// buildings. Vertical scale [k] is proportional to 1/z, which makes 1/k
/// linear in world depth — so interpolate there and rebuild x and y from it.
class SpanPoint {
  double x = 0, y = 0, k = 0;

  void lerp(VisSeg near, VisSeg far, double t, double cx, double horizonY) {
    final an = (near.x1 - cx) / near.k1, af = (far.x1 - cx) / far.k1;
    final bn = (near.y1 - horizonY) / near.k1, bf = (far.y1 - horizonY) / far.k1;
    k = 1 / ((1 - t) / near.k1 + t / far.k1);
    x = cx + k * (an + (af - an) * t);
    y = horizonY + k * (bn + (bf - bn) * t);
  }
}
