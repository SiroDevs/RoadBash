import 'dart:math' as math;
import 'dart:ui';

import 'user_art_color.dart';
import 'look/rider_look.dart';
import 'rider_pose.dart';
import 'user_assets/rider/layers/back_facing/groups/helmet2.dart'
    as rear_helmet;
import 'user_assets/rider/layers/back_facing/groups/left_hand.dart'
    as rear_left_arm;
import 'user_assets/rider/layers/back_facing/groups/legs.dart' as rear_legs;
import 'user_assets/rider/layers/back_facing/groups/right_boot.dart'
    as rear_left_boot;
import 'user_assets/rider/layers/back_facing/groups/right_boot2.dart'
    as rear_right_boot;
import 'user_assets/rider/layers/back_facing/groups/right_hand.dart'
    as rear_right_arm;
import 'user_assets/rider/layers/back_facing/groups/torso.dart' as rear_torso;
import 'user_assets/rider/layers/side_ways/groups/arm.dart' as side_arm;
import 'user_assets/rider/layers/side_ways/groups/helmet.dart' as side_helmet;
import 'user_assets/rider/layers/side_ways/groups/leg.dart' as side_leg;
import 'user_assets/rider/layers/side_running/groups/helmet5.dart'
    as run_helmet;
import 'user_assets/rider/layers/side_running/groups/left_boot2.dart'
    as run_left_boot;
import 'user_assets/rider/layers/side_running/groups/left_hand3.dart'
    as run_left_arm;
import 'user_assets/rider/layers/side_running/groups/left_leg2.dart'
    as run_left_leg;
import 'user_assets/rider/layers/side_running/groups/right_boot5.dart'
    as run_right_boot;
import 'user_assets/rider/layers/side_running/groups/right_hand4.dart'
    as run_right_arm;
import 'user_assets/rider/layers/side_running/groups/right_leg3.dart'
    as run_right_leg;
import 'user_assets/rider/layers/side_running/groups/torso4.dart' as run_torso;

/// Paints the supplied rider shapes as separate, movable body parts.
class UserRiderArtPainter {
  UserRiderArtPainter(RiderLook look)
    : _helmetFilter = userArtColorFilter(look.helmet),
      _suitFilter = userArtColorFilter(look.suit),
      _gloveFilter = userArtColorFilter(look.gloves),
      _bootFilter = userArtColorFilter(look.boots);

  static const Rect _bounds = Rect.fromLTWH(0, 0, 120, 170);

  final ColorFilter _helmetFilter;
  final ColorFilter _suitFilter;
  final ColorFilter _gloveFilter;
  final ColorFilter _bootFilter;
  final rear_helmet.Helmet2 _rearHelmet = rear_helmet.Helmet2();
  final rear_left_boot.RightBoot _leftBoot = rear_left_boot.RightBoot();
  final rear_right_boot.RightBoot2 _rightBoot = rear_right_boot.RightBoot2();
  final rear_legs.Legs _rearLegs = rear_legs.Legs();
  final rear_torso.Torso _rearTorso = rear_torso.Torso();
  final rear_right_arm.RightHand _rightArm = rear_right_arm.RightHand();
  final rear_left_arm.LeftHand _leftArm = rear_left_arm.LeftHand();
  final side_helmet.Helmet _sideHelmet = side_helmet.Helmet();
  final side_leg.Leg _sideLeg = side_leg.Leg();
  final side_arm.Arm _sideArm = side_arm.Arm();
  final run_left_boot.LeftBoot2 _runningLeftBoot = run_left_boot.LeftBoot2();
  final run_right_leg.RightLeg3 _runningRightLeg = run_right_leg.RightLeg3();
  final run_right_arm.RightHand4 _runningRightArm = run_right_arm.RightHand4();
  final run_helmet.Helmet5 _runningHelmet = run_helmet.Helmet5();
  final run_right_boot.RightBoot5 _runningRightBoot =
      run_right_boot.RightBoot5();
  final run_left_leg.LeftLeg2 _runningLeftLeg = run_left_leg.LeftLeg2();
  final run_left_arm.LeftHand3 _runningLeftArm = run_left_arm.LeftHand3();
  final run_torso.Torso4 _runningTorso = run_torso.Torso4();

  /// Blends the seated rear drawing into its supplied side facing pose.
  void paintRacing(Canvas canvas, RiderPose pose) {
    final amount = pose.perspective.abs().clamp(0.0, 1.0).toDouble();
    _paintFaded(canvas, 1 - amount, () => _paintRear(canvas, pose));
    if (amount > 0) {
      _paintFaded(canvas, amount, () => _paintSide(canvas, pose.perspective));
    }
  }

  /// Paints the supplied side running pose with alternating legs and arms.
  void paintRunning(Canvas canvas, double phase) {
    final swing = math.sin(phase) * 0.48;
    _paintPart(canvas, _bootFilter, (target) {
      _around(target, const Offset(63, 82), -swing, _runningLeftBoot.paint);
    });
    _paintPart(canvas, _suitFilter, (target) {
      _around(target, const Offset(78, 82), swing, _runningRightLeg.paint);
    });
    _paintPart(canvas, _gloveFilter, (target) {
      _around(
        target,
        const Offset(76, 42),
        -swing * 0.45,
        _runningRightArm.paint,
      );
    });
    _paintPart(canvas, _helmetFilter, _runningHelmet.paint);
    _paintPart(canvas, _bootFilter, (target) {
      _around(target, const Offset(78, 82), swing, _runningRightBoot.paint);
    });
    _paintPart(canvas, _suitFilter, (target) {
      _around(target, const Offset(63, 82), -swing, _runningLeftLeg.paint);
    });
    _paintPart(canvas, _gloveFilter, (target) {
      _around(
        target,
        const Offset(91, 42),
        swing * 0.45,
        _runningLeftArm.paint,
      );
    });
    _paintPart(canvas, _suitFilter, _runningTorso.paint);
  }

  void _paintRear(Canvas canvas, RiderPose pose) {
    _paintPart(canvas, _helmetFilter, _rearHelmet.paint);
    _paintPart(canvas, _bootFilter, (target) {
      _around(
        target,
        const Offset(44, 85),
        0,
        _leftBoot.paint,
        scaleY: 1 + pose.foot * 0.34,
      );
      _rightBoot.paint(target);
    });
    _paintPart(canvas, _suitFilter, (target) {
      _around(
        target,
        const Offset(44, 85),
        0,
        _rearLegs.paintLeft,
        scaleY: 1 + pose.foot * 0.34,
      );
      _rearLegs.paintRight(target);
    });
    _paintPart(canvas, _suitFilter, _rearTorso.paint);
    _paintPart(canvas, _gloveFilter, _rightArm.paint);
    _paintPart(canvas, _gloveFilter, _leftArm.paint);
  }

  void _paintSide(Canvas canvas, double perspective) {
    canvas.save();
    if (perspective < 0) {
      canvas
        ..translate(120, 0)
        ..scale(-1, 1);
    }
    _paintPart(canvas, _helmetFilter, _sideHelmet.paint);
    _paintPart(canvas, _suitFilter, _sideLeg.paint);
    _paintPart(canvas, _gloveFilter, _sideArm.paint);
    canvas.restore();
  }

  void _paintPart(
    Canvas canvas,
    ColorFilter filter,
    void Function(Canvas) paint,
  ) {
    canvas.saveLayer(_bounds, Paint()..colorFilter = filter);
    paint(canvas);
    canvas.restore();
  }

  void _paintFaded(Canvas canvas, double opacity, void Function() paint) {
    if (opacity <= 0) return;
    canvas.saveLayer(
      _bounds,
      Paint()..color = Color.fromARGB((opacity * 255).round(), 255, 255, 255),
    );
    paint();
    canvas.restore();
  }

  void _around(
    Canvas canvas,
    Offset pivot,
    double angle,
    void Function(Canvas) paint, {
    double scaleY = 1,
  }) {
    canvas
      ..save()
      ..translate(pivot.dx, pivot.dy)
      ..rotate(angle)
      ..scale(1, scaleY)
      ..translate(-pivot.dx, -pivot.dy);
    paint(canvas);
    canvas.restore();
  }
}
