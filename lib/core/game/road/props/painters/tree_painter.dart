// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';

/// Paints trees, bushes, palms and boulders.
class TreePainter {
  TreePainter(SceneTheme theme)
      : _leafDark = fogRamp(theme.treeDark, theme.fog, antiAlias: true),
        _leafLight = fogRamp(theme.treeLight, theme.fog, antiAlias: true),
        _trunk = fogRamp(theme.trunk, theme.fog),
        _shadow = fogRamp(const Color(0x3A000000), theme.fog, antiAlias: true),
        _rock = fogRamp(theme.rockColor, theme.fog, antiAlias: true),
        _rockLight =
            fogRamp(shade(theme.rockColor, 0.22), theme.fog, antiAlias: true);

  final List<Paint> _leafDark, _leafLight, _trunk, _shadow, _rock, _rockLight;
  final Path _path = Path();

  /// Draws the tree or boulder for a prop.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on.
  void draw(Canvas canvas, VisionSeg vision, Prop prop, double anchorX, double anchorY, double width,
      double height) {
    switch (prop.kind) {
      case PropKind.broadleaf:
        _broadleaf(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.pine:
        _pine(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.bush:
        _bush(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.acacia:
        _acacia(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.palm:
        _palm(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.rock:
        _boulder(canvas, vision, anchorX, anchorY, width, height);
      default:
        break;
    }
  }

  /// Draws the ground shadow under a tree.
  void _contact(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double radius) {
    if (radius < 1.2) return;
    canvas.drawOval(
        Rect.fromCenter(center: Offset(anchorX, anchorY), width: radius * 2.1, height: radius * 0.62),
        fogged(_shadow, vision.fog));
  }

  /// Draws a broadleaf tree (parameters as in [draw]).
  void _broadleaf(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double treeWidth, double treeHeight) {
    _contact(canvas, vision, anchorX, anchorY, treeWidth * 0.9);
    final trunkW = math.max(1.0, treeWidth * 0.17);
    final trunkTop = anchorY - treeHeight * 0.42;
    canvas.drawRect(Rect.fromLTRB(anchorX - trunkW, trunkTop, anchorX + trunkW, anchorY + 1),
        fogged(_trunk, vision.fog));

    final crownY = anchorY - treeHeight * 0.68;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX, crownY), width: treeWidth * 2, height: treeHeight * 0.62),
        fogged(_leafDark, vision.fog));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX - treeWidth * 0.26, crownY - treeHeight * 0.1),
            width: treeWidth * 1.25,
            height: treeHeight * 0.36),
        fogged(_leafLight, vision.fog));
  }

  /// Draws a pine tree (parameters as in [draw]).
  void _pine(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height) {
    _contact(canvas, vision, anchorX, anchorY, width * 0.7);
    final trunkW = math.max(1.0, width * 0.13);
    canvas.drawRect(Rect.fromLTRB(anchorX - trunkW, anchorY - height * 0.22, anchorX + trunkW, anchorY + 1),
        fogged(_trunk, vision.fog));

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
    canvas.drawPath(_path, fogged(_leafDark, vision.fog));

    _path.reset();
    _path
      ..moveTo(anchorX, anchorY - height)
      ..lineTo(anchorX + width * 0.3, anchorY - height * 0.74)
      ..lineTo(anchorX - width * 0.3, anchorY - height * 0.74)
      ..close();
    canvas.drawPath(_path, fogged(_leafLight, vision.fog));
  }

  /// Draws an acacia tree (parameters as in [draw]).
  void _acacia(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double treeWidth, double treeHeight) {
    _contact(canvas, vision, anchorX, anchorY, treeWidth * 0.8);
    final trunkW = math.max(1.0, treeWidth * 0.1);
    canvas.drawRect(Rect.fromLTRB(anchorX - trunkW, anchorY - treeHeight * 0.6, anchorX + trunkW, anchorY + 1),
        fogged(_trunk, vision.fog));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX, anchorY - treeHeight * 0.68), width: treeWidth * 2.4, height: treeHeight * 0.3),
        fogged(_leafDark, vision.fog));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX - treeWidth * 0.2, anchorY - treeHeight * 0.74),
            width: treeWidth * 1.5,
            height: treeHeight * 0.16),
        fogged(_leafLight, vision.fog));
  }

  /// Draws a bush (parameters as in [draw]).
  void _bush(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double treeWidth, double treeHeight) {
    _contact(canvas, vision, anchorX, anchorY, treeWidth * 0.8);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX, anchorY - treeHeight * 0.42), width: treeWidth * 2, height: treeHeight * 0.9),
        fogged(_leafDark, vision.fog));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(anchorX - treeWidth * 0.3, anchorY - treeHeight * 0.58),
            width: treeWidth * 1.1,
            height: treeHeight * 0.45),
        fogged(_leafLight, vision.fog));
  }

  /// Draws a palm tree (parameters as in [draw]).
  void _palm(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height) {
    _contact(canvas, vision, anchorX, anchorY, width * 0.6);
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
    canvas.drawPath(_path, fogged(_trunk, vision.fog));

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
    canvas.drawPath(_path, fogged(_leafDark, vision.fog));

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
    canvas.drawPath(_path, fogged(_leafLight, vision.fog));
  }

  /// Draws a boulder (parameters as in [draw]).
  void _boulder(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height) {
    _contact(canvas, vision, anchorX, anchorY, width * 0.9);
    _path
      ..reset()
      ..moveTo(anchorX - width, anchorY)
      ..lineTo(anchorX - width * 0.82, anchorY - height * 0.55)
      ..lineTo(anchorX - width * 0.25, anchorY - height)
      ..lineTo(anchorX + width * 0.5, anchorY - height * 0.82)
      ..lineTo(anchorX + width, anchorY - height * 0.2)
      ..lineTo(anchorX + width * 0.9, anchorY)
      ..close();
    canvas.drawPath(_path, fogged(_rock, vision.fog));
    _path
      ..reset()
      ..moveTo(anchorX - width * 0.82, anchorY - height * 0.55)
      ..lineTo(anchorX - width * 0.25, anchorY - height)
      ..lineTo(anchorX + width * 0.5, anchorY - height * 0.82)
      ..lineTo(anchorX + width * 0.05, anchorY - height * 0.5)
      ..close();
    canvas.drawPath(_path, fogged(_rockLight, vision.fog));
  }
}
