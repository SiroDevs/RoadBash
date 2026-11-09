import 'dart:ui';

import '../look/rider_look.dart';
import 'user_art_color.dart';
import 'user_assets/bike/layers/slight_left_forward/slight_left_forward_layer.dart';
import 'user_assets/bike/layers/slight_right_forward/slight_right_forward_layer.dart';
import 'user_assets/bike/layers/straight_forward/straight_forward_layer.dart';

/// Paints supplied motorcycle parts with steering and three-quarter views.
class UserBikeArtPainter {
  UserBikeArtPainter(RiderLook look)
    : _panel = userArtColorFilter(look.bike.panel),
      _body = userArtColorFilter(look.bike.panelDark),
      _frame = userArtColorFilter(look.bike.frame),
      _metal = userArtColorFilter(look.bike.trim);

  static const Rect _bounds = Rect.fromLTWH(0, 0, 120, 170);

  final ColorFilter _panel;
  final ColorFilter _body;
  final ColorFilter _frame;
  final ColorFilter _metal;
  final BikeStraightForwardLayer _straight = BikeStraightForwardLayer();
  final BikeSlightLeftForwardLayer _left = BikeSlightLeftForwardLayer();
  final BikeSlightRightForwardLayer _right = BikeSlightRightForwardLayer();

  /// Blends separate bike components into the current turn angle.
  void paint(Canvas canvas, double perspective, {double steer = 0}) {
    final angle = perspective.clamp(-1.0, 1.0).toDouble();
    final sideWeight = angle.abs();
    _paintLayer(
      canvas,
      1 - sideWeight,
      (target) => _paintStraight(target, steer),
    );
    if (angle < 0) {
      _paintLayer(canvas, sideWeight, (target) => _paintLeft(target, steer));
    } else if (angle > 0) {
      _paintLayer(canvas, sideWeight, (target) => _paintRight(target, steer));
    }
  }

  void _paintStraight(Canvas canvas, double steer) {
    _paintPart(canvas, _body, _straight.paintMainBody);
    _paintHandleBars(canvas, _straight.paintHandleBars, steer);
    _paintPart(canvas, _frame, _straight.paintTyre);
    _paintPart(canvas, _metal, _straight.paintExhaust);
    _paintPart(canvas, _panel, _straight.paintBackPart);
    _paintPart(canvas, _panel, _straight.paintFrontPart);
  }

  void _paintLeft(Canvas canvas, double steer) {
    _paintPart(canvas, _body, _left.paintMainBody);
    _paintPart(canvas, _frame, _left.paintTyres);
    _paintPart(canvas, _metal, _left.paintExhaust);
    _paintHandleBars(canvas, _left.paintHandleBars, steer);
    _paintPart(canvas, _panel, _left.paintFrontPart);
    _paintPart(canvas, _panel, _left.paintBackPart);
  }

  void _paintRight(Canvas canvas, double steer) {
    _paintPart(canvas, _metal, _right.paintExhaust);
    _paintPart(canvas, _frame, _right.paintTyres);
    _paintHandleBars(canvas, _right.paintHandleBars, steer);
    _paintPart(canvas, _panel, _right.paintFrontPart);
    _paintPart(canvas, _body, _right.paintMainBody);
    _paintPart(canvas, _panel, _right.paintBackPart);
  }

  void _paintHandleBars(
    Canvas canvas,
    void Function(Canvas) paint,
    double steer,
  ) {
    _paintPart(canvas, _frame, (target) {
      _around(target, const Offset(60, 55), steer * 0.11, paint);
    });
  }

  void _paintPart(
    Canvas canvas,
    ColorFilter filter,
    void Function(Canvas) paint,
  ) {
    canvas.saveLayer(_bounds, Paint()..colorFilter = filter);
    paint(canvas);
    canvas.restore();
  }

  void _paintLayer(Canvas canvas, double opacity, void Function(Canvas) paint) {
    if (opacity <= 0) return;
    canvas.saveLayer(
      _bounds,
      Paint()..color = Color.fromARGB((opacity * 255).round(), 255, 255, 255),
    );
    paint(canvas);
    canvas.restore();
  }

  void _around(
    Canvas canvas,
    Offset pivot,
    double angle,
    void Function(Canvas) paint,
  ) {
    canvas
      ..save()
      ..translate(pivot.dx, pivot.dy)
      ..rotate(angle)
      ..translate(-pivot.dx, -pivot.dy);
    paint(canvas);
    canvas.restore();
  }
}
