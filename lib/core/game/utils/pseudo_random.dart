import 'dart:math' as math;

double pseudoRandom(int n) {
  final s = math.sin(n * 12.9898) * 43758.5453;
  return s - s.floorToDouble();
}
