// Dart imports:
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';
import '../art/sheet/part_motion.dart';
import '../art/sheet/rider_sheets.dart';
import '../look/rider_look.dart';
import '../rider_pose.dart';
import 'seated_upper.dart';
import 'yaw_curves.dart';

/// The rider seated on the bike, built from separate body parts.
class SeatedRiderFigure {
  SeatedRiderFigure(RiderLook look)
    : _rear = InkedSheet.rider(RiderSheets.rear, look),
      _side = InkedSheet.rider(RiderSheets.sideways, look) {
    _upper = SeatedUpper(_rear, _side);
  }

  static const double raise = 24;
  static const double stanceReach = 16;
  static const double midX = 60;

  final InkedSheet _rear;
  final InkedSheet _side;
  late final SeatedUpper _upper;

  /// Paints the rider for the pose: yaw, steering, tuck and foot down.
  void paint(Canvas canvas, RiderPose pose) {
    final sideFade = YawCurves.sideFade(pose.perspective);
    final mirrored = pose.perspective < 0;
    canvas
      ..save()
      ..translate(0, -raise);
    if (mirrored) PartMotion.mirror(canvas, midX);
    _upper.helmet(canvas, pose);
    for (final side in const ['L', 'R']) {
      final reach = pose.foot * (stanceReach + raise);
      final down = (side == 'L') == !mirrored ? reach : 0.0;
      _paintLeg(canvas, side, down, side == 'L' ? sideFade * pose.foot : 0);
    }
    final behind = YawCurves.farArmBehind(pose.perspective);
    if (behind) _upper.farArm(canvas, pose);
    _upper.torso(canvas, pose.perspective);
    if (!behind) _upper.farArm(canvas, pose);
    _upper.nearArm(canvas, pose);
    canvas.restore();
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
}
