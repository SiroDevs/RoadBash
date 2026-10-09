// Dart imports:
import 'dart:ui';

// Project imports:
import '../utils/paint_utils.dart';
import 'road_config.dart';
import 'road_projection.dart';
import 'road_theme.dart';

/// Verge, shoulder, tarmac and road markings for one projected segment.
///
/// Markings are keyed off the segment index, so they are fixed in the world
/// and stream toward you at a steady rate instead of shimmering. Everything
/// is pre-blended toward the horizon haze, which is what lets the far end of
/// the road dissolve rather than stop dead.
class RoadSegmentPainter {
  RoadSegmentPainter(this.theme)
      : _ground = fogRamp(theme.ground, theme.fog),
        _groundAlt = fogRamp(shade(theme.ground, -0.05), theme.fog),
        _shoulder = fogRamp(theme.shoulder, theme.fog),
        _shoulderAlt = fogRamp(shade(theme.shoulder, -0.06), theme.fog),
        _kerbLight = fogRamp(theme.edgeLight, theme.fog),
        _kerbDark = fogRamp(theme.edgeDark, theme.fog),
        _roadLight = fogRamp(theme.roadLight, theme.fog),
        _roadDark = fogRamp(theme.roadDark, theme.fog),
        _lane = fogRamp(theme.laneColor, theme.fog),
        _center = fogRamp(theme.centerColor, theme.fog);

  final SceneTheme theme;
  final List<Paint> _ground, _groundAlt, _shoulder, _shoulderAlt;
  final List<Paint> _kerbLight, _kerbDark;
  final List<Paint> _roadLight, _roadDark, _lane, _center;
  final Path _path = Path();

  /// Kerb between tarmac and shoulder, in half-road-widths.
  static const double _kerb = 0.032;

  /// Half-widths of the painted lines, in half-road-widths.
  static const double _edgeLine = 0.014;
  static const double _laneLine = 0.015;
  static const double _centreLine = 0.013;
  static const double _centreGap = 0.021;

  /// Markings this far into the haze are a sub-pixel smudge; skipping them
  /// removes two path fills from every distant segment.
  static const double _markingCutoff = 0.86;

  void draw(Canvas c, VisSeg v, double screenW) {
    final i = v.seg.index;
    final f = v.fog;

    c.drawRect(Rect.fromLTRB(0, v.y2, screenW, v.y1 + 1),
        fogged((i ~/ 9).isEven ? _ground : _groundAlt, f));

    const sh = RoadConfig.shoulder;
    _path.reset();
    _band(v, -1 - sh, -1);
    _band(v, 1, 1 + sh);
    c.drawPath(_path, fogged((i ~/ 5).isEven ? _shoulder : _shoulderAlt, f));

    // Low-contrast kerb. It reads as a speed cue without the strobe a bright
    // alternating rumble strip gives at racing speed.
    _path.reset();
    _band(v, -1 - _kerb, -1);
    _band(v, 1, 1 + _kerb);
    c.drawPath(_path,
        fogged((i ~/ RoadConfig.rumbleLength).isEven ? _kerbLight : _kerbDark, f));

    _path.reset();
    _band(v, -1, 1);
    c.drawPath(
        _path,
        fogged(
            (i ~/ RoadConfig.rumbleLength).isEven ? _roadLight : _roadDark, f));

    if (f >= _markingCutoff) return;

    _path.reset();
    _band(v, -1, -1 + _edgeLine * 2);
    _band(v, 1 - _edgeLine * 2, 1);
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
    _band(v, -_centreGap - _centreLine, -_centreGap + _centreLine);
    _band(v, _centreGap - _centreLine, _centreGap + _centreLine);
    c.drawPath(_path, fogged(_center, f));
  }

  /// Adds the strip between lateral offsets [a] and [b], measured in
  /// half-road-widths from the centre line.
  void _band(VisSeg v, double a, double b) {
    addQuad(
      _path,
      v.x1 + v.w1 * a, v.y1,
      v.x1 + v.w1 * b, v.y1,
      v.x2 + v.w2 * b, v.y2,
      v.x2 + v.w2 * a, v.y2,
    );
  }
}
