// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../utils/paint_utils.dart';
import '../../../projection/road_projection.dart';
import '../../../scene/scene_theme.dart';
import '../../../../utils/sign_text.dart';
import '../../prop.dart';
import '../../sign_panel.dart';

class GantryPainter {
  GantryPainter(SceneTheme theme)
      : _post = fogRamp(theme.poleColor, theme.fog),
        _panel = fogRamp(theme.signGreen, theme.fog),
        _blue = fogRamp(const Color(0xFF1F5FA8), theme.fog),
        _edge = fogRamp(const Color(0xFFF2F2EC), theme.fog),
        _board = fogRamp(const Color(0xFFE6B422), theme.fog),
        _ink = fogRamp(const Color(0xFF23262B), theme.fog);

  final List<Paint> _post, _panel, _blue, _edge, _board, _ink;

  static const double _textCutoff = 0.55;
  static const List<SignPanel> _blank = [
    SignPanel([]),
    SignPanel([]),
    SignPanel([]),
  ];

  void draw(Canvas c, VisionSeg v, Prop p, double l, double r) {
    final k = v.k1, y = v.y1, f = v.fog;
    final top = y - p.height * k;
    final pw = math.max(1.0, 110 * k);
    final beam = math.max(1.0, 160 * k);

    // Frame
    c.drawRect(Rect.fromLTRB(l - pw, top, l + pw, y + 1), fogged(_post, f));
    c.drawRect(Rect.fromLTRB(r - pw, top, r + pw, y + 1), fogged(_post, f));
    c.drawRect(Rect.fromLTRB(l - pw, top, r + pw, top + beam), fogged(_post, f));

    // Advertising boards on the posts
    for (final x in [l - pw * 5, r + pw * 1.5]) {
      final board = Rect.fromLTRB(x, top + beam * 2, x + pw * 3.5, top + 1900 * k);
      c.drawRect(board, fogged(_board, f));
      c.drawRect(board.deflate(math.max(0.6, pw * 0.5)), fogged(_ink, f));
    }

    // Sign panels
    final panels = p.signs.isEmpty ? _blank : p.signs;
    final count = panels.length;
    final span = (r - l) * (count == 1 ? 0.4 : (count == 2 ? 0.7 : 0.9));
    final gap = span * 0.04;
    final panelW = (span - gap * (count - 1)) / count;
    final panelH = 780 * k;
    final panelTop = top + beam + 220 * k;
    for (var n = 0; n < count; n++) {
      final left = v.x1 - span / 2 + n * (panelW + gap);
      final panel = Rect.fromLTWH(left, panelTop, panelW, panelH);
      c.drawRect(panel.inflate(math.max(1.0, 30 * k)), fogged(_edge, f));
      c.drawRect(panel, fogged(panels[n].blue ? _blue : _panel, f));
      if (f < _textCutoff && panelH > 10 && panels[n].lines.isNotEmpty) {
        // Panel text
        SignText.draw(c, panel.deflate(panelW * 0.04), panels[n].lines);
      } else if (f < _textCutoff && panelH > 10) {
        // Panel text bars
        for (var line = 0; line < 3; line++) {
          final ty = panel.top + panelH * (0.16 + line * 0.27);
          c.drawRect(
            Rect.fromLTRB(panel.left + panelW * 0.12, ty,
                panel.right - panelW * (0.12 + (line == 2 ? 0.3 : 0)),
                ty + panelH * 0.1),
            fogged(_edge, f),
          );
        }
      }
    }
  }
}
