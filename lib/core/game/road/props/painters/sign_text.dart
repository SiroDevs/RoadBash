// Dart imports:
import 'dart:math' as math;
import 'dart:ui' hide TextStyle;

// Flutter imports:
import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle;

// Project imports:
import '../../../../constants/app_constants.dart';
import '../sign_panel.dart';

abstract final class SignText {
  static const Color white = Color(0xFFFFFFFF);
  static const Color amber = Color(0xFFE5A83B);
  static const Color ink = Color(0xFF23262B);

  static final Map<String, TextPainter> _cache = {};
  static final Paint _fill = Paint()..color = white;
  static final Path _path = Path();

  static TextPainter _painter(String text, Color color) => _cache.putIfAbsent(
        '${color.toARGB32()}|$text',
        () => TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              color: color,
              fontSize: 64,
              fontWeight: FontWeight.w700,
              fontFamily: AppConstants.kFontFamily,
              letterSpacing: 1,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(),
      );

  static Color _color(String text) => text.startsWith('(') ? amber : white;

  static void draw(Canvas c, Rect box, List<String> lines,
      {Color color = white}) {
    if (lines.isEmpty) return;
    final slot = box.height / lines.length;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].isEmpty) continue;
      final tp = _painter(lines[i], color);
      final scale = math.min(box.width * 0.9 / tp.width, slot * 0.78 / tp.height);
      c.save();
      c.translate(box.center.dx, box.top + slot * (i + 0.5));
      c.scale(scale);
      tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
      c.restore();
    }
  }

  static void drawVertical(Canvas c, Rect box, List<String> columns,
      {Color color = ink}) {
    if (columns.isEmpty) return;
    final slot = box.width / columns.length;
    for (var i = 0; i < columns.length; i++) {
      final tp = _painter(columns[i], color);
      final scale = math.min(box.height * 0.94 / tp.width, slot * 0.82 / tp.height);
      c.save();
      c.translate(box.left + slot * (i + 0.5), box.center.dy);
      c.rotate(-math.pi / 2);
      c.scale(scale);
      tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
      c.restore();
    }
  }

  static void _run(Canvas c, String text, double x, double cy, double scale,
      {bool right = false, Color? color}) {
    final tp = _painter(text, color ?? _color(text));
    final left = right ? x - tp.width * scale : x;
    c.save();
    c.translate(left, cy);
    c.scale(scale);
    tp.paint(c, Offset(0, -tp.height / 2));
    c.restore();
  }

  static double _width(String text) => _painter(text, white).width;

  static void drawPanel(Canvas c, Rect box, SignPanel panel) {
    if (panel.arrow == SignArrow.upLeft) {
      _drawArrowBoard(c, box, panel);
      return;
    }
    final inner = Rect.fromLTRB(
      box.left + box.width * 0.05,
      box.top + box.height * 0.07,
      box.right - box.width * 0.05,
      box.bottom - box.height * 0.05,
    );
    final footerH = panel.footer == null ? 0.0 : inner.height * 0.26;
    final arrowW = panel.arrow == SignArrow.none ? 0.0 : inner.width * 0.2;
    final area = Rect.fromLTRB(
      inner.left,
      inner.top,
      inner.right - arrowW,
      inner.bottom - footerH,
    );
    final unitH = _painter('A', white).height;
    final gap = unitH * 0.4;
    final count = math.max(1, math.max(panel.rows.length, panel.side.length));
    final rowH = area.height / count;

    var sideW = 0.0;
    for (final r in panel.side) {
      sideW = math.max(sideW, _width(r.text));
    }
    var need = 1.0;
    for (var i = 0; i < panel.rows.length; i++) {
      final r = panel.rows[i];
      var rowW = _width(r.text);
      if (r.code != null) rowW += gap + _width(r.code!);
      if (r.tail != null) rowW += gap * 1.5 + _width(r.tail!);
      if (i < panel.side.length) rowW += gap + sideW;
      need = math.max(need, rowW);
    }
    final scale = math.min(rowH * 0.8 / unitH, area.width / need);

    for (var i = 0; i < panel.rows.length; i++) {
      final r = panel.rows[i];
      final cy = area.top + rowH * (i + 0.5);
      _run(c, r.text, area.left, cy, scale);
      if (r.code != null) {
        _run(c, r.code!, area.left + (_width(r.text) + gap) * scale, cy, scale,
            color: amber);
      }
      if (r.tail != null) {
        _run(c, r.tail!, area.right, cy, scale, right: true);
      }
    }
    for (var i = 0; i < panel.side.length; i++) {
      _run(c, panel.side[i].text, area.right, area.top + rowH * (i + 0.5),
          scale, right: true);
    }

    if (panel.footer != null) {
      final tp = _painter(panel.footer!, white);
      final big = math.min(footerH * 0.95 / unitH, inner.width * 0.6 / tp.width);
      _run(c, panel.footer!, inner.center.dx - tp.width * big / 2,
          inner.bottom - footerH / 2, math.max(big, scale * 1.2));
    }
    if (panel.arrow != SignArrow.none) {
      final up = panel.arrow == SignArrow.up;
      _arrow(
        c,
        Rect.fromLTRB(
          inner.right - arrowW * 0.95,
          inner.top + inner.height * (up ? 0.08 : 0.34),
          inner.right,
          up ? inner.top + inner.height * 0.55 : inner.bottom - footerH * 0.9,
        ),
        panel.arrow,
      );
    }
  }

  static const Color _roundelInk = Color(0xFF1B44AE);

  /// Exit board: diagonal arrow on the left, one text row per destination
  /// (with an optional amber road code), and, for numbered exits, the number
  /// in a white disc on the right. Sizes follow the board height so the same
  /// layout works for the wide named board and the numbered one.
  static void _drawArrowBoard(Canvas c, Rect box, SignPanel panel) {
    final h = box.height;
    final hasDisc = panel.roundel != null;

    _diagonalArrow(c, Offset(box.left + h * 0.31, box.top + h * 0.5), h * 0.52);

    final d = h * 0.6;
    final discX = box.right - h * 0.397;
    final textLeft = box.left + h * 0.58;
    final textRight = hasDisc ? discX - d / 2 - h * 0.03 : box.right - h * 0.1;

    final unitH = _painter('A', white).height;
    final gap = unitH * 0.4;
    var need = 1.0;
    for (final r in panel.rows) {
      var rowW = _width(r.text);
      if (r.code != null) rowW += gap + _width(r.code!);
      need = math.max(need, rowW);
    }
    final rows = panel.rows.length;
    final pitch = h * 0.72 / math.max(1, rows);
    final scale = math.min(pitch * 1.22 / unitH, (textRight - textLeft) / need);
    for (var i = 0; i < rows; i++) {
      final r = panel.rows[i];
      final cy = box.top + h * 0.5 + (i - (rows - 1) / 2) * pitch;
      _run(c, r.text, textLeft, cy, scale);
      if (r.code != null) {
        _run(c, r.code!, textLeft + (_width(r.text) + gap) * scale, cy, scale,
            color: amber);
      }
    }

    if (hasDisc) {
      final centre = Offset(discX, box.top + h * 0.5);
      c.drawCircle(centre, d / 2, _fill);
      final tp = _painter(panel.roundel!, _roundelInk);
      final fit = math.min(d * 0.66 / tp.width, d * 0.62 / tp.height);
      c.save();
      c.translate(centre.dx, centre.dy);
      c.scale(fit);
      tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
      c.restore();
    }
  }

  static void _diagonalArrow(Canvas c, Offset centre, double len) {
    final shaft = len * 0.27, head = len * 0.82, headH = len * 0.46;
    final top = -len / 2, bottom = len / 2;
    c.save();
    c.translate(centre.dx, centre.dy);
    c.rotate(-math.pi / 4);
    _path
      ..reset()
      ..moveTo(0, top)
      ..lineTo(head / 2, top + headH)
      ..lineTo(shaft / 2, top + headH)
      ..lineTo(shaft / 2, bottom)
      ..lineTo(-shaft / 2, bottom)
      ..lineTo(-shaft / 2, top + headH)
      ..lineTo(-head / 2, top + headH)
      ..close();
    c.drawPath(_path, _fill);
    c.restore();
  }

  static void _arrow(Canvas c, Rect r, SignArrow kind) {
    final w = r.width, h = r.height, cx = r.center.dx, t = w * 0.16;
    _path.reset();
    _path.addRect(Rect.fromLTRB(cx - t / 2, r.top + h * 0.3, cx + t / 2, r.bottom));
    _path
      ..moveTo(cx - w * 0.34, r.top + h * 0.36)
      ..lineTo(cx, r.top)
      ..lineTo(cx + w * 0.34, r.top + h * 0.36)
      ..close();
    if (kind == SignArrow.exit) {
      final bx = r.left + w * 0.16, by = r.top + h * 0.5;
      _path
        ..moveTo(cx - t / 2, r.top + h * 0.82)
        ..lineTo(cx + t / 2, r.top + h * 0.82)
        ..lineTo(bx + t / 2, by)
        ..lineTo(bx - t / 2, by)
        ..close()
        ..moveTo(bx - w * 0.2, by + h * 0.04)
        ..lineTo(bx - t * 0.2, by - h * 0.22)
        ..lineTo(bx + w * 0.22, by + h * 0.04)
        ..close();
    }
    c.drawPath(_path, _fill);
  }
}
