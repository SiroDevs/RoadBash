// Dart imports:
import 'dart:math' as math;

double pseudoRandom(int n) {
  final s = math.sin(n * 12.9898) * 43758.5453;
  return s - s.floorToDouble();
}

double pickIn((double, double) range, double r) =>
    range.$1 + (range.$2 - range.$1) * r;

int pickInt((int, int) range, double r) =>
    range.$1 + (r * (range.$2 - range.$1 + 1)).floor().clamp(0, range.$2 - range.$1);
