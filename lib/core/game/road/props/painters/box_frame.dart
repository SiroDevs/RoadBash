// Dart imports:
import 'dart:math' as math;

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../road_projection.dart';
import '../prop.dart';

class BoxFrame {
  BoxFrame(VisionSeg near, VisionSeg far, Prop p, Vector2 size) {
    xi1 = near.x1 + p.side * near.w1 * p.offset;
    xo1 = xi1 + p.side * p.width * near.k1;
    xi2 = far.x1 + p.side * far.w1 * p.offset;
    xo2 = xi2 + p.side * p.width * far.k1;
    base1 = near.y1 + p.drop * near.k1;
    base2 = far.y1 + p.drop * far.k1;
    top1 = near.y1 - p.height * near.k1;
    top2 = far.y1 - p.height * far.k1;
    final lo = math.min(math.min(xi1, xo1), math.min(xi2, xo2));
    final hi = math.max(math.max(xi1, xo1), math.max(xi2, xo2));
    visible = hi >= 0 && lo <= size.x;
  }

  late final double xi1, xo1, xi2, xo2;
  late final double base1, base2, top1, top2;
  late final bool visible;
}
