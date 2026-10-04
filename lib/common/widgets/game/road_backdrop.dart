// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'road_config.dart';

/// Sky, sun, parallax mountains and the grass behind the road.
class RoadBackdrop {
  final _sky = Paint()..color = const Color(0xFF6EC6FF);
  final _mountain = Paint()..color = const Color(0xFF5B7FA6);
  final _sun = Paint()..color = const Color(0xFFFFE9A8);
  final _grass = Paint()
    ..color = const Color(0xFF2E9E3A)
    ..isAntiAlias = false;
  final _path = Path();

  /// Horizontal scroll of the scenery; grows as the road bends.
  double scroll = 0;

  void resize(Vector2 size) {
    _sky.shader = Gradient.linear(
      Offset.zero,
      Offset(0, size.y * RoadConfig.horizonRatio),
      const [Color(0xFF3A8DDE), Color(0xFFBFE6FF)],
    );
  }

  void draw(Canvas canvas, Vector2 size) {
    final w = size.x;
    final horizon = size.y * RoadConfig.horizonRatio;

    canvas.drawRect(Rect.fromLTWH(0, 0, w, horizon + 1), _sky);
    canvas.drawCircle(Offset(w * 0.72 + scroll * 0.1, horizon * 0.55),
        horizon * 0.11, _sun);

    final k = size.y / 700;
    _path
      ..reset()
      ..moveTo(0, horizon + 1);
    for (double x = 0; x <= w + 8; x += 8) {
      final s = x + scroll;
      final y = horizon -
          (26 + 20 * math.sin(s * 0.011) + 11 * math.sin(s * 0.029)) * k;
      _path.lineTo(x, y);
    }
    _path
      ..lineTo(w, horizon + 1)
      ..close();
    canvas.drawPath(_path, _mountain);

    canvas.drawRect(Rect.fromLTRB(0, horizon, w, size.y), _grass);
  }
}
