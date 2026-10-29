// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../../domain/models/scene_id.dart';
import '../config/road_config.dart';
import '../finish/finish_config.dart';
import '../routes/route_stretch.dart';
import '../routes/thika/thika_route.dart';
import '../scene_theme.dart';
import 'road_section.dart';

class RoadSegment {
  const RoadSegment(
    this.index,
    this.y1,
    this.y2,
    this.curve, [
    this.section = Section.plain,
  ]);
  final int index;
  final double y1;
  final double y2;
  final double curve;
  final Section section;
}

class RoadTrack {
  RoadTrack(SceneId scene) {
    switch (scene) {
      case SceneId.city:
        _buildCity();
      case SceneId.suburbs:
        _buildSuburbs();
      case SceneId.thikaRoad:
        _buildRoute(thikaRoute);
      case SceneId.jungle:
        _buildJungle();
      case SceneId.dirtRoad:
        _buildDirtRoad();
    }
    length = segments.length * RoadConfig.segmentLength;
  }

  final List<RoadSegment> segments = [];

  final List<int> sectionStarts = [];
  late final double length;
  double _lastY = 0;

  int get count => segments.length;

  /// Index of the finish line. The last lap stops [FinishConfig.runOut]
  /// segments short of the lap's end, so the scene's own road carries on past
  /// the line.
  int get finishIndex => count - FinishConfig.runOut;

  double get runOutLength => FinishConfig.runOut * RoadConfig.segmentLength;

  int indexAt(double z) => (z / RoadConfig.segmentLength).floor() % count;

  RoadSegment at(double z) => segments[indexAt(z)];

  static double raceKm(SceneId scene) {
    final track = RoadTrack(scene);
    final laps = SceneTheme.of(scene).laps;
    return (track.length * laps - track.runOutLength) * RoadConfig.unitKm;
  }

  void _mark() => sectionStarts.add(segments.length);

  void _add(double curve, double y, Section section) {
    segments.add(RoadSegment(segments.length, _lastY, y, curve, section));
    _lastY = y;
  }

  static double _easeIn(double a, double b, double p) => a + (b - a) * p * p;
  static double _easeInOut(double a, double b, double p) =>
      a + (b - a) * (-math.cos(p * math.pi) / 2 + 0.5);

  void _addRoad(
    int enter,
    int hold,
    int leave,
    double curve,
    double hill, [
    Section section = Section.plain,
  ]) {
    final startY = _lastY;
    final endY = startY + hill * RoadConfig.segmentLength;
    final total = enter + hold + leave;
    var step = 0;
    double y() => _easeInOut(startY, endY, ++step / total);

    for (var n = 0; n < enter; n++) {
      _add(_easeIn(0, curve, n / enter), y(), section);
    }
    for (var n = 0; n < hold; n++) {
      _add(curve, y(), section);
    }
    for (var n = 0; n < leave; n++) {
      _add(_easeInOut(curve, 0, n / leave), y(), section);
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

  // Tight, twisting and steep. Hills sum to zero so the lap closes cleanly.
  void _buildJungle() {
    _addRoad(40, 50, 40, 0, 0);
    _addRoad(40, 40, 40, 3.2, 6);
    _addRoad(35, 30, 35, -4.0, -6);
    _addRoad(40, 35, 40, 4.6, 9);
    _addRoad(35, 30, 35, -3.6, -3);
    _addRoad(40, 40, 40, -4.8, -6);
    _addRoad(35, 30, 35, 3.0, 4);
    _addRoad(45, 40, 45, 0, -4);
    _addRoad(40, 45, 40, 4.2, 0);
    _addRoad(40, 40, 40, -3.4, 0);
    _addRoad(45, 60, 45, 0, 0);
  }

  // Long open stretches, rolling crests and a few wide bends.
  void _buildDirtRoad() {
    _addRoad(45, 70, 45, 0, 0);
    _addRoad(50, 50, 50, 1.8, 7);
    _addRoad(45, 45, 45, -2.2, -3);
    _addRoad(40, 40, 40, 2.8, -4);
    _addRoad(45, 60, 45, 0, 5);
    _addRoad(45, 40, 45, -3.0, -5);
    _addRoad(40, 50, 40, 3.4, 8);
    _addRoad(45, 40, 45, -3.8, -8);
    _addRoad(40, 40, 40, 2.0, 3);
    _addRoad(45, 40, 45, -1.8, -3);
    _addRoad(45, 80, 45, 0, 0);
  }

  void _buildRoute(List<RouteStretch> route) {
    for (final stretch in route) {
      _mark();
      var used = 0;
      for (var k = 0; k < stretch.pieces.length; k++) {
        final piece = stretch.pieces[k];
        final last = k == stretch.pieces.length - 1;
        final len = last
            ? stretch.length - used
            : (stretch.length * piece.weight).round();
        used += len;
        final ramp = (len * 0.25).round();
        _addRoad(
          ramp,
          len - 2 * ramp,
          ramp,
          piece.curve,
          piece.hill,
          piece.section ?? stretch.section,
        );
      }
    }
  }
}
