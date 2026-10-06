// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../hud/dash_layout.dart';
import '../road/road_renderer.dart';
import 'rider_painter.dart';
import 'rider_pose.dart';

/// Animates the rider: leans into turns, squats under braking, shakes
/// off-road, and swings a leg out to the road once the bike has stopped.
class RiderComponent extends PositionComponent {
  RiderComponent(this.road)
      : super(anchor: Anchor.bottomCenter, priority: 1);

  final RoadRenderer road;
  final RiderPainter _painter = RiderPainter();
  final RiderPose _pose = RiderPose();
  double _t = 0;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final lane = DashLayout.lanePx(size, road.theme.lanes);
    final w = math.min(lane * 0.55, size.y * 0.30 * RiderPainter.width / RiderPainter.height);
    this.size = Vector2(w, w * RiderPainter.height / RiderPainter.width);
    position = Vector2(size.x / 2, DashLayout.groundY(size));
  }

  @override
  void update(double dt) {
    _t += dt;
    final sp = road.speedPercent;
    final p = _pose;
    p.phase = (p.phase + road.speed * dt * 0.01) % 52;
    p.foot += ((road.restingOnFoot ? 1.0 : 0.0) - p.foot) * math.min(1.0, dt * 5);
    final target = road.steer * 0.32 - 0.1 * p.foot;
    p.lean += (target - p.lean) * math.min(1.0, dt * 8);
    p.shake = road.offRoad ? math.sin(_t * 60) * 2.5 * sp : 0;
    p.bob = math.sin(_t * 14) * 1.2 * sp + (road.brake && sp > 0.2 ? 2.5 : 0);
    p.braking = road.brake;
  }

  @override
  void render(Canvas canvas) {
    canvas.scale(size.y / RiderPainter.height);
    _painter.paint(canvas, _pose);
  }
}
