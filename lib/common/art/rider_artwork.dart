// Dart imports:
import 'dart:ui';

// Project imports:
import 'in_motion/rider_in_motion_painter.dart';
import 'leg_planted/leg_planted_painter.dart';
import 'look/art_palette.dart';
import 'look/art_palettes.dart';
import 'look/art_recolor_canvas.dart';
import 'look/rider_look.dart';
import 'rider_facing.dart';

/// Paints the layered rider and bike artwork in a rider's colors.
class RiderArtwork {
  RiderArtwork(RiderLook look) : _palette = ArtPalettes.of(look);

  final ArtPalette _palette;
  late final ArtRecolorCanvas? _recolor = identical(_palette, ArtPalette.drawn)
      ? null
      : ArtRecolorCanvas(_palette);
  final RiderInMotionPainter _inMotion = RiderInMotionPainter();
  final LegPlantedPainter _legPlanted = LegPlantedPainter();

  /// Paints the rider moving, or with the left leg planted when [planted].
  void paint(
    Canvas canvas, {
    required RiderFacing facing,
    required bool planted,
  }) {
    final recolor = _recolor?..target = canvas;
    final art = recolor ?? canvas;
    if (planted) {
      _paintPlanted(art, facing);
    } else {
      _paintInMotion(art, facing);
    }
  }

  void _paintInMotion(Canvas canvas, RiderFacing facing) {
    switch (facing) {
      case RiderFacing.straight:
        _inMotion.paintFacingStraight(canvas);
      case RiderFacing.right:
        _inMotion.paintFacingSlightlyRight(canvas);
      case RiderFacing.left:
        _inMotion.paintFacingSlightlyLeft(canvas);
    }
  }

  void _paintPlanted(Canvas canvas, RiderFacing facing) {
    switch (facing) {
      case RiderFacing.straight:
        _legPlanted.paintFacingStraight(canvas);
      case RiderFacing.right:
        _legPlanted.paintFacingSlightlyRight(canvas);
      case RiderFacing.left:
        _legPlanted.paintFacingSlightlyLeft(canvas);
    }
  }
}
