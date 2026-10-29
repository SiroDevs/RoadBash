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

  void draw(Canvas canvas, VisionSeg vision, Prop prop, double left, double right) {
    final scale = vision.k1, groundY = vision.y1, fog = vision.fog;
    final top = groundY - prop.height * scale;
    final depth = 420 * scale;

    _truss(canvas, fog, left, right, top, depth, scale);
    for (var n = 0; n < 2; n++) {
      final board = n < prop.boards.length ? prop.boards[n] : null;
      _tower(canvas, fog, n == 0 ? left : right, groundY, top + depth * 0.5, scale, board);
    }
    _panels(canvas, vision, prop, top + depth * 0.62, left, right, scale);
  }

  void _bar(Canvas canvas, double fog, List<Paint> ramp, double x1, double y1,
      double x2, double y2, double th) {
    drawQuad(canvas, _path, fogged(ramp, fog), x1 - th / 2, y1, x2 - th / 2, y2,
        x2 + th / 2, y2, x1 + th / 2, y1);
  }

  void _truss(Canvas canvas, double fog, double left, double right, double top, double depth,
      double scale) {
    final th = math.max(1.0, 38 * scale);
    final paint = fogged(_steel, fog);
    final lo = left - 90 * scale, hi = right + 90 * scale;
    // Truss chords
    canvas.drawRect(Rect.fromLTRB(lo, top, hi, top + th), paint);
    canvas.drawRect(Rect.fromLTRB(lo, top + depth - th, hi, top + depth), paint);
    if (depth < 6) return;
    // Truss bracing
    final bays = ((hi - lo) / (depth * 1.1)).round().clamp(6, 22);
    final step = (hi - lo) / bays;
    for (var i = 0; i < bays; i++) {
      final x0 = lo + step * i, x1 = x0 + step;
      _bar(canvas, fog, _steel, x0, i.isEven ? top + depth - th : top + th, x1,
          i.isEven ? top + th : top + depth - th, th * 0.7);
      _bar(canvas, fog, _steel, x0, top + th, x0, top + depth - th, th * 0.7);
    }
  }

  void _tower(Canvas canvas, double fog, double cx, double groundY, double boardTop,
      double scale, SignBoard? board) {
    final bw = 560 * scale, bh = 1700 * scale;
    final bottom = boardTop + bh;
    final lw = math.max(1.0, 45 * scale);

    // Tower legs
    _bar(canvas, fog, _steel, cx - 210 * scale, bottom, cx - 330 * scale, groundY, lw);
    _bar(canvas, fog, _steel, cx + 210 * scale, bottom, cx + 330 * scale, groundY, lw);
    for (final t in const [0.34, 0.68]) {
      final hx = (210 + 120 * t) * scale;
      final ty = bottom + (groundY - bottom) * t;
      canvas.drawRect(Rect.fromLTRB(cx - hx, ty - lw / 2, cx + hx, ty + lw / 2),
          fogged(_steel, fog));
    }
    _bar(canvas, fog, _steel, cx - 210 * scale, bottom, cx + 270 * scale, bottom + (groundY - bottom) * 0.5, lw * 0.8);
    _bar(canvas, fog, _steel, cx + 210 * scale, bottom, cx - 270 * scale, bottom + (groundY - bottom) * 0.5, lw * 0.8);
    canvas.drawRect(Rect.fromLTRB(cx - 420 * scale, groundY - 70 * scale, cx + 420 * scale, groundY + 20 * scale),
        fogged(_concrete, fog));

    // Yellow board
    final rect = Rect.fromLTRB(cx - bw / 2, boardTop, cx + bw / 2, bottom);
    canvas.drawRect(rect.inflate(math.max(1.0, 24 * scale)), fogged(_ink, fog));
    canvas.drawRect(rect, fogged(_board, fog));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx, boardTop + bh * 0.06),
            width: bw * 0.5,
            height: bh * 0.05),
        fogged(_edge, fog));
    if (fog < _textCutoff && rect.height > 18 && board != null) {
      SignText.drawVertical(
        canvas,
        Rect.fromLTRB(rect.left + bw * 0.06, boardTop + bh * 0.12,
            rect.right - bw * 0.06, boardTop + bh * 0.78),
        board.columns,
      );
    }

    // Badge
    final badge = Rect.fromLTRB(rect.left + bw * 0.12, boardTop + bh * 0.83,
        rect.right - bw * 0.12, boardTop + bh * 0.95);
    canvas.drawRect(badge, fogged(_edge, fog));
    canvas.drawRect(badge.deflate(bw * 0.03), fogged(_blue, fog));
    if (fog < _textCutoff && badge.height > 8) {
      SignText.draw(canvas, badge.deflate(bw * 0.04), const ['pelican']);
    }
  }

  void _panels(Canvas canvas, VisionSeg vision, Prop prop, double panelTop, double left,
      double right, double scale) {
    final fog = vision.fog;
    final panels = prop.signs.isEmpty ? _blank : prop.signs;
    final count = panels.length;
    final span = (right - left) * (count == 1 ? 0.42 : (count == 2 ? 0.78 : 0.92));
    final gap = span * 0.03;
    var weights = 0.0;
    for (final s in panels) {
      weights += s.weight;
    }
    final usable = span - gap * (count - 1);
    final height = 1150 * scale;
    final edge = math.max(1.0, 26 * scale);
    var cursorX = vision.x1 - span / 2;

    for (final data in panels) {
      final panelWidth = usable * data.weight / weights;
      final rect = Rect.fromLTWH(cursorX, panelTop, panelWidth, height);
      canvas.drawRect(rect.inflate(edge), fogged(_edge, fog));
      canvas.drawRect(rect, fogged(data.blue ? _blue : _panel, fog));
      if (data.tab != null) _tab(canvas, fog, rect, data.tab!, edge, height);
      if (fog < _textCutoff && height > 16) {
        if (data.rows.isEmpty) {
          _bars(canvas, fog, rect);
        } else {
          SignText.drawPanel(canvas, rect, data);
        }
      }
      cursorX += panelWidth + gap;
    }
  }

  void _tab(Canvas canvas, double fog, Rect panel, String label, double edge,
      double panelHeight) {
    final width = panel.width * (0.14 + 0.05 * label.length).clamp(0.25, 0.6);
    final height = panelHeight * 0.2;
    final tab = Rect.fromLTWH(panel.left + panel.width * 0.03,
        panel.top - edge - height, width, height);
    canvas.drawRect(tab.inflate(edge * 0.8), fogged(_edge, fog));
    canvas.drawRect(tab, fogged(_panel, fog));
    if (fog < _textCutoff && height > 8) {
      SignText.draw(canvas, tab.deflate(height * 0.1), [label]);
    }
  }

  void _bars(Canvas canvas, double fog, Rect panel) {
    for (var line = 0; line < 3; line++) {
      final ty = panel.top + panel.height * (0.16 + line * 0.27);
      canvas.drawRect(
        Rect.fromLTRB(panel.left + panel.width * 0.12, ty,
            panel.right - panel.width * (0.12 + (line == 2 ? 0.3 : 0)),
            ty + panel.height * 0.1),
        fogged(_edge, fog),
      );
    }
  }
}
