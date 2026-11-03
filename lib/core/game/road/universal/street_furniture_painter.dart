// Dart imports:
import 'dart:ui';

// Project imports:
import '../billboard/billboard_painter.dart';
import '../lamp/lamp_painter.dart';
import '../scene_theme.dart';
import '../sign/exit_sign_painter.dart';
import '../sign/sign_painter.dart';
import 'prop.dart';
import 'road_projection.dart';

/// Chooses the painter for each lamp, sign, billboard or exit sign.
class StreetFurniturePainter {
  StreetFurniturePainter(SceneTheme theme)
    : _lamp = LampPainter(theme),
      _sign = SignPainter(theme),
      _billboard = BillboardPainter(theme),
      _exitSign = ExitSignPainter(theme);

  final LampPainter _lamp;
  final SignPainter _sign;
  final BillboardPainter _billboard;
  final ExitSignPainter _exitSign;

  /// Draws the street furniture for a prop.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on.
  void draw(Canvas canvas, VisionSeg vision, Prop prop, double anchorX, double anchorY, double width,
      double height) {
    switch (prop.kind) {
      case PropKind.lamp:
        _lamp.draw(canvas, vision, anchorX, anchorY, width, height, prop.side, prop.detail);
      case PropKind.sign:
        _sign.draw(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.billboard:
        _billboard.draw(canvas, vision, anchorX, anchorY, width, height, prop);
      case PropKind.exitSign:
        _exitSign.draw(canvas, vision, anchorX, anchorY, width, height, prop);
      default:
        break;
    }
  }
}
