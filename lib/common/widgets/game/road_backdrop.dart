// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'road_config.dart';
import 'road_projection.dart';
import 'road_theme.dart';

/// Sky, clouds, distant skyline or hills, and the ground behind the road.
class RoadBackdrop {
  RoadBackdrop(this.theme)
      : _far = Paint()..color = theme.backFar,
        _near = Paint()..color = theme.backNear,
        _ground = Paint()
          ..color = theme.groundLight
          ..isAntiAlias = false;

  final SceneTheme theme;
  final Paint _far, _near, _ground;
  final Paint _sky = Paint();
  final Paint _cloud = Paint()..color = const Color(0xCCFFFFFF);
  final Path _path = Path();

  /// Horizontal scroll of the scenery; grows as the road bends.
  double scroll = 0;

  static const _cloudX = [0.05, 0.28, 0.52, 0.74, 0.93];
  static const _cloudY = [0.20, 0.45, 0.15, 0.38, 0.25];

  void resize(Vector2 size) {
    _sky.shader = Gradient.linear(
      Offset.zero,
      Offset(0, size.y * RoadConfig.horizonRatio),
      [theme.skyTop, theme.skyHorizon],
    );
  }

  void draw(Canvas canvas, Vector2 size) {
    final w = size.x;
    final horizon = size.y * RoadConfig.horizonRatio;
    final k = size.y / 700;

    canvas.drawRect(Rect.fromLTWH(0, 0, w, horizon + 1), _sky);
    _clouds(canvas, w, horizon);
    if (theme.backdrop == BackdropKind.skyline) {
      _skyline(canvas, w, horizon, k);
    } else {
      _hills(canvas, w, horizon, k, _far, 46, 0.007, 0.6);
      _hills(canvas, w, horizon, k, _near, 30, 0.012, 1.0);
    }
    canvas.drawRect(Rect.fromLTRB(0, horizon, w, size.y), _ground);
  }

  void _clouds(Canvas c, double w, double horizon) {
    final span = w * 1.4;
    for (var i = 0; i < _cloudX.length; i++) {
      final x = (_cloudX[i] * span - scroll * 0.2) % span - w * 0.2;
      final y = horizon * _cloudY[i];
      final s = horizon * (0.10 + 0.02 * (i % 3));
      c.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: s * 3.2, height: s),
          _cloud);
      c.drawOval(
          Rect.fromCenter(
              center: Offset(x + s * 0.7, y - s * 0.25),
              width: s * 2.0,
              height: s * 0.9),
          _cloud);
    }
  }

  void _skyline(Canvas c, double w, double horizon, double k) {
    final bw = 38 * k;
    final first = (scroll * 0.5 / bw).floor() - 1;
    final count = (w / bw).ceil() + 3;
    for (var j = 0; j < count; j++) {
      final i = first + j;
      final x = i * bw - scroll * 0.5;
      final h = (40 + 130 * roadRand(i)) * k;
      c.drawRect(Rect.fromLTWH(x, horizon - h, bw + 1, h + 1),
          i.isEven ? _far : _near);
    }
  }

  void _hills(Canvas c, double w, double horizon, double k, Paint paint,
      double amp, double freq, double speed) {
    _path
      ..reset()
      ..moveTo(0, horizon + 1);
    for (double x = 0; x <= w + 8; x += 8) {
      final s = x + scroll * speed;
      final y = horizon -
          amp * k * (1 + 0.5 * math.sin(s * freq) + 0.3 * math.sin(s * freq * 2.7 + 1.3));
      _path.lineTo(x, y);
    }
    _path
      ..lineTo(w, horizon + 1)
      ..close();
    c.drawPath(_path, paint);
  }
}
