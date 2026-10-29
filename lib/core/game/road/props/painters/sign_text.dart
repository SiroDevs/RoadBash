// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../sign_panel.dart';
import 'sign_arrows.dart';
import 'sign_glyphs.dart';

// Draws text lines, columns and full panels onto road signs.
abstract final class SignText {
  static const Color white = SignGlyphs.white;
  static const Color amber = SignGlyphs.amber;
  static const Color ink = SignGlyphs.ink;

  static void draw(
    Canvas canvas,
    Rect box,
    List<String> lines, {
    Color color = white,
  }) {
    if (lines.isEmpty) return;
    final slot = box.height / lines.length;
    for (var index = 0; index < lines.length; index++) {
      if (lines[index].isEmpty) continue;
      final textPainter = SignGlyphs.painter(lines[index], color);
      final scale = math.min(
        box.width * 0.9 / textPainter.width,
        slot * 0.78 / textPainter.height,
      );
      canvas
        ..save()
        ..translate(box.center.dx, box.top + slot * (index + 0.5))
        ..scale(scale);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  static void drawVertical(
    Canvas canvas,
    Rect box,
    List<String> columns, {
    Color color = ink,
  }) {
    if (columns.isEmpty) return;
    final slot = box.width / columns.length;
    for (var index = 0; index < columns.length; index++) {
      final textPainter = SignGlyphs.painter(columns[index], color);
      final scale = math.min(
        box.height * 0.94 / textPainter.width,
        slot * 0.82 / textPainter.height,
      );
      canvas
        ..save()
        ..translate(box.left + slot * (index + 0.5), box.center.dy)
        ..rotate(-math.pi / 2)
        ..scale(scale);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  static void drawPanel(Canvas canvas, Rect box, SignPanel panel) {
    if (panel.arrow == SignArrow.upLeft) {
      SignArrows.board(canvas, box, panel);
      return;
    }
    final inner = Rect.fromLTRB(
      box.left + box.width * 0.05,
      box.top + box.height * 0.07,
      box.right - box.width * 0.05,
      box.bottom - box.height * 0.05,
    );
    final footerHeight = panel.footer == null ? 0.0 : inner.height * 0.26;
    final arrowWidth = panel.arrow == SignArrow.none ? 0.0 : inner.width * 0.2;
    final area = Rect.fromLTRB(
      inner.left,
      inner.top,
      inner.right - arrowWidth,
      inner.bottom - footerHeight,
    );
    final unitHeight = SignGlyphs.painter('A', white).height;
    final gap = unitHeight * 0.4;
    final count = math.max(1, math.max(panel.rows.length, panel.side.length));
    final rowHeight = area.height / count;

    var sideWidth = 0.0;
    for (final side in panel.side) {
      sideWidth = math.max(sideWidth, SignGlyphs.widthOf(side.text));
    }
    var widest = 1.0;
    for (var index = 0; index < panel.rows.length; index++) {
      final row = panel.rows[index];
      var rowWidth = SignGlyphs.widthOf(row.text);
      if (row.code != null) rowWidth += gap + SignGlyphs.widthOf(row.code!);
      if (row.tail != null) {
        rowWidth += gap * 1.5 + SignGlyphs.widthOf(row.tail!);
      }
      if (index < panel.side.length) rowWidth += gap + sideWidth;
      widest = math.max(widest, rowWidth);
    }
    final scale = math.min(rowHeight * 0.8 / unitHeight, area.width / widest);

    for (var index = 0; index < panel.rows.length; index++) {
      final row = panel.rows[index];
      final centerY = area.top + rowHeight * (index + 0.5);
      SignGlyphs.run(canvas, row.text, area.left, centerY, scale);
      if (row.code != null) {
        SignGlyphs.run(
          canvas,
          row.code!,
          area.left + (SignGlyphs.widthOf(row.text) + gap) * scale,
          centerY,
          scale,
          color: amber,
        );
      }
      if (row.tail != null) {
        SignGlyphs.run(
          canvas,
          row.tail!,
          area.right,
          centerY,
          scale,
          right: true,
        );
      }
    }
    for (var index = 0; index < panel.side.length; index++) {
      SignGlyphs.run(
        canvas,
        panel.side[index].text,
        area.right,
        area.top + rowHeight * (index + 0.5),
        scale,
        right: true,
      );
    }

    if (panel.footer != null) {
      final footerPainter = SignGlyphs.painter(panel.footer!, white);
      final big = math.min(
        footerHeight * 0.95 / unitHeight,
        inner.width * 0.6 / footerPainter.width,
      );
      SignGlyphs.run(
        canvas,
        panel.footer!,
        inner.center.dx - footerPainter.width * big / 2,
        inner.bottom - footerHeight / 2,
        math.max(big, scale * 1.2),
      );
    }
    if (panel.arrow != SignArrow.none) {
      final up = panel.arrow == SignArrow.up;
      SignArrows.upArrow(
        canvas,
        Rect.fromLTRB(
          inner.right - arrowWidth * 0.95,
          inner.top + inner.height * (up ? 0.08 : 0.34),
          inner.right,
          up
              ? inner.top + inner.height * 0.55
              : inner.bottom - footerHeight * 0.9,
        ),
        panel.arrow,
      );
    }
  }
}
