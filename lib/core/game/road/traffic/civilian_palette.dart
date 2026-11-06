// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

/// Body and accent colours civilian vehicles are painted in.
abstract final class CivilianPalette {
  static const List<Color> bodies = [
    Color(0xFFE8E8EC),
    Color(0xFF2F3A4F),
    Color(0xFFB3261E),
    Color(0xFF1F6FB5),
    Color(0xFF3C8D5A),
    Color(0xFFF2C21C),
    Color(0xFF8A8F98),
    Color(0xFF111418),
    Color(0xFFE67E22),
  ];

  static const List<Color> accents = [
    Color(0xFFFFD60A),
    Color(0xFFFFFFFF),
    Color(0xFF39D0FF),
    Color(0xFFFF4D8D),
    Color(0xFF7CFF6B),
  ];

  /// Picks a random body colour.
  static Color randomBody(math.Random random) =>
      bodies[random.nextInt(bodies.length)];

  /// Picks a random accent colour.
  static Color randomAccent(math.Random random) =>
      accents[random.nextInt(accents.length)];
}
