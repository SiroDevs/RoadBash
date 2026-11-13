// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../../common/objects/building/skyline/skyline.dart';
import '../../../../common/objects/mountain/hills.dart';
import '../../utils/paint_utils.dart';
import 'backdrop_clouds.dart';
import '../config/road_config.dart';
import '../scene_theme.dart';

/// Sky, hills, clouds and skyline behind the road.
class RoadBackdrop {
  RoadBackdrop(this.theme)
    : _far = fillPaint(Color.lerp(theme.backFar, theme.fog, 0.35)!),
      _near = fillPaint(Color.lerp(theme.backNear, theme.fog, 0.18)!),
      _front = fillPaint(
        Color.lerp(theme.backNear, const Color(0xFF000000), 0.18)!,
      ),
      _farHaze = theme.fog.withAlpha(150),
      _nearHaze = theme.fog.withAlpha(45);

  final SceneTheme theme;
  final Paint _far, _near, _front;
  final Color _farHaze, _nearHaze;
  final Paint _sky = Paint();
  final Paint _ground = Paint()..isAntiAlias = false;
  final Path _path = Path();

  double scroll = 0;

  /// 0..1, how far the finish-street skyline has climbed over the horizon
  /// on scenes whose own backdrop has none.
  double skylineRise = 0;

  static const _designHorizon = 0.42;

  /// Rebuilds the sky shader for a new screen size.
  void resize(Vector2 size) {
    final horizonRatio = RoadConfig.horizonRatioFor(size.x, size.y);
    final horizon = size.y * horizonRatio;
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

  /// Draws the sky, hills, clouds and skyline.
  void draw(Canvas canvas, Vector2 size) {
    final viewWidth = size.x;
    final horizonRatio = RoadConfig.horizonRatioFor(size.x, size.y);
    final horizon = size.y * horizonRatio;
    final unit = size.y / 700;
    final tall = unit * horizonRatio / _designHorizon;

    canvas.drawRect(Rect.fromLTWH(0, 0, viewWidth, horizon + 1), _sky);
    BackdropClouds.draw(
      canvas,
      viewWidth,
      horizon,
      scroll,
      big: theme.backdrop == BackdropKind.sky,
    );

    if (theme.backdrop == BackdropKind.skyline) {
      drawCityScape(
        canvas,
        width: viewWidth,
        baseY: horizon,
        height: 110 * tall,
        scroll: scroll * 0.25 + 90 * unit,
        haze: _farHaze,
      );
      drawCityScape(
        canvas,
        width: viewWidth,
        baseY: horizon,
        height: 170 * tall,
        scroll: scroll * 0.5,
        haze: _nearHaze,
      );
    } else if (theme.backdrop == BackdropKind.hillsAndSkyline) {
      drawHills(
        canvas,
        _path,
        width: viewWidth,
        baseY: horizon,
        amplitude: 50 * tall,
        frequency: 0.006,
        scroll: scroll * 0.5,
        paint: _far,
      );
      drawCityScape(
        canvas,
        width: viewWidth,
        baseY: horizon,
        height: 70 * tall,
        scroll: scroll * 0.3 + 40 * unit,
        haze: _farHaze,
      );
      drawHills(
        canvas,
        _path,
        width: viewWidth,
        baseY: horizon,
        amplitude: 20 * tall,
        frequency: 0.011,
        scroll: scroll,
        paint: _near,
      );
    } else if (theme.backdrop == BackdropKind.ridges) {
      drawHills(
        canvas,
        _path,
        width: viewWidth,
        baseY: horizon,
        amplitude: 78 * tall,
        frequency: 0.005,
        scroll: scroll * 0.35,
        paint: _far,
      );
      canvas.drawRect(
        Rect.fromLTRB(0, horizon - 90 * tall, viewWidth, horizon),
        Paint()..color = _farHaze.withAlpha(60),
      );
      drawHills(
        canvas,
        _path,
        width: viewWidth,
        baseY: horizon,
        amplitude: 54 * tall,
        frequency: 0.008,
        scroll: scroll * 0.6,
        paint: _near,
      );
      drawHills(
        canvas,
        _path,
        width: viewWidth,
        baseY: horizon,
        amplitude: 30 * tall,
        frequency: 0.013,
        scroll: scroll,
        paint: _front,
      );
    } else if (theme.backdrop == BackdropKind.hills) {
      drawHills(
        canvas,
        _path,
        width: viewWidth,
        baseY: horizon,
        amplitude: 46 * tall,
        frequency: 0.007,
        scroll: scroll * 0.6,
        paint: _far,
      );
      drawHills(
        canvas,
        _path,
        width: viewWidth,
        baseY: horizon,
        amplitude: 30 * tall,
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
        width: viewWidth,
        baseY: horizon + 170 * tall * drop,
        height: 110 * tall,
        scroll: scroll * 0.25 + 90 * unit,
        haze: _farHaze,
      );
      drawCityScape(
        canvas,
        width: viewWidth,
        baseY: horizon + 260 * tall * drop,
        height: 170 * tall,
        scroll: scroll * 0.5,
        haze: _nearHaze,
      );
    }
    canvas.drawRect(Rect.fromLTRB(0, horizon, viewWidth, size.y), _ground);
  }
}
