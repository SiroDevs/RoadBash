// Dart imports:
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../config/road_config.dart';
import '../road_projection.dart';
import '../scene_theme.dart';
import '../track/road_section.dart';
import 'road_surface_palette.dart';

class RoadSegmentPainter {
  RoadSegmentPainter(this.theme)
    : _shoulder = fogRamp(theme.shoulder, theme.fog),
      _shoulderAlt = fogRamp(shade(theme.shoulder, -0.06), theme.fog),
      _kerbLight = fogRamp(theme.edgeLight, theme.fog),
      _kerbDark = fogRamp(theme.edgeDark, theme.fog),
      _roadLight = fogRamp(theme.roadLight, theme.fog),
      _roadDark = fogRamp(theme.roadDark, theme.fog),
      _lane = fogRamp(theme.laneColor, theme.fog),
      _center = fogRamp(theme.centerColor, theme.fog),
      _palette = RoadSurfacePalette(theme);

  final SceneTheme theme;
  final List<Paint> _shoulder, _shoulderAlt;
  final List<Paint> _kerbLight, _kerbDark;
  final List<Paint> _roadLight, _roadDark, _lane, _center;
  final RoadSurfacePalette _palette;
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
    if (theme.dualCarriageway) _verges(c, v, f);
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
        if (!theme.dualCarriageway && n == lanes ~/ 2) continue;
        final a = 2 * n / lanes - 1;
        _band(v, a - _laneLine, a + _laneLine);
      }
    }
    c.drawPath(_path, fogged(_lane, f));
    if (theme.dualCarriageway) return;

    _path.reset();
    _band(v, -_centreGap - _yellowLine, -_centreGap + _yellowLine);
    _band(v, _centreGap - _yellowLine, _centreGap + _yellowLine);
    c.drawPath(_path, fogged(_center, f));
  }

  static const double _verge = 1.1;
  static const double _median = 0.42;
  static const double _opposite = 2.0;
  static const double _rail = 0.03;

  void _verges(Canvas c, VisionSeg v, double f) {
    final section = v.seg.section;
    const sh = RoadConfig.shoulder;
    final f0 = fogged(_palette.verge(section.left), f);
    _path.reset();
    _band(v, -1 - sh - _verge, -1 - sh);
    c.drawPath(_path, f0);

    var edge = 1 + sh;
    if (section.hasOpposite) {
      _paintMedian(c, v, f, edge, section.median);
      edge += _median;
      _paintOpposite(c, v, f, edge);
      edge += _opposite + sh;
    }
    _path.reset();
    _band(v, edge, edge + _verge);
    c.drawPath(_path, fogged(_palette.verge(section.right), f));

    if (section.railLeft && f < _markingCutoff) {
      _path.reset();
      _band(v, -1 - sh - 0.08, -1 - sh - 0.08 + _rail * 2);
      c.drawPath(_path, fogged(_palette.rail, f));
    }
  }

  void _paintMedian(Canvas c, VisionSeg v, double f, double a, MedianKind kind) {
    _path.reset();
    _band(v, a, a + _median);
    c.drawPath(_path, fogged(_palette.median(kind), f));
    if (f >= _markingCutoff || kind == MedianKind.none) return;
    _path.reset();
    if (kind == MedianKind.barrier) {
      _band(v, a + _median * 0.35, a + _median * 0.65);
      c.drawPath(_path, fogged(_palette.rail, f));
      return;
    }
    _band(v, a + 0.02, a + 0.02 + _rail);
    _band(v, a + _median - 0.02 - _rail, a + _median - 0.02);
    c.drawPath(_path, fogged(_palette.rail, f));
  }

  void _paintOpposite(Canvas c, VisionSeg v, double f, double a) {
    final i = v.seg.index;
    _path.reset();
    _band(v, a, a + _opposite);
    c.drawPath(
      _path,
      fogged((i ~/ RoadConfig.rumbleLength).isEven ? _roadLight : _roadDark, f),
    );
    _path.reset();
    _band(v, a + _opposite, a + _opposite + RoadConfig.shoulder);
    c.drawPath(_path, fogged(_shoulder, f));
    if (f >= _markingCutoff) return;
    _path.reset();
    _band(v, a, a + _whiteLine * 2);
    _band(v, a + _opposite - _whiteLine * 2, a + _opposite);
    if ((i ~/ 3).isEven) {
      for (var n = 1; n < theme.lanes; n++) {
        final u = a + _opposite * n / theme.lanes;
        _band(v, u - _laneLine, u + _laneLine);
      }
    }
    c.drawPath(_path, fogged(_lane, f));
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
