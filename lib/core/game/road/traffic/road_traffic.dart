// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../hud/dashboard_layout.dart';
import '../../rider/rider_rig.dart';
import '../config/road_config.dart';
import '../road_projection.dart';
import 'road_actor.dart';
import 'road_view.dart';

/// Where one actor is drawn this frame.
class ActorSpot {
  ActorSpot(this.actor);

  final RoadActor actor;
  double x = 0;
  double y = 0;
  double height = 0;
  double depth = 0;
  double clipY = 0;
  double alpha = 1;
  double yaw = 0;
  int row = 0;
}

/// Places the other bikes on the road and paints them in depth order.
class RoadTraffic {
  RoadTraffic(this.actors, this.lanes)
    : _spots = [for (final actor in actors) ActorSpot(actor)];

  static const double _maxScale = 1.6;
  static const double _farFade = 0.2;

  final List<RoadActor> actors;
  final int lanes;
  final List<ActorSpot> _spots;
  final List<ActorSpot> _ahead = [];
  final List<ActorSpot> _behind = [];
  final ProjectionPoint _point = ProjectionPoint();
  double _screenWidth = 0;
  final Paint _fade = Paint();

  /// Works out where every visible actor is on screen this frame.
  void prepare(RoadView view, double fullDistance, double playerZ) {
    _ahead.clear();
    _behind.clear();
    _screenWidth = view.size.x;
    final playerLane = DashboardLayout.lanePx(view.size, lanes);
    final playerHeight = RiderRig.heightFor(playerLane, view.size.y);
    final reach = RoadConfig.decorDistance * RoadConfig.segmentLength;
    final goneDepth = math.max(RoadConfig.nearClip * 1.05, playerZ * 0.3);
    final fullDepth = math.max(goneDepth + playerZ * 0.15, playerZ * 0.55);

    for (final spot in _spots) {
      final actor = spot.actor;
      final depth = playerZ + actor.distance - fullDistance;
      if (depth < goneDepth || depth > reach) continue;
      if (!view.project(depth, _point)) continue;

      final lanePx = 2 * _point.w / lanes;
      final height = playerHeight * math.min(lanePx / playerLane, _maxScale);
      if (height < 3) continue;

      final near = ((depth - goneDepth) / (fullDepth - goneDepth)).clamp(0, 1);
      final far = ((reach - depth) / (reach * _farFade)).clamp(0, 1);
      spot
        ..x = _point.x + _point.w * actor.lateral
        ..y = _point.y
        ..height = height
        ..depth = depth
        ..clipY = view.lastClipY
        ..row = view.paintRow(view.lastRow)
        ..alpha = math.min(near.toDouble(), far.toDouble())
        ..yaw = math.atan2(
          actor.lateral * RoadConfig.roadWidth - view.lastCameraX,
          depth,
        );
      (depth >= playerZ ? _ahead : _behind).add(spot);
    }
    _ahead.sort((first, second) => second.depth.compareTo(first.depth));
    _behind.sort((first, second) => second.depth.compareTo(first.depth));
  }

  /// Paints the actors beyond the player's rider that belong to scenery [row].
  void paintAhead(Canvas canvas, int row) {
    for (final spot in _ahead) {
      if (spot.row == row) _paintSpot(canvas, spot);
    }
  }

  /// Paints the actors that are closer to the camera than the player's rider.
  void paintBehind(Canvas canvas) {
    for (final spot in _behind) {
      _paintSpot(canvas, spot);
    }
  }

  /// Paints one actor, clipped to the visible road and faded where needed.
  void _paintSpot(Canvas canvas, ActorSpot spot) {
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(0, 0, _screenWidth, math.max(spot.clipY, spot.y + 1)),
    );
    final faded = spot.alpha < 1;
    if (faded) {
      _fade.color = Color.fromRGBO(0, 0, 0, spot.alpha);
      canvas.saveLayer(null, _fade);
    }
    spot.actor.paint(canvas, Offset(spot.x, spot.y), spot.height, spot.yaw);
    if (faded) canvas.restore();
    canvas.restore();
  }
}
