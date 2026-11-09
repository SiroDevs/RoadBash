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
import 'recovery_painter.dart';
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
  late final RiderSprite _sprite = RiderSprite(
    look: look,
    rig: rig,
    useSuppliedArt: true,
  );
  late final RecoveryPainter _recoveryPainter = RecoveryPainter(look);

  /// Returns the rider's current pose.
  RiderPose get _pose => _sprite.pose;
  final DustTrail _dust = DustTrail();
  double _t = 0;
  double _recoveryLateralScale = 0;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final lane = DashboardLayout.lanePx(size, road.theme.lanes);
    final height = RiderRig.heightFor(lane, size.y);
    _recoveryLateralScale =
        lane * road.theme.lanes / 4 / (height / RiderPainter.height);
    this.size = Vector2(
      height * RiderPainter.width / RiderPainter.height,
      height,
    );
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
    pose.foot +=
        ((road.stopped && !road.crashed && !road.recovering ? 1.0 : 0.0) -
            pose.foot) *
        math.min(1.0, dt * 5);

    final bank =
        (road.appliedSteer * 0.30 + road.curveFelt * 0.040) * (0.3 + 0.7 * sp) -
        0.12 * pose.foot;
    final target = bank
        .clamp(-RiderPainter.maxLean, RiderPainter.maxLean)
        .toDouble();
    pose.lean += (target - pose.lean) * math.min(1.0, dt * 6);

    final sharpTurn =
        road.appliedSteer.abs() > 0.4 && sp > 0.8 && road.curveFelt.abs() > 2.5;
    final turnDirection = road.appliedSteer.sign;
    final perspective = sharpTurn ? turnDirection * (0.18 + sp * 0.27) : 0.0;
    pose.perspective +=
        (perspective - pose.perspective) * math.min(1.0, dt * 4);

    final pitch = road.brake ? -1.0 : (road.throttle ? 0.5 : 0.0);
    pose.pitch += (pitch * sp - pose.pitch) * math.min(1.0, dt * 6);

    final rough = road.offRoad || road.ride.current.rough ? sp : 0.0;
    pose.shake = rough == 0 ? 0 : math.sin(_t * 57) * 2.6 * rough;
    pose.bob =
        math.sin(_t * 13) * 1.1 * sp +
        math.sin(_t * 41) * 2.2 * rough +
        math.max(0.0, -pose.pitch) * 2.5;
  }

  @override
  void render(Canvas canvas) {
    canvas.scale(size.y / RiderPainter.height);
    if (road.crashed || road.recovering) {
      _recoveryPainter.paint(
        canvas,
        running: road.crash.running,
        standing: road.crash.standing,
        mounting: road.crash.mounting,
        returning: road.crash.returning,
        time: _t,
        fallSide: road.crash.side,
        standProgress: road.crash.standProgress,
        mountProgress: road.crash.mountProgress,
        returnProgress: road.crash.returnProgress,
        fallProgress: road.crash.fallProgress,
        runLateral: road.crash.runX,
        bikeLateral: road.crash.bikeX,
        crashLateral: road.crash.crashX,
        currentLateral: road.playerX,
        lateralScale: _recoveryLateralScale,
      );
      return;
    }
    _sprite.paint(canvas);
    _dust.paint(
      canvas,
      const Offset(RiderPartPainter.midX, RiderPartPainter.groundY),
      RiderPainter.height,
      road.ride.current.dustTone,
    );
  }
}
