import 'dart:ui';

import '../look/rider_look.dart';
import 'user_art_color.dart';
import 'user_assets/rider/layers/side_standing/groups/helmet3.dart'
    as standing_helmet;
import 'user_assets/rider/layers/side_standing/groups/right_boot3.dart'
    as standing_boot;
import 'user_assets/rider/layers/side_standing/groups/right_hand2.dart'
    as standing_arm;
import 'user_assets/rider/layers/side_standing/groups/right_leg.dart'
    as standing_leg;
import 'user_assets/rider/layers/side_standing/groups/torso2.dart'
    as standing_torso;

/// Paints the supplied standing pose one independently colored part at a time.
class UserSideStandingArtPainter {
  UserSideStandingArtPainter(RiderLook look)
    : _helmet = userArtColorFilter(look.helmet),
      _suit = userArtColorFilter(look.suit),
      _gloves = userArtColorFilter(look.gloves),
      _boots = userArtColorFilter(look.boots);

  static const Rect _bounds = Rect.fromLTWH(0, 0, 120, 170);

  final ColorFilter _helmet;
  final ColorFilter _suit;
  final ColorFilter _gloves;
  final ColorFilter _boots;
  final standing_helmet.Helmet3 _helmetArt = standing_helmet.Helmet3();
  final standing_torso.Torso2 _torso = standing_torso.Torso2();
  final standing_arm.RightHand2 _arm = standing_arm.RightHand2();
  final standing_leg.RightLeg _leg = standing_leg.RightLeg();
  final standing_boot.RightBoot3 _boot = standing_boot.RightBoot3();

  /// Paints the side facing rider from helmet down to the boot.
  void paint(Canvas canvas) {
    _paintPart(canvas, _helmet, _helmetArt.paint);
    _paintPart(canvas, _suit, _torso.paint);
    _paintPart(canvas, _gloves, _arm.paint);
    _paintPart(canvas, _suit, _leg.paint);
    _paintPart(canvas, _boots, _boot.paint);
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
