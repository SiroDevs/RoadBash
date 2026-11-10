// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';
import '../art/sheet/part_motion.dart';
import '../art/sheet/rider_sheets.dart';
import '../look/rider_look.dart';
import '../rider_pose.dart';

/// The rider seated on the bike, built from separate body parts.
class SeatedRiderFigure {
  SeatedRiderFigure(RiderLook look)
    : _rear = InkedSheet.rider(RiderSheets.rear, look),
      _side = InkedSheet.rider(RiderSheets.sideways, look);

  static const double footReach = 16;
  static const double midX = 60;

  final InkedSheet _rear;
  final InkedSheet _side;

  /// Paints the rider for the pose: yaw, steering, tuck and foot down.
  void paint(Canvas canvas, RiderPose pose) {
    final turn = (pose.perspective.abs() / 0.7).clamp(0.0, 1.0).toDouble();
    final sideFade = PartMotion.smooth(0.25, 0.6, turn);
    final mirrored = pose.perspective < 0;
    canvas.save();
    if (mirrored) PartMotion.mirror(canvas, midX);
    _paintHelmet(canvas, pose, turn, sideFade);
    for (final side in const ['L', 'R']) {
      final reach = pose.foot * footReach;
      final down = (side == 'L') == !mirrored ? reach : 0.0;
      _paintLeg(canvas, side, down, side == 'L' ? sideFade * pose.foot : 0);
    }
    _paintTorso(canvas, turn);
    _paintArms(canvas, pose, sideFade);
    canvas.restore();
  }

  void _paintHelmet(Canvas canvas, RiderPose pose, double turn, double fade) {
    final tuck = pose.speed * 2.2 - pose.pitch * 1.2;
    final squash = 1 - 0.22 * math.sin(math.pi * fade);
    void draw(InkedSheet sheet, double alpha) {
      if (alpha <= 0.01) return;
      PartMotion.around(
        canvas,
        sheet.anchor('helmet.neck'),
        () => sheet.part('helmet').paint(canvas, alpha: alpha),
        scaleX: squash,
        shift: Offset(2 * turn, tuck),
      );
    }

    draw(_rear, 1 - fade);
    draw(_side, fade);
  }

  void _paintLeg(Canvas canvas, String side, double down, double fade) {
    final boot = _rear.part('boot$side');
    final thigh = _rear.part('leg${side}Thigh');
    final shin = _rear.part('leg${side}Shin');
    final knee = _rear.anchor('leg$side.knee');
    final rearAlpha = 1 - fade;
    if (rearAlpha > 0.01) {
      PartMotion.around(
        canvas,
        Offset.zero,
        () => boot.paint(canvas, alpha: rearAlpha),
        shift: Offset(0, down),
      );
      thigh.paint(canvas, alpha: rearAlpha);
      if (down > 0.01 && fade == 0) {
        PartMotion.stretched(canvas, shin, knee, down);
      } else {
        shin.paint(canvas, alpha: rearAlpha);
      }
    }
    if (fade > 0.01) _paintSideLeg(canvas, down, fade);
  }

  void _paintSideLeg(Canvas canvas, double down, double fade) {
    final leg = _side.part('leg');
    final boot = _side.part('boot');
    PartMotion.around(
      canvas,
      Offset.zero,
      () => boot.paint(canvas, alpha: fade),
      shift: Offset(0, down),
    );
    if (down > 0.01 && fade > 0.99) {
      PartMotion.stretched(canvas, leg, const Offset(0, 108), down, span: 14);
    } else {
      leg.paint(canvas, alpha: fade);
    }
  }

  void _paintTorso(Canvas canvas, double turn) {
    PartMotion.around(
      canvas,
      _rear.anchor('torso.waist'),
      () => _rear.part('torso').paint(canvas),
      scaleX: 1 - 0.1 * turn,
      shift: Offset(2 * turn, 0),
    );
  }

  void _paintArms(Canvas canvas, RiderPose pose, double fade) {
    final sway = pose.steer * 0.06;
    for (final side in const ['R', 'L']) {
      final part = _rear.part('arm$side');
      final alpha = side == 'R' ? 1 - fade : 1.0;
      PartMotion.around(
        canvas,
        _rear.anchor('arm$side.shoulder'),
        () => part.paint(canvas, alpha: alpha),
        angle: sway,
      );
    }
    if (fade <= 0.01) return;
    PartMotion.around(
      canvas,
      _side.anchor('arm.shoulder'),
      () => _side.part('arm').paint(canvas, alpha: fade),
      angle: sway,
    );
  }
}
