import 'dart:ui';

abstract interface class RoadActor {
  double get distance;
  double get lateral;

  void paint(Canvas canvas, Offset ground, double height);
}