// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../utils/paint_utils.dart';
import '../utils/scenery_shapes.dart';
import 'road_config.dart';
import 'road_theme.dart';

class RoadBackdrop {
  RoadBackdrop(this.theme)
      : _far = fillPaint(Color.lerp(theme.backFar, theme.fog, 0.35)!),
        _near = fillPaint(Color.lerp(theme.backNear, theme.fog, 0.18)!);

  final SceneTheme theme;
  final Paint _far, _near;
  final Paint _sky = Paint();
  final Paint _ground = Paint()..isAntiAlias = false;
  final Paint _cloud = fillPaint(const Color(0xB3FFFFFF));
  final Path _path = Path();

  /// Horizontal scroll of the scenery; grows as the road bends.
  double scroll = 0;

  static const _cloudX = [0.05, 0.28, 0.52, 0.74, 0.93];
  static const _cloudY = [0.20, 0.45, 0.15, 0.38, 0.25];

  void resize(Vector2 size) {
    final horizon = size.y * RoadConfig.horizonRatio;
    _sky.shader = Gradient.linear(
      Offset.zero,
      Offset(0, horizon),
      [theme.skyTop, theme.skyHorizon],
    );
    _ground.shader = Gradient.linear(
      Offset(0, horizon),
      Offset(0, horizon + size.y * 0.16),
      [theme.fog, theme.ground],
    );
  }

  void draw(Canvas canvas, Vector2 size) {
    final w = size.x;
    final horizon = size.y * RoadConfig.horizonRatio;
    final k = size.y / 700;

    canvas.drawRect(Rect.fromLTWH(0, 0, w, horizon + 1), _sky);
    _clouds(canvas, w, horizon);
    if (theme.backdrop == BackdropKind.skyline) {
      drawSkyline(canvas,
          width: w,
          baseY: horizon,
          block: 38 * k,
          minHeight: 40 * k,
          maxHeight: 170 * k,
          scroll: scroll * 0.5,
          a: _far,
          b: _near);
    } else {
      drawHills(canvas, _path,
          width: w,
          baseY: horizon,
          amplitude: 46 * k,
          frequency: 0.007,
          scroll: scroll * 0.6,
          paint: _far);
      drawHills(canvas, _path,
          width: w,
          baseY: horizon,
          amplitude: 30 * k,
          frequency: 0.012,
          scroll: scroll,
          paint: _near);
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
}
