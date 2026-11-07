// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../hud/dashboard/dashboard_layout.dart';
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import 'dust_trail.dart';
import 'look/rider_look.dart';
import 'rider_painter.dart';
import 'rider_pose.dart';
import 'rider_rig.dart';
import 'rider_sprite.dart';

/// Flame component that draws the player's bike and rider.
class RiderComponent extends PositionComponent {
  RiderComponent(this.road, {RiderRig? rig, this.look = RiderLook.main})
      : rig = rig ?? RiderRig(),
        super(
          anchor: Anchor(0.5, RiderPartPainter.groundY / RiderPainter.height),
          priority: 1,
        );

  final RoadRenderer road;
  final RiderRig rig;
  final RiderLook look;
  late final RiderSprite _sprite = RiderSprite(look: look, rig: rig);
  /// Returns the rider's current pose.
  RiderPose get _pose => _sprite.pose;
  final DustTrail _dust = DustTrail();
  double _t = 0;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final lane = DashboardLayout.lanePx(size, road.theme.lanes);
    final height = RiderRig.heightFor(lane, size.y);
    this.size = Vector2(height * RiderPainter.width / RiderPainter.height, height);
    position = Vector2(size.x / 2, DashboardLayout.riderTyresGround(size));
  }

  @override
  void update(double dt) {
    scale.setAll(rig.scale);
    _t += dt;
    final pose = _pose;
    final sp = road.speedPercent;
    final ease = math.min(1.0, dt * 8);

    pose.speed = sp;
    pose.steer += (road.appliedSteer - pose.steer) * ease;
    pose.braking = road.brake;

    final spin = math.min(road.speed, VehicleConfig.maxSpeed * 0.2);
    pose.phase = (pose.phase + spin * dt / 900) % 1;

    _dust.update(dt, emitting: road.kickingDust, strength: sp);
    pose.tumble = road.crash.tilt;
    pose.foot += ((road.restingOnFoot ? 1.0 : 0.0) - pose.foot) * math.min(1.0, dt * 5);

    final bank = (road.appliedSteer * 0.30 + road.curveFelt * 0.040) *
            (0.3 + 0.7 * sp) -
        0.12 * pose.foot;
    final target =
        bank.clamp(-RiderPainter.maxLean, RiderPainter.maxLean).toDouble();
    pose.lean += (target - pose.lean) * math.min(1.0, dt * 6);

    final pitch = road.brake ? -1.0 : (road.throttle ? 0.5 : 0.0);
    pose.pitch += (pitch * sp - pose.pitch) * math.min(1.0, dt * 6);

    final rough = road.offRoad || road.ride.current.rough ? sp : 0.0;
    pose.shake = rough == 0 ? 0 : math.sin(_t * 57) * 2.6 * rough;
    pose.bob = math.sin(_t * 13) * 1.1 * sp +
        math.sin(_t * 41) * 2.2 * rough +
        math.max(0.0, -pose.pitch) * 2.5;
  }

  @override
  void render(Canvas canvas) {
    canvas.scale(size.y / RiderPainter.height);
    if (road.recovering) {
      final x = RiderPartPainter.midX + road.crash.runX * 65;
      final stride = math.sin(_t * 12) * 8;
      final ink = Paint()..color = look.suit;
      final helmet = Paint()..color = look.helmet;
      final metal = Paint()..color = look.bike.panel;
      final rubber = Paint()..color = const Color(0xFF202027);
      // The bike stays at the crash point while the rider runs back to it.
      canvas
        ..drawCircle(Offset(RiderPartPainter.midX - 35, RiderPartPainter.groundY - 5), 9, rubber)
        ..drawCircle(Offset(RiderPartPainter.midX + 35, RiderPartPainter.groundY - 5), 9, rubber)
        ..drawLine(Offset(RiderPartPainter.midX - 28, RiderPartPainter.groundY - 10), Offset(RiderPartPainter.midX + 25, RiderPartPainter.groundY - 15), metal..strokeWidth = 8)
        ..drawCircle(Offset(RiderPartPainter.midX, RiderPartPainter.groundY - 18), 11, metal);
      canvas.drawCircle(Offset(x, RiderPartPainter.groundY - 58), 9, helmet);
      canvas.drawLine(Offset(x, RiderPartPainter.groundY - 48),
          Offset(x - 2, RiderPartPainter.groundY - 27), ink..strokeWidth = 8);
      canvas.drawLine(Offset(x - 2, RiderPartPainter.groundY - 27),
          Offset(x - 10 + stride, RiderPartPainter.groundY - 4), ink..strokeWidth = 6);
      canvas.drawLine(Offset(x - 2, RiderPartPainter.groundY - 27),
          Offset(x + 10 - stride, RiderPartPainter.groundY - 4), ink..strokeWidth = 6);
      canvas.drawLine(Offset(x - 1, RiderPartPainter.groundY - 42),
          Offset(x - 17, RiderPartPainter.groundY - 28), ink..strokeWidth = 5);
      canvas.drawLine(Offset(x - 1, RiderPartPainter.groundY - 42),
          Offset(x + 15, RiderPartPainter.groundY - 32), ink..strokeWidth = 5);
      return;
    }
    _sprite.painter.paint(canvas, _pose);
    _dust.paint(
      canvas,
      const Offset(RiderPartPainter.midX, RiderPartPainter.groundY),
      RiderPainter.height,
      road.ride.current.dustTone,
    );
  }
}
