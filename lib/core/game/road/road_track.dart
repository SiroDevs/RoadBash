// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../domain/models/scene_id.dart';
import 'road_config.dart';
import 'road_theme.dart';

class RoadSegment {
  const RoadSegment(this.index, this.y1, this.y2, this.curve);
  final int index;
  final double y1;
  final double y2;
  final double curve;
}

/// A looping track. Each builder's hills sum to zero so laps join up.
class RoadTrack {
  RoadTrack(SceneId scene) {
    if (scene == SceneId.city) {
      _buildCity();
    } else {
      _buildSuburbs();
    }
    length = segments.length * RoadConfig.segmentLength;
  }

  final List<RoadSegment> segments = [];
  late final double length;
  double _lastY = 0;

  int get count => segments.length;

  int indexAt(double z) => (z / RoadConfig.segmentLength).floor() % count;

  RoadSegment at(double z) => segments[indexAt(z)];

  static double raceKm(SceneId scene) =>
      RoadTrack(scene).length *
      SceneTheme.of(scene).laps *
      RoadConfig.unitKm;

  void _add(double curve, double y) {
    segments.add(RoadSegment(segments.length, _lastY, y, curve));
    _lastY = y;
  }

  static double _easeIn(double a, double b, double p) => a + (b - a) * p * p;
  static double _easeInOut(double a, double b, double p) =>
      a + (b - a) * (-math.cos(p * math.pi) / 2 + 0.5);

  /// Eases into [curve] over [enter] segments, holds it for [hold], eases out
  /// over [leave]. [hill] is the net climb in segment lengths.
  ///
  /// The height ramp runs across the whole stretch and lands exactly on the
  /// target, so hills that sum to zero leave the lap joint perfectly flat.
  void _addRoad(int enter, int hold, int leave, double curve, double hill) {
    final startY = _lastY;
    final endY = startY + hill * RoadConfig.segmentLength;
    final total = enter + hold + leave;
    var step = 0;
    double y() => _easeInOut(startY, endY, ++step / total);

    for (var n = 0; n < enter; n++) {
      _add(_easeIn(0, curve, n / enter), y());
    }
    for (var n = 0; n < hold; n++) {
      _add(curve, y());
    }
    for (var n = 0; n < leave; n++) {
      _add(_easeInOut(curve, 0, n / leave), y());
    }
  }

  /// Gradients here are road gradients, not ski jumps: a hill of 6 over 140
  /// segments is about 1 in 20. Anything steeper swings the horizon hard
  /// enough to make the whole scene look like it is lurching.
  void _buildCity() {
    _addRoad(45, 70, 45, 0, 0);
    _addRoad(40, 35, 40, 2.0, 5);
    _addRoad(45, 50, 45, 0, 0);
    _addRoad(40, 40, 40, -2.6, -5);
    _addRoad(50, 35, 50, 0, 7);
    _addRoad(40, 30, 40, 3.0, -7);
    _addRoad(45, 60, 45, 0, 0);
    _addRoad(40, 40, 40, -3.0, 0);
    _addRoad(45, 35, 45, 0, 6);
    _addRoad(40, 35, 40, 1.8, -6);
    _addRoad(50, 70, 50, 0, 0);
  }

  void _buildSuburbs() {
    _addRoad(45, 60, 45, 0, 0);
    _addRoad(45, 45, 45, 2.6, 8);
    _addRoad(45, 40, 45, -3.4, 0);
    _addRoad(40, 35, 40, 0, -8);
    _addRoad(50, 50, 50, 4.0, 10);
    _addRoad(45, 45, 45, -2.6, -10);
    _addRoad(40, 40, 40, 0, 9);
    _addRoad(50, 55, 50, 3.4, -9);
    _addRoad(45, 45, 45, -4.2, 0);
    _addRoad(40, 40, 40, 2.2, 0);
    _addRoad(45, 70, 45, 0, 0);
  }
}
