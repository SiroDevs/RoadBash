// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../core/game/road/road_projection.dart';
import '../../../core/game/utils/paint_utils.dart';
import '../universal/contact_shadow.dart';
import '../universal/foliage_palette.dart';

/// Paints a broadleaf tree: a trunk under a wide round crown.
class BroadleafPainter {
  BroadleafPainter(this._palette, this._shadow);

  final FoliagePalette _palette;
  final ContactShadow _shadow;

  /// Draws the tree with its roots at ([anchorX], [anchorY]).
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double treeWidth, double treeHeight) {
    _shadow.draw(canvas, vision, anchorX, anchorY, treeWidth * 0.9);
    final trunkW = math.max(1.0, treeWidth * 0.17);
    final trunkTop = anchorY - treeHeight * 0.42;
    canvas.drawRect(Rect.fromLTRB(anchorX - trunkW, trunkTop, anchorX + trunkW, anchorY + 1),
        fogged(_palette.trunk, vision.fog));

    final crownY = anchorY - treeHeight * 0.68;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX, crownY), width: treeWidth * 2, height: treeHeight * 0.62),
        fogged(_palette.leafDark, vision.fog));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX - treeWidth * 0.26, crownY - treeHeight * 0.1),
            width: treeWidth * 1.25,
            height: treeHeight * 0.36),
        fogged(_palette.leafLight, vision.fog));
  }
}
