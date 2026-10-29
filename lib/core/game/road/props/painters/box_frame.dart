// Dart imports:
import 'dart:math' as math;

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../road_projection.dart';
import '../prop.dart';

/// Screen corners of a prop's box between two segments.
class BoxFrame {
  BoxFrame(VisionSeg near, VisionSeg far, Prop prop, Vector2 size) {
    xi1 = near.x1 + prop.side * near.w1 * prop.offset;
    xo1 = xi1 + prop.side * prop.width * near.k1;
    xi2 = far.x1 + prop.side * far.w1 * prop.offset;
    xo2 = xi2 + prop.side * prop.width * far.k1;
    base1 = near.y1 + prop.drop * near.k1;
    base2 = far.y1 + prop.drop * far.k1;
    top1 = near.y1 - prop.height * near.k1;
    top2 = far.y1 - prop.height * far.k1;
    final lo = math.min(math.min(xi1, xo1), math.min(xi2, xo2));
    final hi = math.max(math.max(xi1, xo1), math.max(xi2, xo2));
    visible = hi >= 0 && lo <= size.x;
  }

  late final double xi1, xo1, xi2, xo2;
  late final double base1, base2, top1, top2;
  late final bool visible;
}
