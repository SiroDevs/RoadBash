// Dart imports:
import 'dart:math' as math;

double pseudoRandom(int seed) {
  final sine = math.sin(seed * 12.9898) * 43758.5453;
  return sine - sine.floorToDouble();
}

double pickIn((double, double) range, double radius) =>
    range.$1 + (range.$2 - range.$1) * radius;

int pickInt((int, int) range, double radius) =>
    range.$1 + (radius * (range.$2 - range.$1 + 1)).floor().clamp(0, range.$2 - range.$1);
