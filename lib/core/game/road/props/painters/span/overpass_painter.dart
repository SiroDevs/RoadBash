// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../utils/paint_utils.dart';
import '../../../road_projection.dart';
import '../../../scene_theme.dart';
import '../../prop.dart';

class OverpassPainter {
  OverpassPainter(SceneTheme theme)
      : _concrete = fogRamp(theme.bridgeColor, theme.fog),
        _underside = fogRamp(shade(theme.bridgeColor, -0.32), theme.fog),
        _rail = fogRamp(theme.bridgeRail, theme.fog),
        _yellow = fogRamp(const Color(0xFFE2B91E), theme.fog),
        _earth = fogRamp(const Color(0xFF9A6A47), theme.fog);

  final List<Paint> _concrete, _underside, _rail, _yellow, _earth;
  final Path _path = Path();

  static const double _rampDrop = 1200;
  static const double _rampLen = 5.0;
  static const int _steps = 14;

  /// [l]..[r] is the whole deck (past both screen edges); [spanL]..[spanR] is
  /// the level stretch directly over the highway. Outside it the crossing
  /// road eases down towards the ground on an embankment, so it rises
  /// gradually as it approaches the highway and drops gently on leaving.
  void draw(
    Canvas canvas,
    VisionSeg vision,
    Prop prop,
    double left,
    double right, {
    double? spanL,
    double? spanR,
    double? medianPier,
    double? farPier,
  }) {
    final scale = vision.k1, groundY = vision.y1, fog = vision.fog;
    final top = groundY - prop.height * scale;
    final slab = 560 * scale;
    final pier = math.max(1.0, 210 * scale);
    final sl = spanL ?? left, sr = spanR ?? right;
    final unit = math.max(vision.w1, 1e-6);

    double drop(double posX) {
      final ramp = posX < sl ? (sl - posX) / unit : (posX > sr ? (posX - sr) / unit : 0.0);
      final ratio = (ramp / _rampLen).clamp(0.0, 1.0);
      return _rampDrop * scale * ratio * ratio * (3 - 2 * ratio);
    }

    // x positions along the deck, dense on the two ramps.
    final xs = <double>[
      for (var n = 0; n < _steps; n++) left + (sl - left) * n / _steps,
      sl,
      sr,
      for (var n = 1; n <= _steps; n++) sr + (right - sr) * n / _steps,
    ];

    // Ramp embankments: earth from the underside of the deck to the ground.
    for (final wing in [
      xs.where((x) => x <= sl).toList(),
      xs.where((x) => x >= sr).toList(),
    ]) {
      if (wing.length < 2) continue;
      _path.reset();
      _path.moveTo(wing.first, groundY);
      for (final x in wing) {
        _path.lineTo(x, top + drop(x) + slab);
      }
      _path.lineTo(wing.last, groundY);
      _path.close();
      canvas.drawPath(_path, fogged(_earth, fog));
    }

    // Piers
    // Near-side pier, an optional pier in the median, and the far-side pier
    // (just past the shoulder of the opposite carriageway when it crosses the
    // whole highway).
    for (final x in [
      vision.x1 - vision.w1 * 1.3,
      if (medianPier != null) medianPier,
      farPier ?? vision.x1 + vision.w1 * 1.3,
    ]) {
      canvas.drawRect(Rect.fromLTRB(x - pier, top + slab, x + pier, groundY + 1),
          fogged(_underside, fog));
    }

    // Deck, following the ramp profile.
    void band(double start, double end, List<Paint> ramp) {
      _path.reset();
      _path.moveTo(xs.first, top + drop(xs.first) + start);
      for (final x in xs) {
        _path.lineTo(x, top + drop(x) + start);
      }
      for (final x in xs.reversed) {
        _path.lineTo(x, top + drop(x) + end);
      }
      _path.close();
      canvas.drawPath(_path, fogged(ramp, fog));
    }

    band(0, slab, _concrete);
    band(slab * 0.72, slab, _underside);
    band(-130 * scale, 0, prop.tint == 1 ? _yellow : _rail);
  }
}