// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../utils/paint_utils.dart';
import '../../../road_projection.dart';
import '../../../scene_theme.dart';
import '../../prop.dart';
import '../../sign_panel.dart';
import '../sign_text.dart';

class GantryPainter {
  GantryPainter(SceneTheme theme)
      : _steel = fogRamp(theme.poleColor, theme.fog),
        _concrete = fogRamp(const Color(0xFF8E908F), theme.fog),
        _panel = fogRamp(theme.signGreen, theme.fog),
        _blue = fogRamp(const Color(0xFF1F5FA8), theme.fog),
        _edge = fogRamp(const Color(0xFFF2F2EC), theme.fog),
        _board = fogRamp(const Color(0xFFE6B422), theme.fog),
        _ink = fogRamp(const Color(0xFF23262B), theme.fog);

  final List<Paint> _steel, _concrete, _panel, _blue, _edge, _board, _ink;
  final Path _path = Path();

  static const double _textCutoff = 0.55;
  static const List<SignPanel> _blank = [
    SignPanel([]),
    SignPanel([]),
    SignPanel([]),
  ];

  void draw(Canvas c, VisionSeg v, Prop p, double l, double r) {
    final k = v.k1, y = v.y1, f = v.fog;
    final top = y - p.height * k;
    final depth = 420 * k;

    _truss(c, f, l, r, top, depth, k);
    for (var n = 0; n < 2; n++) {
      final board = n < p.boards.length ? p.boards[n] : null;
      _tower(c, f, n == 0 ? l : r, y, top + depth * 0.5, k, board);
    }
    _panels(c, v, p, top + depth * 0.62, l, r, k);
  }

  void _bar(Canvas c, double f, List<Paint> ramp, double x1, double y1,
      double x2, double y2, double th) {
    drawQuad(c, _path, fogged(ramp, f), x1 - th / 2, y1, x2 - th / 2, y2,
        x2 + th / 2, y2, x1 + th / 2, y1);
  }

  void _truss(Canvas c, double f, double l, double r, double top, double depth,
      double k) {
    final th = math.max(1.0, 38 * k);
    final paint = fogged(_steel, f);
    final lo = l - 90 * k, hi = r + 90 * k;
    // Truss chords
    c.drawRect(Rect.fromLTRB(lo, top, hi, top + th), paint);
    c.drawRect(Rect.fromLTRB(lo, top + depth - th, hi, top + depth), paint);
    if (depth < 6) return;
    // Truss bracing
    final bays = ((hi - lo) / (depth * 1.1)).round().clamp(6, 22);
    final step = (hi - lo) / bays;
    for (var i = 0; i < bays; i++) {
      final x0 = lo + step * i, x1 = x0 + step;
      _bar(c, f, _steel, x0, i.isEven ? top + depth - th : top + th, x1,
          i.isEven ? top + th : top + depth - th, th * 0.7);
      _bar(c, f, _steel, x0, top + th, x0, top + depth - th, th * 0.7);
    }
  }

  void _tower(Canvas c, double f, double cx, double y, double boardTop,
      double k, SignBoard? board) {
    final bw = 560 * k, bh = 1700 * k;
    final bottom = boardTop + bh;
    final lw = math.max(1.0, 45 * k);

    // Tower legs
    _bar(c, f, _steel, cx - 210 * k, bottom, cx - 330 * k, y, lw);
    _bar(c, f, _steel, cx + 210 * k, bottom, cx + 330 * k, y, lw);
    for (final t in const [0.34, 0.68]) {
      final hx = (210 + 120 * t) * k;
      final ty = bottom + (y - bottom) * t;
      c.drawRect(Rect.fromLTRB(cx - hx, ty - lw / 2, cx + hx, ty + lw / 2),
          fogged(_steel, f));
    }
    _bar(c, f, _steel, cx - 210 * k, bottom, cx + 270 * k, bottom + (y - bottom) * 0.5, lw * 0.8);
    _bar(c, f, _steel, cx + 210 * k, bottom, cx - 270 * k, bottom + (y - bottom) * 0.5, lw * 0.8);
    c.drawRect(Rect.fromLTRB(cx - 420 * k, y - 70 * k, cx + 420 * k, y + 20 * k),
        fogged(_concrete, f));

    // Yellow board
    final rect = Rect.fromLTRB(cx - bw / 2, boardTop, cx + bw / 2, bottom);
    c.drawRect(rect.inflate(math.max(1.0, 24 * k)), fogged(_ink, f));
    c.drawRect(rect, fogged(_board, f));
    c.drawOval(
        Rect.fromCenter(
            center: Offset(cx, boardTop + bh * 0.06),
            width: bw * 0.5,
            height: bh * 0.05),
        fogged(_edge, f));
    if (f < _textCutoff && rect.height > 18 && board != null) {
      SignText.drawVertical(
        c,
        Rect.fromLTRB(rect.left + bw * 0.06, boardTop + bh * 0.12,
            rect.right - bw * 0.06, boardTop + bh * 0.78),
        board.columns,
      );
    }

    // Badge
    final badge = Rect.fromLTRB(rect.left + bw * 0.12, boardTop + bh * 0.83,
        rect.right - bw * 0.12, boardTop + bh * 0.95);
    c.drawRect(badge, fogged(_edge, f));
    c.drawRect(badge.deflate(bw * 0.03), fogged(_blue, f));
    if (f < _textCutoff && badge.height > 8) {
      SignText.draw(c, badge.deflate(bw * 0.04), const ['pelican']);
    }
  }

  void _panels(Canvas c, VisionSeg v, Prop p, double panelTop, double l,
      double r, double k) {
    final f = v.fog;
    final panels = p.signs.isEmpty ? _blank : p.signs;
    final n = panels.length;
    final span = (r - l) * (n == 1 ? 0.42 : (n == 2 ? 0.78 : 0.92));
    final gap = span * 0.03;
    var weights = 0.0;
    for (final s in panels) {
      weights += s.weight;
    }
    final usable = span - gap * (n - 1);
    final h = 1150 * k;
    final edge = math.max(1.0, 26 * k);
    var x = v.x1 - span / 2;

    for (final data in panels) {
      final w = usable * data.weight / weights;
      final rect = Rect.fromLTWH(x, panelTop, w, h);
      c.drawRect(rect.inflate(edge), fogged(_edge, f));
      c.drawRect(rect, fogged(data.blue ? _blue : _panel, f));
      if (data.tab != null) _tab(c, f, rect, data.tab!, edge, h);
      if (f < _textCutoff && h > 16) {
        if (data.rows.isEmpty) {
          _bars(c, f, rect);
        } else {
          SignText.drawPanel(c, rect, data);
        }
      }
      x += w + gap;
    }
  }

  void _tab(Canvas c, double f, Rect panel, String label, double edge,
      double h) {
    final width = panel.width * (0.14 + 0.05 * label.length).clamp(0.25, 0.6);
    final height = h * 0.2;
    final tab = Rect.fromLTWH(panel.left + panel.width * 0.03,
        panel.top - edge - height, width, height);
    c.drawRect(tab.inflate(edge * 0.8), fogged(_edge, f));
    c.drawRect(tab, fogged(_panel, f));
    if (f < _textCutoff && height > 8) {
      SignText.draw(c, tab.deflate(height * 0.1), [label]);
    }
  }

  void _bars(Canvas c, double f, Rect panel) {
    for (var line = 0; line < 3; line++) {
      final ty = panel.top + panel.height * (0.16 + line * 0.27);
      c.drawRect(
        Rect.fromLTRB(panel.left + panel.width * 0.12, ty,
            panel.right - panel.width * (0.12 + (line == 2 ? 0.3 : 0)),
            ty + panel.height * 0.1),
        fogged(_edge, f),
      );
    }
  }
}
