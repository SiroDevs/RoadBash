// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../universal/contact_shadow.dart';
import '../universal/foliage_palette.dart';
import '../universal/road_projection.dart';

/// Paints a palm: a curved trunk topped by a fan of drooping fronds.
class PalmPainter {
  PalmPainter(this._palette, this._shadow);

  final FoliagePalette _palette;
  final ContactShadow _shadow;
  final Path _path = Path();

  /// Draws the palm with its roots at ([anchorX], [anchorY]).
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height) {
    _shadow.draw(canvas, vision, anchorX, anchorY, width * 0.6);
    final topX = anchorX + width * 0.22;
    final topY = anchorY - height * 0.82;
    final trunkW = math.max(1.0, width * 0.1);
    _path
      ..reset()
      ..moveTo(anchorX - trunkW, anchorY + 1)
      ..quadraticBezierTo(anchorX + width * 0.02, anchorY - height * 0.4, topX - trunkW * 0.6, topY)
      ..lineTo(topX + trunkW * 0.6, topY)
      ..quadraticBezierTo(anchorX + width * 0.06, anchorY - height * 0.4, anchorX + trunkW, anchorY + 1)
      ..close();
    canvas.drawPath(_path, fogged(_palette.trunk, vision.fog));

    // Seven drooping fronds fanned around the crown.
    const reach = [-1.0, -0.66, -0.3, 0.0, 0.3, 0.66, 1.0];
    _path.reset();
    for (var i = 0; i < reach.length; i++) {
      final dir = reach[i];
      final tipX = topX + dir * width * 1.35;
      final tipY = topY + height * (0.04 + 0.1 * dir.abs()) - height * 0.05 * (1 - dir.abs());
      final lift = topY - height * (0.16 - 0.05 * dir.abs());
      _path
        ..moveTo(topX, topY)
        ..quadraticBezierTo(topX + dir * width * 0.7, lift - height * 0.04, tipX, tipY)
        ..quadraticBezierTo(topX + dir * width * 0.7, lift + height * 0.07, topX, topY);
    }
    canvas.drawPath(_path, fogged(_palette.leafDark, vision.fog));

    _path.reset();
    for (final dir in const [-0.5, 0.15, 0.7]) {
      final tipX = topX + dir * width * 1.1;
      final tipY = topY + height * 0.03;
      _path
        ..moveTo(topX, topY - height * 0.01)
        ..quadraticBezierTo(
            topX + dir * width * 0.5, topY - height * 0.12, tipX, tipY)
        ..quadraticBezierTo(
            topX + dir * width * 0.5, topY - height * 0.05, topX, topY - height * 0.01);
    }
    canvas.drawPath(_path, fogged(_palette.leafLight, vision.fog));
  }
}
