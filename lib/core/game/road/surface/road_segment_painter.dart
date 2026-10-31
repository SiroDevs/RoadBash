// Dart imports:
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../config/road_config.dart';
import '../road_projection.dart';
import '../scene_theme.dart';
import '../track/road_section.dart';
import 'road_surface_palette.dart';
import 'terrain_painter.dart';

/// Paints the road surface, verges and markings.
class RoadSegmentPainter {
  RoadSegmentPainter(this.theme)
    : _shoulder = fogRamp(theme.shoulder, theme.fog),
      _shoulderAlt = fogRamp(shade(theme.shoulder, -0.06), theme.fog),
      _kerbLight = fogRamp(theme.edgeLight, theme.fog),
      _kerbDark = fogRamp(theme.edgeDark, theme.fog),
      _roadLight = fogRamp(theme.roadLight, theme.fog),
      _roadDark = fogRamp(theme.roadDark, theme.fog),
      _rut = fogRamp(theme.rutColor, theme.fog),
      _ridge = fogRamp(shade(theme.roadLight, 0.08), theme.fog),
      _lane = fogRamp(theme.laneColor, theme.fog),
      _center = fogRamp(theme.centerColor, theme.fog),
      _palette = RoadSurfacePalette(theme),
      _terrain = TerrainPainter(theme);

  final SceneTheme theme;
  final List<Paint> _shoulder, _shoulderAlt;
  final List<Paint> _kerbLight, _kerbDark;
  final List<Paint> _roadLight, _roadDark, _lane, _center, _rut, _ridge;
  final RoadSurfacePalette _palette;
  final TerrainPainter _terrain;
  final Path _path = Path();

  static const double _kerb = 0.032;

  static const double _whiteLine = 0.014;
  static const double _laneLine = 0.015;
  static const double _yellowLine = 0.013;
  static const double _centreGap = 0.021;

  static const double _markingCutoff = 0.86;

  /// Draws one road segment.
  void draw(Canvas canvas, VisionSeg vision, double screenW) {
    final segmentIndex = vision.seg.index;
    final fog = vision.fog;

    const sh = RoadConfig.shoulder;
    if (theme.dualCarriageway) _verges(canvas, vision, fog);
    _path.reset();
    _band(vision, -1 - sh, -1);
    _band(vision, 1, 1 + sh);
    canvas.drawPath(_path, fogged((segmentIndex ~/ 5).isEven ? _shoulder : _shoulderAlt, fog));

    _path.reset();
    _band(vision, -1 - _kerb, -1);
    _band(vision, 1, 1 + _kerb);
    canvas.drawPath(
      _path,
      fogged((segmentIndex ~/ RoadConfig.rumbleLength).isEven ? _kerbLight : _kerbDark, fog),
    );

    _path.reset();
    _band(vision, -1, 1);
    canvas.drawPath(
      _path,
      fogged((segmentIndex ~/ RoadConfig.rumbleLength).isEven ? _roadLight : _roadDark, fog),
    );

    if (theme.ruts) _ruts(canvas, vision, fog);
    _terrain.draw(canvas, vision, fog);
    if (!theme.markings || fog >= _markingCutoff) return;

    _path.reset();
    _band(vision, -1, -1 + _whiteLine * 2);
    _band(vision, 1 - _whiteLine * 2, 1);
    if ((segmentIndex ~/ 3).isEven) {
      final lanes = theme.lanes;
      for (var n = 1; n < lanes; n++) {
        if (!theme.dualCarriageway && n == lanes ~/ 2) continue;
        final offset = 2 * n / lanes - 1;
        _band(vision, offset - _laneLine, offset + _laneLine);
      }
    }
    canvas.drawPath(_path, fogged(_lane, fog));
    if (theme.dualCarriageway) return;

    _path.reset();
    _band(vision, -_centreGap - _yellowLine, -_centreGap + _yellowLine);
    _band(vision, _centreGap - _yellowLine, _centreGap + _yellowLine);
    canvas.drawPath(_path, fogged(_center, fog));
  }

  /// Two wheel ruts with a raised ridge between them, broken up along the
  /// road so the surface doesn't read as painted stripes.
  void _ruts(Canvas canvas, VisionSeg vision, double fog) {
    final segmentIndex = vision.seg.index;
    _path.reset();
    _band(vision, -0.62, -0.34);
    _band(vision, 0.34, 0.62);
    canvas.drawPath(_path, fogged(_rut, fog));
    if ((segmentIndex ~/ 7).isEven) {
      _path.reset();
      _band(vision, -0.08, 0.08);
      canvas.drawPath(_path, fogged(_ridge, fog));
    }
  }

  static const double _verge = 1.1;
  static const double _median = RoadConfig.medianWidth;
  static const double _opposite = RoadConfig.oppositeWidth;
  static const double _rail = 0.03;

  /// Draws the verges on both sides.
  void _verges(Canvas canvas, VisionSeg vision, double fog) {
    final section = vision.seg.section;
    const sh = RoadConfig.shoulder;
    final f0 = fogged(_palette.verge(section.left), fog);
    _path.reset();
    _band(vision, -1 - sh - _verge, -1 - sh);
    canvas.drawPath(_path, f0);

    var edge = 1 + sh;
    if (section.hasOpposite) {
      _paintMedian(canvas, vision, fog, edge, section.median);
      edge += _median;
      _paintOpposite(canvas, vision, fog, edge);
      edge += _opposite + sh;
    }
    _path.reset();
    _band(vision, edge, edge + _verge);
    canvas.drawPath(_path, fogged(_palette.verge(section.right), fog));

    if (section.railLeft && fog < _markingCutoff) {
      _path.reset();
      _band(vision, -1 - sh - 0.08, -1 - sh - 0.08 + _rail * 2);
      canvas.drawPath(_path, fogged(_palette.rail, fog));
    }
  }

  /// Draws the median strip.
  void _paintMedian(Canvas canvas, VisionSeg vision, double fog, double offset, MedianKind kind) {
    _path.reset();
    _band(vision, offset, offset + _median);
    canvas.drawPath(_path, fogged(_palette.median(kind), fog));
    // Guardrails are standing props (see GuardrailPainter); only the
    // concrete barrier is still painted flat on the surface.
    if (fog >= _markingCutoff || kind != MedianKind.barrier) return;
    _path.reset();
    _band(vision, offset + _median * 0.35, offset + _median * 0.65);
    canvas.drawPath(_path, fogged(_palette.rail, fog));
  }

  /// Draws the opposite carriageway.
  void _paintOpposite(Canvas canvas, VisionSeg vision, double fog, double offset) {
    final segmentIndex = vision.seg.index;
    _path.reset();
    _band(vision, offset, offset + _opposite);
    canvas.drawPath(
      _path,
      fogged((segmentIndex ~/ RoadConfig.rumbleLength).isEven ? _roadLight : _roadDark, fog),
    );
    _path.reset();
    _band(vision, offset + _opposite, offset + _opposite + RoadConfig.shoulder);
    canvas.drawPath(_path, fogged(_shoulder, fog));
    if (fog >= _markingCutoff) return;
    _path.reset();
    _band(vision, offset, offset + _whiteLine * 2);
    _band(vision, offset + _opposite - _whiteLine * 2, offset + _opposite);
    if ((segmentIndex ~/ 3).isEven) {
      for (var n = 1; n < theme.lanes; n++) {
        final position = offset + _opposite * n / theme.lanes;
        _band(vision, position - _laneLine, position + _laneLine);
      }
    }
    canvas.drawPath(_path, fogged(_lane, fog));
  }

  /// Adds a quad between two lateral offsets.
  void _band(VisionSeg vision, double offset, double outer) {
    addQuad(
      _path,
      vision.x1 + vision.w1 * offset,
      vision.y1,
      vision.x1 + vision.w1 * outer,
      vision.y1,
      vision.x2 + vision.w2 * outer,
      vision.y2,
      vision.x2 + vision.w2 * offset,
      vision.y2,
    );
  }
}