import 'dart:ui';

import 'look/rider_look.dart';
import 'user_assets/bike/bike_painter.dart' as supplied;

/// Paints the supplied motorcycle artwork with a smooth three-quarter view.
class UserBikeArtPainter {
  UserBikeArtPainter(RiderLook look)
    : _art = supplied.BikePainter(),
      _colorFilter = _colorFilterFor(look.bike.panel);

  static const Rect _bounds = Rect.fromLTWH(0, 0, 120, 170);

  final supplied.BikePainter _art;
  final ColorFilter _colorFilter;

  /// Blends the straight and angled bike drawings around the current turn.
  void paint(Canvas canvas, double perspective) {
    final angle = perspective.clamp(-1.0, 1.0).toDouble();
    final sideWeight = angle.abs();
    _paintLayer(canvas, 1 - sideWeight, _art.paintStraightForward);
    if (angle < 0) {
      _paintLayer(canvas, sideWeight, _art.paintSlightLeftForward);
    } else if (angle > 0) {
      _paintLayer(canvas, sideWeight, _art.paintSlightRightForward);
    }
  }

  void _paintLayer(Canvas canvas, double opacity, void Function(Canvas) paint) {
    if (opacity <= 0) return;
    canvas.saveLayer(
      _bounds,
      Paint()..color = Color.fromARGB((opacity * 255).round(), 255, 255, 255),
    );
    canvas.saveLayer(_bounds, Paint()..colorFilter = _colorFilter);
    paint(canvas);
    canvas.restore();
    canvas.restore();
  }

  static ColorFilter _colorFilterFor(Color color) {
    final red = (color.r * 255).roundToDouble();
    final green = (color.g * 255).roundToDouble();
    final blue = (color.b * 255).roundToDouble();
    return ColorFilter.matrix([
      0,
      0,
      0,
      0,
      red,
      0,
      0,
      0,
      0,
      green,
      0,
      0,
      0,
      0,
      blue,
      0,
      0,
      0,
      1,
      0,
    ]);
  }
}
