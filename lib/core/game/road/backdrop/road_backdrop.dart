// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../utils/paint_utils.dart';
import '../config/road_config.dart';
import '../scene_theme.dart';
import 'hills.dart';
import 'skyline/skyline.dart';

class RoadBackdrop {
  RoadBackdrop(this.theme)
    : _far = fillPaint(Color.lerp(theme.backFar, theme.fog, 0.35)!),
      _near = fillPaint(Color.lerp(theme.backNear, theme.fog, 0.18)!),
      _front = fillPaint(Color.lerp(theme.backNear, const Color(0xFF000000), 0.18)!),
      _farHaze = theme.fog.withAlpha(150),
      _nearHaze = theme.fog.withAlpha(45);

  final SceneTheme theme;
  final Paint _far, _near, _front;
  final Color _farHaze, _nearHaze;
  final Paint _sky = Paint();
  final Paint _ground = Paint()..isAntiAlias = false;
  final Paint _cloud = fillPaint(const Color(0xB3FFFFFF));
  final Path _path = Path();

  double scroll = 0;

  /// 0..1, how far the finish-street skyline has climbed over the horizon
  /// on scenes whose own backdrop has none.
  double skylineRise = 0;

  static const _cloudX = [0.05, 0.28, 0.52, 0.74, 0.93];
  static const _cloudY = [0.20, 0.45, 0.15, 0.38, 0.25];

  void resize(Vector2 size) {
    final horizon = size.y * RoadConfig.horizonRatio;
    _sky.shader = Gradient.linear(Offset.zero, Offset(0, horizon), [
      theme.skyTop,
      theme.skyHorizon,
    ]);
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
    _clouds(canvas, w, horizon, big: theme.backdrop == BackdropKind.sky);

    if (theme.backdrop == BackdropKind.skyline) {
      drawCityScape(
        canvas,
        width: w,
        baseY: horizon,
        height: 110 * k,
        scroll: scroll * 0.25 + 90 * k,
        haze: _farHaze,
      );
      drawCityScape(
        canvas,
        width: w,
        baseY: horizon,
        height: 170 * k,
        scroll: scroll * 0.5,
        haze: _nearHaze,
      );
    } else if (theme.backdrop == BackdropKind.hillsAndSkyline) {
      drawHills(
        canvas,
        _path,
        width: w,
        baseY: horizon,
        amplitude: 50 * k,
        frequency: 0.006,
        scroll: scroll * 0.5,
        paint: _far,
      );
      drawCityScape(
        canvas,
        width: w,
        baseY: horizon,
        height: 70 * k,
        scroll: scroll * 0.3 + 40 * k,
        haze: _farHaze,
      );
      drawHills(
        canvas,
        _path,
        width: w,
        baseY: horizon,
        amplitude: 20 * k,
        frequency: 0.011,
        scroll: scroll,
        paint: _near,
      );
    } else if (theme.backdrop == BackdropKind.ridges) {
      drawHills(
        canvas,
        _path,
        width: w,
        baseY: horizon,
        amplitude: 78 * k,
        frequency: 0.005,
        scroll: scroll * 0.35,
        paint: _far,
      );
      canvas.drawRect(
        Rect.fromLTRB(0, horizon - 90 * k, w, horizon),
        Paint()..color = _farHaze.withAlpha(60),
      );
      drawHills(
        canvas,
        _path,
        width: w,
        baseY: horizon,
        amplitude: 54 * k,
        frequency: 0.008,
        scroll: scroll * 0.6,
        paint: _near,
      );
      drawHills(
        canvas,
        _path,
        width: w,
        baseY: horizon,
        amplitude: 30 * k,
        frequency: 0.013,
        scroll: scroll,
        paint: _front,
      );
    } else if (theme.backdrop == BackdropKind.hills) {
      drawHills(
        canvas,
        _path,
        width: w,
        baseY: horizon,
        amplitude: 46 * k,
        frequency: 0.007,
        scroll: scroll * 0.6,
        paint: _far,
      );
      drawHills(
        canvas,
        _path,
        width: w,
        baseY: horizon,
        amplitude: 30 * k,
        frequency: 0.012,
        scroll: scroll,
        paint: _near,
      );
    }
    if (theme.backdrop != BackdropKind.skyline && skylineRise > 0.02) {
      // The ground below the horizon hides the part still rising.
      final drop = 1 - skylineRise;
      drawCityScape(
        canvas,
        width: w,
        baseY: horizon + 170 * k * drop,
        height: 110 * k,
        scroll: scroll * 0.25 + 90 * k,
        haze: _farHaze,
      );
      drawCityScape(
        canvas,
        width: w,
        baseY: horizon + 260 * k * drop,
        height: 170 * k,
        scroll: scroll * 0.5,
        haze: _nearHaze,
      );
    }
    canvas.drawRect(Rect.fromLTRB(0, horizon, w, size.y), _ground);
  }

  void _clouds(Canvas c, double w, double horizon, {bool big = false}) {
    final span = w * 1.4;
    final grow = big ? 1.9 : 1.0;
    for (var i = 0; i < _cloudX.length; i++) {
      final x = (_cloudX[i] * span - scroll * 0.2) % span - w * 0.2;
      final y = horizon * _cloudY[i];
      final s = horizon * (0.10 + 0.02 * (i % 3)) * grow;
      c.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: s * 3.2, height: s),
        _cloud,
      );
      c.drawOval(
        Rect.fromCenter(
          center: Offset(x + s * 0.7, y - s * 0.25),
          width: s * 2.0,
          height: s * 0.9,
        ),
        _cloud,
      );
    }
  }
}
