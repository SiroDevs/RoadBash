// Dart imports:
import 'dart:ui';

// Project imports:
import '../utils/paint_utils.dart';
import 'road_config.dart';
import 'road_projection.dart';
import 'road_theme.dart';

/// Ground, kerb, tarmac and lane markings of one projected segment.
class RoadSegmentPainter {
  RoadSegmentPainter(this.theme)
      : _groundLight = fillPaint(theme.groundLight, antiAlias: false),
        _groundDark = fillPaint(theme.groundDark, antiAlias: false),
        _edgeLight = fillPaint(theme.edgeLight, antiAlias: false),
        _edgeDark = fillPaint(theme.edgeDark, antiAlias: false),
        _roadLight = fillPaint(theme.roadLight, antiAlias: false),
        _roadDark = fillPaint(theme.roadDark, antiAlias: false),
        _lane = fillPaint(theme.laneColor, antiAlias: false),
        _center = fillPaint(theme.centerColor, antiAlias: false);

  final SceneTheme theme;
  final Paint _groundLight, _groundDark, _edgeLight, _edgeDark;
  final Paint _roadLight, _roadDark, _lane, _center;
  final Path _path = Path();

  void draw(Canvas c, VisSeg v, double screenW) {
    final light = (v.seg.index ~/ RoadConfig.rumbleLength).isEven;

    c.drawRect(Rect.fromLTRB(0, v.y2, screenW, v.y1 + 1),
        light ? _groundLight : _groundDark);

    final e1 = v.w1 * 0.14, e2 = v.w2 * 0.14;
    _path.reset();
    addQuad(_path, v.x1 - v.w1 - e1, v.y1, v.x1 - v.w1, v.y1, v.x2 - v.w2,
        v.y2, v.x2 - v.w2 - e2, v.y2);
    addQuad(_path, v.x1 + v.w1 + e1, v.y1, v.x1 + v.w1, v.y1, v.x2 + v.w2,
        v.y2, v.x2 + v.w2 + e2, v.y2);
    c.drawPath(_path, light ? _edgeLight : _edgeDark);

    drawQuad(c, _path, light ? _roadLight : _roadDark, v.x1 - v.w1, v.y1,
        v.x1 + v.w1, v.y1, v.x2 + v.w2, v.y2, v.x2 - v.w2, v.y2);

    final lanes = theme.lanes;
    final mid = lanes ~/ 2;

    if (light) {
      _path.reset();
      for (var i = 1; i < lanes; i++) {
        if (i != mid) _stripe(v, i / lanes, 0, 0.035);
      }
      c.drawPath(_path, _lane);
    }

    _path.reset();
    _stripe(v, mid / lanes, -0.05, 0.022);
    _stripe(v, mid / lanes, 0.05, 0.022);
    c.drawPath(_path, _center);
  }

  /// Adds a marking at fraction [f] across the road (0 = left edge), moved
  /// sideways by [shift] and [width] wide, both in half-road-widths.
  void _stripe(VisSeg v, double f, double shift, double width) {
    final a = 2 * f - 1 + shift;
    final x1 = v.x1 + v.w1 * a, x2 = v.x2 + v.w2 * a;
    final h1 = v.w1 * width, h2 = v.w2 * width;
    addQuad(_path, x1 - h1, v.y1, x1 + h1, v.y1, x2 + h2, v.y2, x2 - h2, v.y2);
  }
}
