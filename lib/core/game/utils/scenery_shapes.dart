// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

/// Cheap deterministic pseudo-random number in [0, 1) for [n].
double pseudoRandom(int n) {
  final s = math.sin(n * 12.9898) * 43758.5453;
  return s - s.floorToDouble();
}

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
    final s = x + scroll;
    final wave =
        1 +
        0.5 * math.sin(s * frequency) +
        0.3 * math.sin(s * frequency * 2.7 + 1.3);
    path.lineTo(x, baseY - amplitude * wave);
  }
  path
    ..lineTo(width, baseY + 1)
    ..close();
  canva.drawPath(path, paint);
}