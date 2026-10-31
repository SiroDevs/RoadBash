/// Returns the sideways position where a rival parks beside the player.
double parkingLateral(int index, double playerX, double minLateral, double maxLateral) {
  final side = index.isEven ? 1.0 : -1.0;
  final offset = 0.42 + 0.4 * (index ~/ 2);
  final lane = playerX + side * offset;
  if (lane >= minLateral && lane <= maxLateral) return lane;
  return playerX - side * offset;
}
