// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../universal/contact_shadow.dart';
import '../universal/foliage_palette.dart';
import '../universal/road_projection.dart';

/// Paints a bush: a round clump of leaves on the ground.
class BushPainter {
  BushPainter(this._palette, this._shadow);

  final FoliagePalette _palette;
  final ContactShadow _shadow;

  /// Draws the bush with its base at ([anchorX], [anchorY]).
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double treeWidth, double treeHeight) {
    _shadow.draw(canvas, vision, anchorX, anchorY, treeWidth * 0.8);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX, anchorY - treeHeight * 0.42), width: treeWidth * 2, height: treeHeight * 0.9),
        fogged(_palette.leafDark, vision.fog));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX - treeWidth * 0.3, anchorY - treeHeight * 0.58),
            width: treeWidth * 1.1,
            height: treeHeight * 0.45),
        fogged(_palette.leafLight, vision.fog));
  }
}
