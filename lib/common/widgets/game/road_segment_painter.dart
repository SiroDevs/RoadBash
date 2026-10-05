// Dart imports:
import 'dart:ui';

// Project imports:
import 'road_config.dart';
import 'road_projection.dart';
import 'road_theme.dart';

/// Draws the flat parts of one projected segment: ground, kerb, tarmac and
/// lane markings. Roadside buildings / trees are drawn later by
/// [RoadDecorPainter] so they overlap correctly.
class RoadSegmentPainter {
  RoadSegmentPainter(this.theme)
      : _groundLight = _fill(theme.groundLight),
        _groundDark = _fill(theme.groundDark),
        _edgeLight = _fill(theme.edgeLight),
        _edgeDark = _fill(theme.edgeDark),
        _roadLight = _fill(theme.roadLight),
        _roadDark = _fill(theme.roadDark),
        _lane = _fill(theme.laneColor),
        _center = _fill(theme.centerColor);

  final SceneTheme theme;
  final Paint _groundLight, _groundDark, _edgeLight, _edgeDark;
  final Paint _roadLight, _roadDark, _lane, _center;
  final Path _path = Path();

  static Paint _fill(Color c) => Paint()
    ..color = c
    ..isAntiAlias = false;

  void draw(Canvas c, VisSeg v, double screenW) {
    final light = (v.seg.index ~/ RoadConfig.rumbleLength).isEven;

    c.drawRect(Rect.fromLTRB(0, v.y2, screenW, v.y1 + 1),
        light ? _groundLight : _groundDark);

    // Kerb / shoulder on both sides
    final e1 = v.w1 * 0.14, e2 = v.w2 * 0.14;
    _path.reset();
    _quad(v.x1 - v.w1 - e1, v.y1, v.x1 - v.w1, v.y1, v.x2 - v.w2, v.y2,
        v.x2 - v.w2 - e2, v.y2);
    _quad(v.x1 + v.w1 + e1, v.y1, v.x1 + v.w1, v.y1, v.x2 + v.w2, v.y2,
        v.x2 + v.w2 + e2, v.y2);
    c.drawPath(_path, light ? _edgeLight : _edgeDark);

    // Tarmac
    _path.reset();
    _quad(v.x1 - v.w1, v.y1, v.x1 + v.w1, v.y1, v.x2 + v.w2, v.y2,
        v.x2 - v.w2, v.y2);
    c.drawPath(_path, light ? _roadLight : _roadDark);

    final lanes = theme.lanes;
    final mid = lanes ~/ 2;

    // Dashed lane lines (light bands only)
    if (light) {
      _path.reset();
      for (var i = 1; i < lanes; i++) {
        if (i != mid) _stripe(v, i / lanes, 0, 0.035);
      }
      c.drawPath(_path, _lane);
    }

    // Solid double centre line
    _path.reset();
    _stripe(v, mid / lanes, -0.05, 0.022);
    _stripe(v, mid / lanes, 0.05, 0.022);
    c.drawPath(_path, _center);
  }

  /// Adds a marking at fraction [f] across the road (0 = left edge), moved
  /// sideways by [shift] and [width] wide (both in half-road-widths).
  void _stripe(VisSeg v, double f, double shift, double width) {
    final a = 2 * f - 1 + shift;
    final x1 = v.x1 + v.w1 * a, x2 = v.x2 + v.w2 * a;
    final h1 = v.w1 * width, h2 = v.w2 * width;
    _quad(x1 - h1, v.y1, x1 + h1, v.y1, x2 + h2, v.y2, x2 - h2, v.y2);
  }

  void _quad(double x1, double y1, double x2, double y2, double x3, double y3,
      double x4, double y4) {
    _path
      ..moveTo(x1, y1)
      ..lineTo(x2, y2)
      ..lineTo(x3, y3)
      ..lineTo(x4, y4)
      ..close();
  }
}
