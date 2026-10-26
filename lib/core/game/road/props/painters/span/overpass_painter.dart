// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../utils/paint_utils.dart';
import '../../../projection/road_projection.dart';
import '../../../scene/scene_theme.dart';
import '../../prop.dart';

class OverpassPainter {
  OverpassPainter(SceneTheme theme)
      : _concrete = fogRamp(theme.bridgeColor, theme.fog),
        _underside = fogRamp(shade(theme.bridgeColor, -0.32), theme.fog),
        _rail = fogRamp(theme.bridgeRail, theme.fog);

  final List<Paint> _concrete, _underside, _rail;

  void draw(Canvas c, VisionSeg v, Prop p, double l, double r) {
    final k = v.k1, y = v.y1, f = v.fog;
    final top = y - p.height * k;
    final slab = 560 * k;
    final pier = math.max(1.0, 210 * k);

    // Piers
    for (final x in [v.x1 - v.w1 * 1.3, v.x1 + v.w1 * 1.3]) {
      c.drawRect(Rect.fromLTRB(x - pier, top + slab, x + pier, y + 1),
          fogged(_underside, f));
    }

    // Deck
    c.drawRect(Rect.fromLTRB(l, top, r, top + slab), fogged(_concrete, f));
    c.drawRect(Rect.fromLTRB(l, top + slab * 0.72, r, top + slab),
        fogged(_underside, f));
    c.drawRect(
        Rect.fromLTRB(l, top - 130 * k, r, top), fogged(_rail, f));
  }
}
