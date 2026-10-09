// Dart imports:
import 'dart:ui' hide TextStyle;

// Flutter imports:
import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle;

// Project imports:
import '../../../common/constants/app_constants.dart';

/// Draws [text] with its vertical middle at [at].dy. [align] says whether
/// [at].dx is the centre, left edge or right edge of the text.
void paintText(
  Canvas canvas,
  String text,
  Offset at,
  double size,
  Color color, {
  FontWeight weight = FontWeight.w700,
  TextAlign align = TextAlign.center,
  String fontFamily = AppConstants.kFontFamily,
  bool shadow = false,
}) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
        fontFamily: fontFamily,
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
  final dx = switch (align) {
    TextAlign.left => 0.0,
    TextAlign.right => -tp.width,
    _ => -tp.width / 2,
  };
  tp.paint(canvas, Offset(at.dx + dx, at.dy - tp.height / 2));
}
