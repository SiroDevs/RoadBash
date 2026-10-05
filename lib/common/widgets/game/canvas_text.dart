// Dart imports:
import 'dart:ui' hide TextStyle;

// Flutter imports:
import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle;

/// Draws [text] on a [Canvas] with its vertical middle at [at].dy.
/// [align] says how [at].dx is used (centre / left edge / right edge).
void paintText(
  Canvas canvas,
  String text,
  Offset at,
  double size,
  Color color, {
  FontWeight weight = FontWeight.w700,
  TextAlign align = TextAlign.center,
  bool shadow = false,
}) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
        shadows: shadow
            ? const [
                Shadow(
                  color: Color(0xCC000000),
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ]
            : null,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final dx = align == TextAlign.left
      ? 0.0
      : (align == TextAlign.right ? -tp.width : -tp.width / 2);
  tp.paint(canvas, Offset(at.dx + dx, at.dy - tp.height / 2));
}
