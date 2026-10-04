import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import 'road_renderer.dart';

/// Motorbike + rider seen from behind, drawn with plain canvas shapes
/// (no assets needed). Swap [render] for a Sprite later.
class RiderComponent extends PositionComponent {
  RiderComponent(this.road) : super(anchor: Anchor.bottomCenter);

  final RoadRenderer road;

  // Design box is 100 x 140 units; everything is scaled to [size].
  static const double _dw = 100, _dh = 140;

  final _paint = Paint();
  double _lean = 0;
  double _phase = 0;
  double _t = 0;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final h = math.min(size.y * 0.32, size.x * 0.7 * _dh / _dw);
    this.size = Vector2(h * _dw / _dh, h);
    position = Vector2(size.x / 2, size.y * 0.94);
  }

  @override
  void update(double dt) {
    _t += dt;
    _phase = (_phase + road.speed * dt * 0.01) % 52;
    final target = road.steer * 0.32;
    _lean += (target - _lean) * math.min(1.0, dt * 8);
  }

  void _fill(Canvas c, RRect r, int argb) {
    _paint.color = Color(argb);
    c.drawRRect(r, _paint);
  }

  RRect _rr(double l, double t, double r, double b, [double rad = 4]) =>
      RRect.fromLTRBR(l, t, r, b, Radius.circular(rad));

  void _line(Canvas c, Offset a, Offset b, double w, int argb) {
    _paint
      ..color = Color(argb)
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;
    c.drawLine(a, b, _paint);
  }

  @override
  void render(Canvas canvas) {
    final sp = road.speedPercent;
    final shake = road.offRoad ? math.sin(_t * 60) * 2.5 * sp : 0.0;
    final bob = math.sin(_t * 14) * 1.2 * sp;

    canvas.save();
    canvas.scale(size.y / _dh);

    // Ground shadow (does not lean)
    _paint
      ..color = const Color(0x59000000)
      ..style = PaintingStyle.fill;
    canvas.drawOval(Rect.fromLTWH(14, 128, 72, 14), _paint);

    // Lean around the tyre contact patch
    canvas.translate(50 + shake, 138);
    canvas.rotate(_lean);
    canvas.translate(-50, -138 + bob);

    // Rear tyre + scrolling tread
    _fill(canvas, _rr(41, 88, 59, 140, 6), 0xFF121212);
    for (var n = 0; n < 4; n++) {
      final y = 88 + ((n * 13 + _phase) % 52);
      _paint.color = const Color(0xFF2E2E2E);
      canvas.drawRect(Rect.fromLTWH(41, y, 18, 3), _paint);
    }

    // Exhausts
    _fill(canvas, _rr(26, 100, 36, 124, 4), 0xFF9A9A9A);
    _fill(canvas, _rr(64, 100, 74, 124, 4), 0xFF9A9A9A);

    // Tail / fender + brake light
    _fill(canvas, _rr(35, 70, 65, 98, 8), 0xFFD6252B);
    _fill(canvas, _rr(43, 90, 57, 95, 2),
        road.brake ? 0xFFFF2020 : 0xFFFF8A80);

    // Legs
    _fill(canvas, _rr(29, 58, 43, 102, 6), 0xFF1F3A5F);
    _fill(canvas, _rr(57, 58, 71, 102, 6), 0xFF1F3A5F);

    // Jacket
    _fill(canvas, _rr(32, 22, 68, 78, 10), 0xFFF2A900);
    _fill(canvas, _rr(47, 24, 53, 76, 3), 0xFF2B2B2B);

    // Arms + handlebar
    _line(canvas, const Offset(37, 36), const Offset(15, 30), 9, 0xFFF2A900);
    _line(canvas, const Offset(63, 36), const Offset(85, 30), 9, 0xFFF2A900);
    _line(canvas, const Offset(8, 29), const Offset(92, 29), 4, 0xFF3A3A3A);
    _paint.color = const Color(0xFF111111);
    canvas.drawCircle(const Offset(11, 29), 4.5, _paint);
    canvas.drawCircle(const Offset(89, 29), 4.5, _paint);

    // Helmet
    _paint.color = const Color(0xFFF4F4F4);
    canvas.drawCircle(const Offset(50, 14), 15, _paint);
    _fill(canvas, _rr(47, 0, 53, 27, 3), 0xFFD6252B);

    canvas.restore();
  }
}
