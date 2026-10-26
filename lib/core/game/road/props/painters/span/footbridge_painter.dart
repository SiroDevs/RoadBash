// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../utils/paint_utils.dart';
import '../../../projection/road_projection.dart';
import '../../../scene/scene_theme.dart';
import '../../prop.dart';

class FootbridgePainter {
  FootbridgePainter(SceneTheme theme)
      : _frame = [for (final c in _colors) fogRamp(c, theme.fog)],
        _dark = [for (final c in _colors) fogRamp(shade(c, -0.35), theme.fog)],
        _mesh = [
          for (final c in _colors)
            fogRamp(c.withValues(alpha: 0.42), theme.fog, antiAlias: true),
        ];

  static const List<Color> _colors = [
    Color(0xFF3E6FA3),
    Color(0xFF3F7F57),
    Color(0xFFD8B42A),
    Color(0xFF9C9E99),
  ];

  static const int _arch = 2;

  final List<List<Paint>> _frame, _dark, _mesh;
  final Path _path = Path();

  void draw(Canvas c, VisionSeg v, Prop p, double l, double r) {
    final s = p.tint % _frame.length;
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
    c.drawPath(_path, fogged(_dark[s], f));

    // Deck
    c.drawRect(Rect.fromLTRB(l - pw, deck, l + pw, y + 1), fogged(_dark[s], f));
    c.drawRect(Rect.fromLTRB(r - pw, deck, r + pw, y + 1), fogged(_dark[s], f));
    c.drawRect(Rect.fromLTRB(l - pw * 1.6, top, r + pw * 1.6, deck),
        fogged(_frame[s], f));

    // Railing
    final railTop = top - 250 * k;
    final bar = math.max(1.0, 36 * k);
    c.drawRect(Rect.fromLTRB(l - pw * 1.6, railTop, r + pw * 1.6, railTop + bar),
        fogged(_frame[s], f));
    final posts = ((r - l) / math.max(6.0, 300 * k)).floor().clamp(2, 28);
    _path.reset();
    for (var n = 0; n <= posts; n++) {
      final x = l + (r - l) * n / posts;
      _path.addRect(Rect.fromLTRB(x - bar * 0.5, railTop, x + bar * 0.5, top));
    }
    c.drawPath(_path, fogged(_frame[s], f));

    if (s == _arch) {
      _archSpan(c, f, s, l, r, railTop, k);
    } else {
      // Covered walkway
      final roof = railTop - 330 * k;
      c.drawRect(Rect.fromLTRB(l - pw * 1.6, roof, r + pw * 1.6, railTop),
          fogged(_mesh[s], f));
      c.drawRect(Rect.fromLTRB(l - pw * 2, roof - bar * 1.4, r + pw * 2, roof),
          fogged(_dark[s], f));
    }
  }

  void _archSpan(Canvas c, double f, int s, double l, double r, double base,
      double k) {
    final rise = 1150 * k;
    final t = math.max(1.2, 70 * k);
    final mid = (l + r) / 2;
    _path.reset();
    const steps = 10;
    for (var n = 0; n <= steps; n++) {
      final u = n / steps;
      final x = l + (r - l) * u;
      final yy = base - rise * 4 * u * (1 - u);
      n == 0 ? _path.moveTo(x, yy) : _path.lineTo(x, yy);
    }
    for (var n = steps; n >= 0; n--) {
      final u = n / steps;
      final x = l + (r - l) * u;
      _path.lineTo(x, base - rise * 4 * u * (1 - u) + t);
    }
    _path.close();
    c.drawPath(_path, fogged(_frame[s], f));
    c.drawRect(Rect.fromLTRB(mid - t * 0.5, base - rise, mid + t * 0.5, base),
        fogged(_frame[s], f));
  }
}
