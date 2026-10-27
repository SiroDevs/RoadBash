// Dart imports:
import 'dart:ui' hide TextStyle;

// Flutter imports:
import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle;

// Project imports:
import '../../constants/app_constants.dart';

/// Laid-out text, kept between frames. Building and measuring a paragraph is
/// one of the slowest things a canvas can do (in the browser every call crosses
/// into the rendering engine), and the HUD used to do it for every label on
/// every frame. A label only needs laying out when its text or style changes.
final Map<String, TextPainter> _painters = {};
const int _painterLimit = 96;

TextPainter _painterFor(
  String text,
  double size,
  Color color,
  FontWeight weight,
  String fontFamily,
  bool shadow,
) {
  final key =
      '$text|${size.toStringAsFixed(1)}|${color.toARGB32()}|${weight.value}|$fontFamily|$shadow';
  final hit = _painters.remove(key);
  if (hit != null) {
    _painters[key] = hit; // most recently used goes to the back
    return hit;
  }
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
  _painters[key] = tp;
  if (_painters.length > _painterLimit) {
    _painters.remove(_painters.keys.first)?.dispose();
  }
  return tp;
}

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
  final tp = _painterFor(text, size, color, weight, fontFamily, shadow);
  final dx = switch (align) {
    TextAlign.left => 0.0,
    TextAlign.right => -tp.width,
    _ => -tp.width / 2,
  };
  tp.paint(canvas, Offset(at.dx + dx, at.dy - tp.height / 2));
}
