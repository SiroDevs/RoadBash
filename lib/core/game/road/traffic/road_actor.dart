// Dart imports:
import 'dart:ui';

/// Something that rides on the road, such as a rival.
abstract interface class RoadActor {
  double get distance;
  double get lateral;

  void paint(Canvas canvas, Offset ground, double height);
}
