// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'pseudo_random.dart';

/// Row of flat-topped blocks standing on [baseY], scrolled by [scroll].
void drawSkyline(
  Canvas c, {
  required double width,
  required double baseY,
  required double block,
  required double minHeight,
  required double maxHeight,
  required double scroll,
  required Paint a,
  required Paint b,
}) {
  final first = (scroll / block).floor() - 1;
  final count = (width / block).ceil() + 3;
  for (var j = 0; j < count; j++) {
    final i = first + j;
    final h = minHeight + (maxHeight - minHeight) * pseudoRandom(i);
    c.drawRect(Rect.fromLTWH(i * block - scroll, baseY - h, block + 1, h + 1),
        i.isEven ? a : b);
  }
}

void drawHills(
  Canvas c,
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
    final wave = 1 +
        0.5 * math.sin(s * frequency) +
        0.3 * math.sin(s * frequency * 2.7 + 1.3);
    path.lineTo(x, baseY - amplitude * wave);
  }
  path
    ..lineTo(width, baseY + 1)
    ..close();
  c.drawPath(path, paint);
}
