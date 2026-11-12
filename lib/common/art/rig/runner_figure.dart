// Dart imports:
import 'dart:ui';

// Project imports:
import '../sheet/art_ink.dart';
import '../sheet/part_motion.dart';
import '../sheet/rider_sheets.dart';
import '../look/rider_look.dart';
import 'rider_leg.dart';
import 'runner_pose.dart';

/// The rider on foot, side on, with every limb driven by joint angles.
class RunnerFigure {
  RunnerFigure(RiderLook look)
    : _run = InkedSheet.rider(RiderSheets.running, look),
      _stand = InkedSheet.rider(RiderSheets.standing, look) {
    _runningLegs = {
      for (final side in _runningSides) side: RiderLeg(_run, 'leg$side'),
    };
    _standingLeg = RiderLeg(_stand, 'leg');
  }

  static const List<String> _runningSides = ['Near', 'Far'];

  final InkedSheet _run;
  final InkedSheet _stand;
  late final Map<String, RiderLeg> _runningLegs;
  late final RiderLeg _standingLeg;

  /// Paints the running art facing right with the given joint angles.
  void paintPose(Canvas canvas, RunnerPose pose) {
    canvas
      ..save()
      ..translate(0, pose.bounce);
    _boot(canvas, 'Near', pose.near);
    _paintLeg(canvas, 'Far', pose.far);
    _arm(canvas, 'Far', pose.armFar);
    _upper(canvas, pose.lean, _run.part('helmet'));
    _boot(canvas, 'Far', pose.far);
    _paintLeg(canvas, 'Near', pose.near);
    _arm(canvas, 'Near', pose.armNear);
    _upper(canvas, pose.lean, _run.part('torso'));
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
    _standingLeg.paint(canvas);
    _stand.part('boot').paint(canvas);
  }

  /// Paints the helmet or torso turned around the waist.
  void _upper(Canvas canvas, double lean, InkedPart part) {
    PartMotion.around(
      canvas,
      _run.anchor('torso.waist'),
      () => part.paint(canvas),
      angle: lean,
    );
  }

  /// Paints one running arm around its shoulder.
  void _arm(Canvas canvas, String side, double angle) {
    PartMotion.around(
      canvas,
      _run.anchor('arm$side.shoulder'),
      () => _run.part('arm$side').paint(canvas),
      angle: angle,
    );
  }

  /// Paints a complete running leg using its hip and knee angles.
  void _paintLeg(Canvas canvas, String side, LegJoints joints) {
    _runningLegs[side]!.paint(
      canvas,
      hipAngle: _hipTurn(side, joints),
      kneeAngle: _kneeTurn(side, joints),
    );
  }

  /// Paints a boot following its leg, knee, and ankle joints.
  void _boot(Canvas canvas, String side, LegJoints joints) {
    final leg = _runningLegs[side]!;
    final heel = _run.anchor('boot$side.heel');
    final kneeTurn = _kneeTurn(side, joints);
    PartMotion.around(canvas, leg.hip, () {
      PartMotion.around(canvas, leg.knee, () {
        PartMotion.around(
          canvas,
          heel,
          () => _run.part('boot$side').paint(canvas),
          angle: joints.foot,
        );
      }, angle: kneeTurn);
    }, angle: _hipTurn(side, joints));
  }

  /// Rotation from the artwork's resting hip angle to this pose.
  double _hipTurn(String side, LegJoints joints) {
    final leg = _runningLegs[side]!;
    final rest = PartMotion.fromDown(leg.hip, leg.knee);
    return rest - joints.thigh;
  }

  /// Rotation from the artwork's resting knee angle to this pose.
  double _kneeTurn(String side, LegJoints joints) {
    final leg = _runningLegs[side]!;
    final rest =
        PartMotion.fromDown(leg.hip, leg.knee) -
        PartMotion.fromDown(leg.knee, leg.ankle);
    return joints.flex - rest;
  }
}
