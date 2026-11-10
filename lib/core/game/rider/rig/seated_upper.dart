// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';
import '../art/sheet/part_motion.dart';
import '../rider_pose.dart';
import 'yaw_curves.dart';

/// Helmet, torso and arms of the seated rider, turning with yaw.
class SeatedUpper {
  SeatedUpper(this._rear, this._side);

  final InkedSheet _rear;
  final InkedSheet _side;

  /// Paints the helmet leaning into the turn, crossfading to the side art.
  void helmet(Canvas canvas, RiderPose pose) {
    final turn = YawCurves.helmet(pose.perspective);
    final fade = YawCurves.sideFade(pose.perspective);
    final tuck = pose.speed * 2.2 - pose.pitch * 1.2;
    final squash = 1 - 0.22 * math.sin(math.pi * fade);
    void draw(InkedSheet sheet, double alpha) {
      if (alpha <= 0.01) return;
      PartMotion.around(
        canvas,
        sheet.anchor('helmet.neck'),
        () => sheet.part('helmet').paint(canvas, alpha: alpha),
        angle: 0.1 * turn * (1 - fade),
        scaleX: squash,
        shift: Offset(2 * turn, tuck),
      );
    }

    draw(_rear, 1 - fade);
    draw(_side, fade);
  }

  /// Paints the torso, squashed and shifted a little behind the helmet.
  void torso(Canvas canvas, double yaw) {
    final turn = YawCurves.torso(yaw);
    PartMotion.around(
      canvas,
      _rear.anchor('torso.waist'),
      () => _rear.part('torso').paint(canvas),
      angle: 0.04 * turn,
      scaleX: 1 - 0.1 * turn,
      shift: Offset(2 * turn, 0),
    );
  }

  /// Paints the far arm, tucked toward the torso as the rider turns.
  void farArm(Canvas canvas, RiderPose pose) {
    final turn = YawCurves.torso(pose.perspective);
    final pivot = _rear.anchor('armL.shoulder');
    PartMotion.around(
      canvas,
      pivot,
      () => _rear.part('armL').paint(canvas),
      angle: pose.steer * 0.06,
      scaleX: 1 - 0.15 * turn,
      shift: Offset(3 * turn, 0),
    );
  }

  /// Paints the near arm, swinging forward as the rider turns.
  void nearArm(Canvas canvas, RiderPose pose) {
    final turn = YawCurves.torso(pose.perspective);
    final fade = YawCurves.sideFade(pose.perspective);
    final sway = pose.steer * 0.06;
    PartMotion.around(
      canvas,
      _rear.anchor('armR.shoulder'),
      () => _rear.part('armR').paint(canvas, alpha: 1 - fade),
      angle: sway - 0.08 * turn,
    );
    if (fade <= 0.01) return;
    PartMotion.around(
      canvas,
      _side.anchor('arm.shoulder'),
      () => _side.part('arm').paint(canvas, alpha: fade),
      angle: sway,
    );
  }
}
