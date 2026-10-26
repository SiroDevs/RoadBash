// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../domain/models/scene_id.dart';
import '../config/road_config.dart';
import '../scene/scene_theme.dart';

class RoadSegment {
  const RoadSegment(this.index, this.y1, this.y2, this.curve);
  final int index;
  final double y1;
  final double y2;
  final double curve;
}

class RoadTrack {
  RoadTrack(SceneId scene) {
    switch (scene) {
      case SceneId.city:
        _buildCity();
      case SceneId.suburbs:
        _buildSuburbs();
      case SceneId.thikaRoad:
        _buildThikaRoad();
    }
    length = segments.length * RoadConfig.segmentLength;
  }

  final List<RoadSegment> segments = [];

  final List<int> sectionStarts = [];
  late final double length;
  double _lastY = 0;

  int get count => segments.length;

  int indexAt(double z) => (z / RoadConfig.segmentLength).floor() % count;

  RoadSegment at(double z) => segments[indexAt(z)];

  static double raceKm(SceneId scene) =>
      RoadTrack(scene).length *
      SceneTheme.of(scene).laps *
      RoadConfig.unitKm;

  void _mark() => sectionStarts.add(segments.length);

  void _add(double curve, double y) {
    segments.add(RoadSegment(segments.length, _lastY, y, curve));
    _lastY = y;
  }

  static double _easeIn(double a, double b, double p) => a + (b - a) * p * p;
  static double _easeInOut(double a, double b, double p) =>
      a + (b - a) * (-math.cos(p * math.pi) / 2 + 0.5);

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

  void _buildThikaRoad() {
    // Ruiru
    _mark();
    _addRoad(50, 160, 50, 0, 0);
    _addRoad(45, 90, 45, 1.4, 3);
    _addRoad(50, 140, 50, 0, -3);
    _addRoad(45, 80, 45, -1.8, 0);
    _addRoad(50, 150, 50, 0, 0);

    // Pangani
    _mark();
    _addRoad(45, 70, 45, 0, 6);
    _addRoad(50, 80, 50, 0, 8);
    _addRoad(40, 60, 40, 2.4, 0);
    _addRoad(50, 80, 50, 0, -14);
    _addRoad(45, 90, 45, -2.2, 0);
    _addRoad(50, 120, 50, 0, 0);
    _addRoad(40, 50, 40, 2.0, 4);
    _addRoad(40, 40, 40, 0, -4);

    // Forest Rd
    _mark();
    _addRoad(45, 60, 45, -2.6, 4);
    _addRoad(45, 50, 45, 3.0, 0);
    _addRoad(40, 40, 40, -3.2, -4);
    _addRoad(50, 70, 50, 0, 5);
    _addRoad(45, 55, 45, 2.4, -5);
    _addRoad(45, 60, 45, -2.0, 0);
    _addRoad(50, 80, 50, 0, 0);

    // Museum Hill
    _mark();
    _addRoad(50, 70, 50, 0, 7);
    _addRoad(45, 60, 45, 3.2, 5);
    _addRoad(40, 45, 40, -3.6, 0);
    _addRoad(45, 50, 45, 0, -12);
    _addRoad(50, 70, 50, 2.0, 0);
    _addRoad(50, 150, 50, 0, 0);
  }
}
