// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../hud/dash_layout.dart';
import '../road/road_config.dart';
import '../road/road_renderer.dart';
import 'rider_painter.dart';
import 'rider_pose.dart';

class RiderComponent extends PositionComponent {
  RiderComponent(this.road) : super(anchor: Anchor.bottomCenter, priority: 1);

  final RoadRenderer road;
  final RiderPainter _painter = RiderPainter();
  final RiderPose _pose = RiderPose();
  double _t = 0;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final lane = DashLayout.lanePx(size, road.theme.lanes);
    final w = math.min(
      lane * 0.62,
      size.y * 0.30 * RiderPainter.width / RiderPainter.height,
    );
    final h = w * RiderPainter.height / RiderPainter.width;
    this.size = Vector2(w, h);
    // Drop the box so the contact patch, not its bottom edge, sits on the
    // road line the projection puts the bike on.
    position = Vector2(size.x / 2, DashLayout.groundY(size) + h * 0.024);
  }

  @override
  void update(double dt) {
    _t += dt;
    final p = _pose;
    final sp = road.speedPercent;
    final ease = math.min(1.0, dt * 8);

    p.speed = sp;
    p.steer += (road.appliedSteer - p.steer) * ease;
    p.braking = road.brake;

    // Apparent wheel rotation saturates early: past that the tread would
    // alias into a strobe, so it blurs out instead.
    final spin = math.min(road.speed, RoadConfig.maxSpeed * 0.2);
    p.phase = (p.phase + spin * dt / 900) % 1;

    p.foot += ((road.restingOnFoot ? 1.0 : 0.0) - p.foot) * math.min(1.0, dt * 5);

    final bank = (road.appliedSteer * 0.30 + road.curveFelt * 0.040) *
            (0.3 + 0.7 * sp) -
        0.12 * p.foot;
    final target =
        bank.clamp(-RiderPainter.maxLean, RiderPainter.maxLean).toDouble();
    p.lean += (target - p.lean) * math.min(1.0, dt * 6);

    final pitch = road.brake ? -1.0 : (road.throttle ? 0.5 : 0.0);
    p.pitch += (pitch * sp - p.pitch) * math.min(1.0, dt * 6);

    final rough = road.offRoad ? sp : 0.0;
    p.shake = rough == 0 ? 0 : math.sin(_t * 57) * 2.6 * rough;
    p.bob = math.sin(_t * 13) * 1.1 * sp +
        math.sin(_t * 41) * 2.2 * rough +
        math.max(0.0, -p.pitch) * 2.5;
  }

  @override
  void render(Canvas canvas) {
    canvas.scale(size.y / RiderPainter.height);
    _painter.paint(canvas, _pose);
  }
}
