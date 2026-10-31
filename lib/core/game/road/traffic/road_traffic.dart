// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../hud/dashboard_layout.dart';
import '../../rider/rider_rig.dart';
import '../config/road_config.dart';
import '../props/road_props.dart';
import '../road_projection.dart';
import 'road_actor.dart';

/// Places the other bikes on the road and paints them in depth order.
class RoadTraffic {
  RoadTraffic(this.actors, this.lanes)
      : _row = List.filled(actors.length, -1),
        _blend = List.filled(actors.length, 0),
        _paintRow = List.filled(actors.length, 0),
        _distance = List.filled(actors.length, 0),
        _isBehind = List.filled(actors.length, false),
        _placed = List.filled(actors.length, false),
        _x = List.filled(actors.length, 0),
        _y = List.filled(actors.length, 0),
        _height = List.filled(actors.length, 0),
        _clip = List.filled(actors.length, 0);

  final List<RoadActor> actors;
  final int lanes;
  final List<int> _row;
  final List<double> _blend;
  final List<int> _paintRow;
  final List<double> _distance;
  final List<bool> _isBehind;
  final List<bool> _placed;
  final List<double> _x;
  final List<double> _y;
  final List<double> _height;
  final List<double> _clip;
  List<int> _order = const [];
  double _screenWidth = 0;

  /// Works out which scenery row every visible actor stands on this frame.
  ///
  /// Actors beyond the player's rider are drawn with the scenery; the ones
  /// closer to the camera are drawn on top of everything, like the rider.
  void prepare(
    double trkPosition,
    double fullDistance,
    double playerZ,
    RoadProps props,
    int baseIndex,
  ) {
    const len = RoadConfig.segmentLength;
    final reach = RoadConfig.decorDistance * len;
    final base = (trkPosition / len).floor();
    final visible = <int>[];
    for (var i = 0; i < actors.length; i++) {
      _placed[i] = false;
      final dz = actors[i].distance - fullDistance;
      if (dz < -playerZ * 0.65 || dz > reach) {
        _row[i] = -1;
        continue;
      }
      final trackRow = (trkPosition + playerZ + dz) / len;
      _row[i] = trackRow.floor() - base;
      _blend[i] = trackRow - trackRow.floor();
      _distance[i] = dz;
      _isBehind[i] = dz < 0;
      _paintRow[i] = props.coverStart(baseIndex, _row[i]);
      visible.add(i);
    }
    visible.sort((a, b) => _distance[b].compareTo(_distance[a]));
    _order = visible;
  }

  /// Places the actors that are closer than the player's rider for [paintBehind].
  void locateBehind(VisionSeg? Function(int row) visionAt, Vector2 size) {
    _screenWidth = size.x;
    for (final i in _order) {
      if (!_isBehind[i]) continue;
      final vision = visionAt(_row[i]);
      if (vision != null) _placed[i] = _place(i, vision, size);
    }
  }

  /// Paints the actors beyond the player's rider that belong to scenery [row].
  void paintAt(
    Canvas canvas,
    int row,
    VisionSeg? Function(int row) visionAt,
    Vector2 size,
  ) {
    for (final i in _order) {
      if (_isBehind[i] || _paintRow[i] != row) continue;
      final vision = visionAt(_row[i]);
      if (vision == null || !_place(i, vision, size)) continue;
      _draw(canvas, i, size.x);
    }
  }

  /// Paints the actors that are closer to the camera than the player's rider.
  void paintBehind(Canvas canvas) {
    for (final i in _order) {
      if (_isBehind[i] && _placed[i]) _draw(canvas, i, _screenWidth);
    }
  }

  /// Finds the screen position and size of an actor; false when too small.
  bool _place(int i, VisionSeg vision, Vector2 size) {
    final playerLane = DashboardLayout.lanePx(size, lanes);
    final playerHeight = RiderRig.heightFor(playerLane, size.y);
    final blend = _blend[i];
    final laneWidth = vision.w1 + (vision.w2 - vision.w1) * blend;
    final lanePx = 2 * laneWidth / lanes;
    final height = playerHeight * math.min(lanePx / playerLane, 1.6);
    if (height < 3) return false;
    final laneX = vision.x1 + (vision.x2 - vision.x1) * blend;
    _x[i] = laneX + laneWidth * actors[i].lateral;
    _y[i] = vision.y1 + (vision.y2 - vision.y1) * blend;
    _height[i] = height;
    _clip[i] = vision.clip;
    return true;
  }

  /// Paints one actor, clipped to the visible road.
  void _draw(Canvas canvas, int i, double screenWidth) {
    canvas
      ..save()
      ..clipRect(Rect.fromLTRB(0, 0, screenWidth, math.max(_clip[i], _y[i] + 1)));
    actors[i].paint(canvas, Offset(_x[i], _y[i]), _height[i]);
    canvas.restore();
  }
}
