// Dart imports:
import 'dart:ui' hide TextStyle;

// Flutter imports:
import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle;

// Project imports:
import '../../../../constants/app_constants.dart';

// Shared text painters and drawing primitives for road signs.
abstract final class SignGlyphs {
  static const Color white = Color(0xFFFFFFFF);
  static const Color amber = Color(0xFFE5A83B);
  static const Color ink = Color(0xFF23262B);

  static final Map<String, TextPainter> _cache = {};
  static final Paint fill = Paint()..color = white;
  static final Path path = Path();

  static TextPainter painter(String text, Color color) => _cache.putIfAbsent(
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

  static Color colorFor(String text) => text.startsWith('(') ? amber : white;

  static double widthOf(String text) => painter(text, white).width;

  // Draws [text] scaled about its vertical centre, left or right anchored.
  static void run(
    Canvas canvas,
    String text,
    double anchorX,
    double centerY,
    double scale, {
    bool right = false,
    Color? color,
  }) {
    final textPainter = painter(text, color ?? colorFor(text));
    final left = right ? anchorX - textPainter.width * scale : anchorX;
    canvas
      ..save()
      ..translate(left, centerY)
      ..scale(scale);
    textPainter.paint(canvas, Offset(0, -textPainter.height / 2));
    canvas.restore();
  }
}
