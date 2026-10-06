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
}
