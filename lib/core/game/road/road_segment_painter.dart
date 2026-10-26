// Dart imports:
import 'dart:ui';

// Project imports:
import '../utils/paint_utils.dart';
import 'config/road_config.dart';
import 'road_projection.dart';
import 'scene/scene_theme.dart';

class RoadSegmentPainter {
  RoadSegmentPainter(this.theme)
    : _shoulder = fogRamp(theme.shoulder, theme.fog),
      _shoulderAlt = fogRamp(shade(theme.shoulder, -0.06), theme.fog),
      _kerbLight = fogRamp(theme.edgeLight, theme.fog),
      _kerbDark = fogRamp(theme.edgeDark, theme.fog),
      _roadLight = fogRamp(theme.roadLight, theme.fog),
      _roadDark = fogRamp(theme.roadDark, theme.fog),
      _lane = fogRamp(theme.laneColor, theme.fog),
      _center = fogRamp(theme.centerColor, theme.fog);

  final SceneTheme theme;
  final List<Paint> _shoulder, _shoulderAlt;
  final List<Paint> _kerbLight, _kerbDark;
  final List<Paint> _roadLight, _roadDark, _lane, _center;
  final Path _path = Path();

  static const double _kerb = 0.032;

  static const double _whiteLine = 0.014;
  static const double _laneLine = 0.015;
  static const double _yellowLine = 0.013;
  static const double _centreGap = 0.021;

  static const double _markingCutoff = 0.86;

  void draw(Canvas c, VisionSeg v, double screenW) {
    final i = v.seg.index;
    final f = v.fog;

    const sh = RoadConfig.shoulder;
    _path.reset();
    _band(v, -1 - sh, -1);
    _band(v, 1, 1 + sh);
    c.drawPath(_path, fogged((i ~/ 5).isEven ? _shoulder : _shoulderAlt, f));

    // Kerb
    _path.reset();
    _band(v, -1 - _kerb, -1);
    _band(v, 1, 1 + _kerb);
    c.drawPath(
      _path,
      fogged((i ~/ RoadConfig.rumbleLength).isEven ? _kerbLight : _kerbDark, f),
    );

    _path.reset();
    _band(v, -1, 1);
    c.drawPath(
      _path,
      fogged((i ~/ RoadConfig.rumbleLength).isEven ? _roadLight : _roadDark, f),
    );

    if (f >= _markingCutoff) return;

    _path.reset();
    _band(v, -1, -1 + _whiteLine * 2);
    _band(v, 1 - _whiteLine * 2, 1);
    if ((i ~/ 3).isEven) {
      final lanes = theme.lanes;
      for (var n = 1; n < lanes; n++) {
        if (n == lanes ~/ 2) continue;
        final a = 2 * n / lanes - 1;
        _band(v, a - _laneLine, a + _laneLine);
      }
    }
    c.drawPath(_path, fogged(_lane, f));

    _path.reset();
    _band(v, -_centreGap - _yellowLine, -_centreGap + _yellowLine);
    _band(v, _centreGap - _yellowLine, _centreGap + _yellowLine);
    c.drawPath(_path, fogged(_center, f));
  }

  void _band(VisionSeg v, double a, double b) {
    addQuad(
      _path,
      v.x1 + v.w1 * a,
      v.y1,
      v.x1 + v.w1 * b,
      v.y1,
      v.x2 + v.w2 * b,
      v.y2,
      v.x2 + v.w2 * a,
      v.y2,
    );
  }
}
