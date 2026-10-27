// Dart imports:
import 'dart:math' as math;
import 'dart:ui' hide TextStyle;

// Flutter imports:
import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle;

// Project imports:
import '../../constants/app_constants.dart';

abstract final class SignText {
  static const Color white = Color(0xFFFFFFFF);

  static final Map<String, TextPainter> _cache = {};

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
}
