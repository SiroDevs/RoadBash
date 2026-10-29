// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

/// Draws layered hills across the horizon.
void drawHills(
  Canvas canva,
  Path path, {
  required double width,
  required double baseY,
  required double amplitude,
  required double frequency,
  required double scroll,
  required Paint paint,
}) {
  path
    ..reset()
    ..moveTo(0, baseY + 1);
  for (double x = 0; x <= width + 8; x += 8) {
    final shifted = x + scroll;
    final wave =
        1 +
        0.5 * math.sin(shifted * frequency) +
        0.3 * math.sin(shifted * frequency * 2.7 + 1.3);
    path.lineTo(x, baseY - amplitude * wave);
  }
  path
    ..lineTo(width, baseY + 1)
    ..close();
  canva.drawPath(path, paint);
}
