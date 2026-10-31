// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../hud/dashboard_layout.dart';
import '../../rider/rider_rig.dart';
import '../config/road_config.dart';
import '../road_projection.dart';
import 'road_actor.dart';

/// Places the other bikes on the road and paints them in depth order.
class RoadTraffic {
  RoadTraffic(this.actors, this.lanes)
      : _n = List.filled(actors.length, -1),
        _t = List.filled(actors.length, 0);

  final List<RoadActor> actors;
  final int lanes;
  final List<int> _n;
  final List<double> _t;

  /// Works out which scenery row every visible actor stands on this frame.
  void prepare(double trkPosition, double fullDistance, double playerZ) {
    const len = RoadConfig.segmentLength;
    final reach = RoadConfig.decorDistance * len;
    final base = (trkPosition / len).floor();
    for (var i = 0; i < actors.length; i++) {
      final dz = actors[i].distance - fullDistance;
      if (dz < -playerZ * 0.65 || dz > reach) {
        _n[i] = -1;
        continue;
      }
      final trackRow = (trkPosition + playerZ + dz) / len;
      _n[i] = trackRow.floor() - base;
      _t[i] = trackRow - trackRow.floor();
    }
  }

  /// Paints the actors standing on scenery row [index].
  void paintAt(Canvas canvas, int index, VisionSeg vision, Vector2 size) {
    final playerLane = DashboardLayout.lanePx(size, lanes);
    final playerH = RiderRig.heightFor(playerLane, size.y);
    for (var i = 0; i < actors.length; i++) {
      if (_n[i] != index) continue;
      final blend = _t[i];
      final laneX = vision.x1 + (vision.x2 - vision.x1) * blend;
      final laneY = vision.y1 + (vision.y2 - vision.y1) * blend;
      final laneWidth = vision.w1 + (vision.w2 - vision.w1) * blend;
      final actor = actors[i];
      final lanePx = 2 * laneWidth / lanes;
      final bikeHeight = playerH * math.min(lanePx / playerLane, 1.6);
      if (bikeHeight < 3) continue;
      canvas.save();
      canvas.clipRect(Rect.fromLTRB(0, 0, size.x, math.max(vision.clip, laneY + 1)));
      actor.paint(canvas, Offset(laneX + laneWidth * actor.lateral, laneY), bikeHeight);
      canvas.restore();
    }
  }
}
