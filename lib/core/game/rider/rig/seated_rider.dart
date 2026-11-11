// Dart imports:
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';
import '../art/sheet/part_motion.dart';
import '../art/sheet/rider_sheets.dart';
import '../look/rider_look.dart';
import '../rider_pose.dart';
import 'seated_legs.dart';
import 'seated_upper.dart';

/// The rider seated on the bike, placed and layered as in the combi artwork.
class SeatedRiderFigure {
  SeatedRiderFigure(RiderLook look)
    : _rear = InkedSheet.rider(RiderSheets.seated, look) {
    _upper = SeatedUpper(_rear, InkedSheet.rider(RiderSheets.sideways, look));
    _legs = SeatedLegs(_rear);
  }

  static const double midX = 60;

  final InkedSheet _rear;
  late final SeatedUpper _upper;
  late final SeatedLegs _legs;

  /// Paints the rider for the pose: yaw, steering, tuck and foot down.
  ///
  /// Layers go as in the combi artwork: helmet, arms, legs, torso, boots.
  void paint(Canvas canvas, RiderPose pose) {
    final mirrored = pose.perspective < 0;
    // The foot goes down on the left of the screen, whichever way he is turned.
    final plantedSide = mirrored ? 'R' : 'L';
    canvas.save();
    if (mirrored) PartMotion.mirror(canvas, midX);
    _upper.helmet(canvas, pose);
    _upper.arms(canvas, pose);
    _legs.paintLegs(canvas, plantedSide, pose.foot);
    _upper.torso(canvas, pose.perspective);
    _legs.paintBoots(canvas, plantedSide, pose.foot, mirrored: mirrored);
    _upper.sideArm(canvas, pose);
    canvas.restore();
  }
}
