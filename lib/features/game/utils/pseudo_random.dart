// Dart imports:
import 'dart:math' as math;

/// Cheap deterministic pseudo-random number in [0, 1) for [n].
double pseudoRandom(int n) {
  final s = math.sin(n * 12.9898) * 43758.5453;
  return s - s.floorToDouble();
}
