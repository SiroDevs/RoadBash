// Dart imports:
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';
import '../art/sheet/part_motion.dart';
import '../art/sheet/rider_sheets.dart';
import '../look/rider_look.dart';
import 'runner_pose.dart';

/// The rider on foot, side on, with every limb driven by joint angles.
class RunnerFigure {
  RunnerFigure(RiderLook look)
    : _run = InkedSheet.rider(RiderSheets.running, look),
      _stand = InkedSheet.rider(RiderSheets.standing, look);

  final InkedSheet _run;
  final InkedSheet _stand;

  /// Paints the running art facing right with the given joint angles.
  void paintPose(Canvas canvas, RunnerPose pose) {
    canvas
      ..save()
      ..translate(0, pose.bounce);
    _boot(canvas, 'Near', pose.near);
    _legWithBoot(canvas, 'Far', pose.far, bootToo: false);
    _arm(canvas, 'Far', pose.armFar);
    _upper(canvas, 'helmet', 'helmet.neck', pose.lean, _run.part('helmet'));
    _boot(canvas, 'Far', pose.far);
    _legWithBoot(canvas, 'Near', pose.near, bootToo: false);
    _arm(canvas, 'Near', pose.armNear);
    _upper(canvas, 'torso', 'torso.waist', pose.lean, _run.part('torso'));
    canvas.restore();
  }

  /// Paints the side standing art with a slight breathing sway.
  void paintStanding(Canvas canvas, double breath) {
    final waist = _stand.anchor('torso.waist');
    _stand.part('helmet').paint(canvas);
    PartMotion.around(
      canvas,
      waist,
      () => _stand.part('torso').paint(canvas),
      scaleY: 1 + breath * 0.006,
    );
    PartMotion.around(
      canvas,
      _stand.anchor('arm.shoulder'),
      () => _stand.part('arm').paint(canvas),
      angle: breath * 0.03,
    );
    _stand.part('legThigh').paint(canvas);
    _stand.part('legShin').paint(canvas);
    _stand.part('boot').paint(canvas);
  }

  void _upper(
    Canvas canvas,
    String id,
    String pivot,
    double lean,
    InkedPart part,
  ) {
    PartMotion.around(
      canvas,
      _run.anchor('torso.waist'),
      () => part.paint(canvas),
      angle: lean,
    );
  }

  void _arm(Canvas canvas, String side, double angle) {
    PartMotion.around(
      canvas,
      _run.anchor('arm$side.shoulder'),
      () => _run.part('arm$side').paint(canvas),
      angle: angle,
    );
  }

  void _legWithBoot(
    Canvas canvas,
    String side,
    LegJoints joints, {
    required bool bootToo,
  }) {
    final hip = _run.anchor('leg$side.hip');
    final knee = _run.anchor('leg$side.knee');
    final hipTurn = _hipTurn(side, joints);
    PartMotion.around(canvas, hip, () {
      _run.part('leg${side}Thigh').paint(canvas);
      PartMotion.around(
        canvas,
        knee,
        () => _run.part('leg${side}Shin').paint(canvas),
        angle: _kneeTurn(side, joints),
      );
    }, angle: hipTurn);
  }

  void _boot(Canvas canvas, String side, LegJoints joints) {
    final hip = _run.anchor('leg$side.hip');
    final knee = _run.anchor('leg$side.knee');
    final heel = _run.anchor('boot$side.heel');
    final kneeTurn = _kneeTurn(side, joints);
    PartMotion.around(canvas, hip, () {
      PartMotion.around(canvas, knee, () {
        PartMotion.around(
          canvas,
          heel,
          () => _run.part('boot$side').paint(canvas),
          angle: joints.foot,
        );
      }, angle: kneeTurn);
    }, angle: _hipTurn(side, joints));
  }

  double _hipTurn(String side, LegJoints joints) {
    final rest = PartMotion.fromDown(
      _run.anchor('leg$side.hip'),
      _run.anchor('leg$side.knee'),
    );
    return rest - joints.thigh;
  }

  double _kneeTurn(String side, LegJoints joints) {
    final rest =
        PartMotion.fromDown(
          _run.anchor('leg$side.hip'),
          _run.anchor('leg$side.knee'),
        ) -
        PartMotion.fromDown(
          _run.anchor('leg$side.knee'),
          _run.anchor('leg$side.ankle'),
        );
    return joints.flex - rest;
  }
}
