// Dart imports:
import 'dart:ui';

// Project imports:
import 'in_motion/rider_in_motion_painter.dart';
import 'leg_planted/leg_planted_painter.dart';
import 'look/art_palette.dart';
import 'look/art_palettes.dart';
import 'look/rider_look.dart';
import 'rider_facing.dart';

/// Paints the layered rider and bike artwork in a rider's colors.
class RiderArtwork {
  RiderArtwork(RiderLook look) : _palette = ArtPalettes.of(look);

  final ArtPalette _palette;
  final RiderInMotionPainter _inMotion = RiderInMotionPainter();
  final LegPlantedPainter _legPlanted = LegPlantedPainter();

  /// Paints the rider moving, or with the left leg planted when [planted].
  void paint(
    Canvas canvas, {
    required RiderFacing facing,
    required bool planted,
    double steer = 0,
  }) {
    ArtPalette.use(_palette, () {
      if (planted) {
        _paintPlanted(canvas, facing, steer);
      } else {
        _paintInMotion(canvas, facing, steer);
      }
    });
  }

  // Drawings are named for the side shown, opposite to where the bike points.
  void _paintInMotion(Canvas canvas, RiderFacing facing, double steer) {
    switch (facing) {
      case RiderFacing.straight:
        _inMotion.paintFacingStraight(canvas, steer: steer);
      case RiderFacing.right:
        _inMotion.paintFacingSlightlyLeft(canvas, steer: steer);
      case RiderFacing.left:
        _inMotion.paintFacingSlightlyRight(canvas, steer: steer);
    }
  }

  void _paintPlanted(Canvas canvas, RiderFacing facing, double steer) {
    switch (facing) {
      case RiderFacing.straight:
        _legPlanted.paintFacingStraight(canvas, steer: steer);
      case RiderFacing.right:
        _legPlanted.paintFacingSlightlyLeft(canvas, steer: steer);
      case RiderFacing.left:
        _legPlanted.paintFacingSlightlyRight(canvas, steer: steer);
    }
  }
}
