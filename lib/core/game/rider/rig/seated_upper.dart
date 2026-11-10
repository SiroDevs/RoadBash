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

  /// Size of the side-view art next to the rider drawn on the bike.
  late final double _helmetFit =
      _sizeOf(_rear.part('helmet')) / _sizeOf(_side.part('helmet'));
  late final double _armFit =
      _sizeOf(_rear.part('armR')) / _sizeOf(_side.part('arm'));

  /// Paints the helmet leaning into the turn, crossfading to the side art.
  void helmet(Canvas canvas, RiderPose pose) {
    final turn = YawCurves.helmet(pose.perspective);
    final fade = YawCurves.sideFade(pose.perspective);
    final tuck = pose.speed * 2.2 - pose.pitch * 1.2;
    final squash = 1 - 0.22 * math.sin(math.pi * fade);
    final neck = _rear.anchor('helmet.neck');
    void draw(InkedSheet sheet, double alpha, double fit) {
      if (alpha <= 0.01) return;
      final pivot = sheet.anchor('helmet.neck');
      PartMotion.around(
        canvas,
        pivot,
        () => sheet.part('helmet').paint(canvas, alpha: alpha),
        angle: 0.1 * turn * (1 - fade),
        scaleX: squash * fit,
        scaleY: fit,
        shift: neck - pivot + Offset(2 * turn, tuck),
      );
    }

    draw(_rear, 1 - fade, 1);
    draw(_side, fade, _helmetFit);
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

  /// Paints both arms behind the torso, the far one tucked toward it.
  void arms(Canvas canvas, RiderPose pose) {
    final turn = YawCurves.torso(pose.perspective);
    final fade = YawCurves.sideFade(pose.perspective);
    final sway = pose.steer * 0.06;
    PartMotion.around(
      canvas,
      _rear.anchor('armL.shoulder'),
      () => _rear.part('armL').paint(canvas),
      angle: sway,
      scaleX: 1 - 0.15 * turn,
      shift: Offset(3 * turn, 0),
    );
    PartMotion.around(
      canvas,
      _rear.anchor('armR.shoulder'),
      () => _rear.part('armR').paint(canvas, alpha: 1 - fade),
      angle: sway - 0.08 * turn,
    );
  }

  /// Paints the side-view arm over the torso once the rider is turned enough.
  void sideArm(Canvas canvas, RiderPose pose) {
    final fade = YawCurves.sideFade(pose.perspective);
    if (fade <= 0.01) return;
    final shoulder = _side.anchor('arm.shoulder');
    PartMotion.around(
      canvas,
      shoulder,
      () => _side.part('arm').paint(canvas, alpha: fade),
      angle: pose.steer * 0.06,
      scaleX: _armFit,
      scaleY: _armFit,
      shift: _rear.anchor('armR.shoulder') - shoulder,
    );
  }

  /// Diagonal of the box around a part.
  static double _sizeOf(InkedPart part) {
    var left = double.infinity, top = double.infinity;
    var right = -double.infinity, bottom = -double.infinity;
    for (final shape in part.part.shapes) {
      for (final point in shape.points) {
        left = math.min(left, point.dx);
        right = math.max(right, point.dx);
        top = math.min(top, point.dy);
        bottom = math.max(bottom, point.dy);
      }
    }
    return Offset(right - left, bottom - top).distance;
  }
}
