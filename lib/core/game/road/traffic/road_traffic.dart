import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../../hud/dashboard_layout.dart';
import '../../rider/rider_rig.dart';
import '../config/road_config.dart';
import '../road_projection.dart';
import 'road_actor.dart';

class RoadTraffic {
  RoadTraffic(this.actors, this.lanes)
      : _n = List.filled(actors.length, -1),
        _t = List.filled(actors.length, 0);

  final List<RoadActor> actors;
  final int lanes;
  final List<int> _n;
  final List<double> _t;

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
      final z = (trkPosition + playerZ + dz) / len;
      _n[i] = z.floor() - base;
      _t[i] = z - z.floor();
    }
  }

  void paintAt(Canvas canvas, int n, VisionSeg v, Vector2 size) {
    final playerLane = DashboardLayout.lanePx(size, lanes);
    final playerH = RiderRig.heightFor(playerLane, size.y);
    for (var i = 0; i < actors.length; i++) {
      if (_n[i] != n) continue;
      final t = _t[i];
      final x = v.x1 + (v.x2 - v.x1) * t;
      final y = v.y1 + (v.y2 - v.y1) * t;
      final w = v.w1 + (v.w2 - v.w1) * t;
      final a = actors[i];
      final lanePx = 2 * w / lanes;
      final h = playerH * math.min(lanePx / playerLane, 1.6);
      if (h < 3) continue;
      canvas.save();
      canvas.clipRect(Rect.fromLTRB(0, 0, size.x, math.max(v.clip, y + 1)));
      a.paint(canvas, Offset(x + w * a.lateral, y), h);
      canvas.restore();
    }
  }
}