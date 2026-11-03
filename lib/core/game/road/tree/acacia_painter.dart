// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../universal/contact_shadow.dart';
import '../universal/foliage_palette.dart';
import '../universal/road_projection.dart';

/// Paints an acacia: a thin trunk under a flat, wide crown.
class AcaciaPainter {
  AcaciaPainter(this._palette, this._shadow);

  final FoliagePalette _palette;
  final ContactShadow _shadow;

  /// Draws the tree with its roots at ([anchorX], [anchorY]).
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double treeWidth, double treeHeight) {
    _shadow.draw(canvas, vision, anchorX, anchorY, treeWidth * 0.8);
    final trunkW = math.max(1.0, treeWidth * 0.1);
    canvas.drawRect(Rect.fromLTRB(anchorX - trunkW, anchorY - treeHeight * 0.6, anchorX + trunkW, anchorY + 1),
        fogged(_palette.trunk, vision.fog));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX, anchorY - treeHeight * 0.68), width: treeWidth * 2.4, height: treeHeight * 0.3),
        fogged(_palette.leafDark, vision.fog));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX - treeWidth * 0.2, anchorY - treeHeight * 0.74),
            width: treeWidth * 1.5,
            height: treeHeight * 0.16),
        fogged(_palette.leafLight, vision.fog));
  }
}
