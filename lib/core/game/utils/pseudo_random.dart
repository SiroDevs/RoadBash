// Dart imports:
import 'dart:math' as math;

/// Returns a repeatable pseudo-random value from 0 to 1 for a seed.
double pseudoRandom(int seed) {
  final sine = math.sin(seed * 12.9898) * 43758.5453;
  return sine - sine.floorToDouble();
}

/// Picks a value inside a range from a 0-1 roll.
double pickIn((double, double) range, double radius) =>
    range.$1 + (range.$2 - range.$1) * radius;

/// Picks an integer inside a range from a 0-1 roll.
int pickInt((int, int) range, double radius) =>
    range.$1 + (radius * (range.$2 - range.$1 + 1)).floor().clamp(0, range.$2 - range.$1);
