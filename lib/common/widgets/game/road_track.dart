// Dart imports:
import 'dart:math' as math;

// Project imports:
import 'road_config.dart';

/// One slice of track. [y1]/[y2] are the world heights at its near/far edge,
/// [curve] is how much it bends the road (+ right, - left).
class RoadSegment {
  const RoadSegment(this.index, this.y1, this.y2, this.curve);
  final int index;
  final double y1;
  final double y2;
  final double curve;
}

/// A looping list of [RoadSegment]s built from simple sections.
class RoadTrack {
  RoadTrack() {
    _build();
  }

  final List<RoadSegment> segments = [];
  late final double length;
  double _lastY = 0;

  int get count => segments.length;

  /// Index of the segment containing world distance [z] (wraps around).
  int indexAt(double z) => (z / RoadConfig.segmentLength).floor() % count;

  RoadSegment at(double z) => segments[indexAt(z)];

  void _add(double curve, double y) {
    segments.add(RoadSegment(segments.length, _lastY, y, curve));
    _lastY = y;
  }

  static double _easeIn(double a, double b, double p) => a + (b - a) * p * p;
  static double _easeInOut(double a, double b, double p) =>
      a + (b - a) * (-math.cos(p * math.pi) / 2 + 0.5);

  /// Adds a section: ease into [curve] over [enter] segments, hold it for
  /// [hold], ease out over [leave]. [hill] is the net climb in segment lengths.
  void _addRoad(int enter, int hold, int leave, double curve, double hill) {
    final startY = _lastY;
    final endY = startY + hill * RoadConfig.segmentLength;
    final total = enter + hold + leave;
    for (var n = 0; n < enter; n++) {
      _add(_easeIn(0, curve, n / enter), _easeInOut(startY, endY, n / total));
    }
    for (var n = 0; n < hold; n++) {
      _add(curve, _easeInOut(startY, endY, (enter + n) / total));
    }
    for (var n = 0; n < leave; n++) {
      _add(_easeInOut(curve, 0, n / leave),
          _easeInOut(startY, endY, (enter + hold + n) / total));
    }
  }

  void _build() {
    // Hills sum to zero so the lap loops seamlessly.
    _addRoad(30, 40, 30, 0, 0); // warm-up straight
    _addRoad(40, 40, 40, 2, 0); // easy right
    _addRoad(25, 25, 25, 0, 20); // climb
    _addRoad(25, 25, 25, -3, -20); // left-hand descent
    _addRoad(40, 20, 40, 0, 0);
    _addRoad(20, 20, 20, 0, 40); // big crest
    _addRoad(30, 30, 30, 4, -40); // right-hander off the crest
    _addRoad(40, 40, 40, -5, 0); // hard left
    _addRoad(40, 40, 40, 3, 0); // sweeping right
    _addRoad(30, 40, 30, 0, 0);
    length = segments.length * RoadConfig.segmentLength;
  }
}
