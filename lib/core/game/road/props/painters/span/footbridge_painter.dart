// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../utils/paint_utils.dart';
import '../../../road_projection.dart';
import '../../../scene/scene_theme.dart';
import '../../prop.dart';

class FootbridgePainter {
  FootbridgePainter(SceneTheme theme)
      : _concrete = fogRamp(theme.bridgeColor, theme.fog),
        _underside = fogRamp(shade(theme.bridgeColor, -0.32), theme.fog),
        _rail = fogRamp(theme.bridgeRail, theme.fog),
        _post = fogRamp(theme.poleColor, theme.fog);

  final List<Paint> _concrete, _underside, _rail, _post;
  final Path _path = Path();

  void draw(Canvas c, VisionSeg v, Prop p, double l, double r) {
    final k = v.k1, y = v.y1, f = v.fog;
    final top = y - p.height * k;
    final deck = top + 170 * k;
    final pw = math.max(1.0, 120 * k);
    final stair = 1500 * k;

    // Stairs
    _path.reset();
    _path
      ..moveTo(l, deck)
      ..lineTo(l - stair, y)
      ..lineTo(l, y)
      ..close()
      ..moveTo(r, deck)
      ..lineTo(r + stair, y)
      ..lineTo(r, y)
      ..close();
    c.drawPath(_path, fogged(_underside, f));

    // Deck
    c.drawRect(Rect.fromLTRB(l - pw, deck, l + pw, y + 1), fogged(_post, f));
    c.drawRect(Rect.fromLTRB(r - pw, deck, r + pw, y + 1), fogged(_post, f));
    c.drawRect(Rect.fromLTRB(l - pw * 1.6, top, r + pw * 1.6, deck),
        fogged(_concrete, f));

    // Railing
    final railTop = top - 250 * k;
    final bar = math.max(1.0, 36 * k);
    c.drawRect(Rect.fromLTRB(l - pw * 1.6, railTop, r + pw * 1.6, railTop + bar),
        fogged(_rail, f));
    final posts = ((r - l) / math.max(6.0, 300 * k)).floor().clamp(2, 28);
    _path.reset();
    for (var n = 0; n <= posts; n++) {
      final x = l + (r - l) * n / posts;
      _path.addRect(Rect.fromLTRB(x - bar * 0.5, railTop, x + bar * 0.5, top));
    }
    c.drawPath(_path, fogged(_rail, f));
  }
}
