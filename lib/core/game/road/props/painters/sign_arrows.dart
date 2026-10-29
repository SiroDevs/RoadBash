// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../sign_panel.dart';
import 'sign_glyphs.dart';

// Arrow-style sign boards and arrow symbols.
abstract final class SignArrows {
  static const Color _roundelInk = Color(0xFF1B44AE);

  // Exit board: diagonal arrow, destination rows and an optional number disc.
  static void board(Canvas canvas, Rect box, SignPanel panel) {
    final height = box.height;
    final hasDisc = panel.roundel != null;

    diagonal(
      canvas,
      Offset(box.left + height * 0.31, box.top + height * 0.5),
      height * 0.52,
    );

    final discSize = height * 0.6;
    final discX = box.right - height * 0.397;
    final textLeft = box.left + height * 0.58;
    final textRight = hasDisc
        ? discX - discSize / 2 - height * 0.03
        : box.right - height * 0.1;

    final unitHeight = SignGlyphs.painter('A', SignGlyphs.white).height;
    final gap = unitHeight * 0.4;
    var widest = 1.0;
    for (final row in panel.rows) {
      var rowWidth = SignGlyphs.widthOf(row.text);
      if (row.code != null) rowWidth += gap + SignGlyphs.widthOf(row.code!);
      widest = math.max(widest, rowWidth);
    }
    final rowCount = panel.rows.length;
    final pitch = height * 0.72 / math.max(1, rowCount);
    final scale = math.min(
      pitch * 1.22 / unitHeight,
      (textRight - textLeft) / widest,
    );
    for (var index = 0; index < rowCount; index++) {
      final row = panel.rows[index];
      final offset = (index - (rowCount - 1) / 2) * pitch;
      final centerY = box.top + height * 0.5 + offset;
      SignGlyphs.run(canvas, row.text, textLeft, centerY, scale);
      if (row.code != null) {
        SignGlyphs.run(
          canvas,
          row.code!,
          textLeft + (SignGlyphs.widthOf(row.text) + gap) * scale,
          centerY,
          scale,
          color: SignGlyphs.amber,
        );
      }
    }

    if (hasDisc) {
      final centre = Offset(discX, box.top + height * 0.5);
      _disc(canvas, panel.roundel!, centre, discSize);
    }
  }

  /// Draws a number disc on a sign.
  static void _disc(Canvas canvas, String label, Offset centre, double size) {
    canvas.drawCircle(centre, size / 2, SignGlyphs.fill);
    final textPainter = SignGlyphs.painter(label, _roundelInk);
    final fit = math.min(
      size * 0.66 / textPainter.width,
      size * 0.62 / textPainter.height,
    );
    canvas
      ..save()
      ..translate(centre.dx, centre.dy)
      ..scale(fit);
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();
  }

  /// Draws a diagonal arrow.
  static void diagonal(Canvas canvas, Offset centre, double length) {
    final shaft = length * 0.27;
    final head = length * 0.82;
    final headHeight = length * 0.46;
    final top = -length / 2;
    final bottom = length / 2;
    canvas
      ..save()
      ..translate(centre.dx, centre.dy)
      ..rotate(-math.pi / 4);
    SignGlyphs.path
      ..reset()
      ..moveTo(0, top)
      ..lineTo(head / 2, top + headHeight)
      ..lineTo(shaft / 2, top + headHeight)
      ..lineTo(shaft / 2, bottom)
      ..lineTo(-shaft / 2, bottom)
      ..lineTo(-shaft / 2, top + headHeight)
      ..lineTo(-head / 2, top + headHeight)
      ..close();
    canvas.drawPath(SignGlyphs.path, SignGlyphs.fill);
    canvas.restore();
  }

  /// Draws an up or exit arrow.
  static void upArrow(Canvas canvas, Rect area, SignArrow kind) {
    final width = area.width;
    final height = area.height;
    final centerX = area.center.dx;
    final stem = width * 0.16;
    final path = SignGlyphs.path..reset();
    path.addRect(
      Rect.fromLTRB(
        centerX - stem / 2,
        area.top + height * 0.3,
        centerX + stem / 2,
        area.bottom,
      ),
    );
    path
      ..moveTo(centerX - width * 0.34, area.top + height * 0.36)
      ..lineTo(centerX, area.top)
      ..lineTo(centerX + width * 0.34, area.top + height * 0.36)
      ..close();
    if (kind == SignArrow.exit) {
      final branchX = area.left + width * 0.16;
      final branchY = area.top + height * 0.5;
      path
        ..moveTo(centerX - stem / 2, area.top + height * 0.82)
        ..lineTo(centerX + stem / 2, area.top + height * 0.82)
        ..lineTo(branchX + stem / 2, branchY)
        ..lineTo(branchX - stem / 2, branchY)
        ..close()
        ..moveTo(branchX - width * 0.2, branchY + height * 0.04)
        ..lineTo(branchX - stem * 0.2, branchY - height * 0.22)
        ..lineTo(branchX + width * 0.22, branchY + height * 0.04)
        ..close();
    }
    canvas.drawPath(path, SignGlyphs.fill);
  }
}
