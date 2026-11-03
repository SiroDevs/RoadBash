// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../core/game/road/road_projection.dart';
import '../../../core/game/utils/paint_utils.dart';
import '../universal/contact_shadow.dart';
import '../universal/foliage_palette.dart';

/// Paints a pine tree: three stacked cones on a short trunk.
class PinePainter {
  PinePainter(this._palette, this._shadow);

  final FoliagePalette _palette;
  final ContactShadow _shadow;
  final Path _path = Path();

  /// Draws the tree with its roots at ([anchorX], [anchorY]).
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height) {
    _shadow.draw(canvas, vision, anchorX, anchorY, width * 0.7);
    final trunkW = math.max(1.0, width * 0.13);
    canvas.drawRect(Rect.fromLTRB(anchorX - trunkW, anchorY - height * 0.22, anchorX + trunkW, anchorY + 1),
        fogged(_palette.trunk, vision.fog));

    _path.reset();
    for (var tier = 0; tier < 3; tier++) {
      final base = anchorY - height * (0.18 + tier * 0.26);
      final tip = base - height * 0.42;
      final half = width * (1.0 - tier * 0.24);
      _path
        ..moveTo(anchorX, tip)
        ..lineTo(anchorX + half, base)
        ..lineTo(anchorX - half, base)
        ..close();
    }
    canvas.drawPath(_path, fogged(_palette.leafDark, vision.fog));

    _path.reset();
    _path
      ..moveTo(anchorX, anchorY - height)
      ..lineTo(anchorX + width * 0.3, anchorY - height * 0.74)
      ..lineTo(anchorX - width * 0.3, anchorY - height * 0.74)
      ..close();
    canvas.drawPath(_path, fogged(_palette.leafLight, vision.fog));
  }
}
