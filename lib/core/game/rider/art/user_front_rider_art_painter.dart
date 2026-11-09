import 'dart:ui';

import '../look/rider_look.dart';
import 'user_art_color.dart';
import 'user_assets/rider/layers/front_facing/groups/helmet4.dart'
    as front_helmet;
import 'user_assets/rider/layers/front_facing/groups/left_boot.dart'
    as front_left_boot;
import 'user_assets/rider/layers/front_facing/groups/left_hand2.dart'
    as front_left_arm;
import 'user_assets/rider/layers/front_facing/groups/left_leg.dart'
    as front_left_leg;
import 'user_assets/rider/layers/front_facing/groups/right_boot4.dart'
    as front_right_boot;
import 'user_assets/rider/layers/front_facing/groups/right_hand3.dart'
    as front_right_arm;
import 'user_assets/rider/layers/front_facing/groups/right_leg2.dart'
    as front_right_leg;
import 'user_assets/rider/layers/front_facing/groups/torso3.dart'
    as front_torso;

/// Paints the supplied front facing rider as separate components.
class UserFrontRiderArtPainter {
  UserFrontRiderArtPainter(RiderLook look)
    : _helmet = userArtColorFilter(look.helmet),
      _suit = userArtColorFilter(look.suit),
      _gloves = userArtColorFilter(look.gloves),
      _boots = userArtColorFilter(look.boots);

  static const Rect _bounds = Rect.fromLTWH(0, 0, 120, 170);

  final ColorFilter _helmet;
  final ColorFilter _suit;
  final ColorFilter _gloves;
  final ColorFilter _boots;
  final front_helmet.Helmet4 _helmetArt = front_helmet.Helmet4();
  final front_left_boot.LeftBoot _leftBoot = front_left_boot.LeftBoot();
  final front_right_boot.RightBoot4 _rightBoot = front_right_boot.RightBoot4();
  final front_torso.Torso3 _torso = front_torso.Torso3();
  final front_left_arm.LeftHand2 _leftArm = front_left_arm.LeftHand2();
  final front_right_arm.RightHand3 _rightArm = front_right_arm.RightHand3();
  final front_right_leg.RightLeg2 _rightLeg = front_right_leg.RightLeg2();
  final front_left_leg.LeftLeg _leftLeg = front_left_leg.LeftLeg();

  /// Paints the rider from helmet to boots using the original layer order.
  void paint(Canvas canvas) {
    _paintPart(canvas, _helmet, _helmetArt.paint);
    _paintPart(canvas, _boots, _leftBoot.paint);
    _paintPart(canvas, _boots, _rightBoot.paint);
    _paintPart(canvas, _suit, _torso.paint);
    _paintPart(canvas, _gloves, _leftArm.paint);
    _paintPart(canvas, _gloves, _rightArm.paint);
    _paintPart(canvas, _suit, _rightLeg.paint);
    _paintPart(canvas, _suit, _leftLeg.paint);
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
}
