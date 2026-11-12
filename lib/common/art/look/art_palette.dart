// Dart imports:
import 'dart:ui';

/// Colors of every recolorable part of the layered rider and bike artwork.
/// The defaults are the colors the artwork was drawn in.
class ArtPalette {
  const ArtPalette({
    this.helmet = const Color(0xFFFF7F27),
    this.helmetPrint = const Color(0xFFA349A4),
    this.helmetStripe = const Color(0xFF3F48CC),
    this.visor = const Color(0xFFB97A57),
    this.visorEdge = const Color(0xFF563828),
    this.legs = const Color(0xFF00A2E8),
    this.panel = const Color(0xFFED1C24),
    this.boots = const Color(0xFFED1C24),
    this.leather = const Color(0xFF000000),
    this.jacket = const Color(0xFF3A3D4E),
    this.sleeve = const Color(0xFFFFFFFF),
    this.gloves = const Color(0xFF000000),
    this.bikeLight = const Color(0xFF468638),
    this.bikeDark = const Color(0xFF19311D),
    this.bikeBase = const Color(0xFF2F5C37),
    this.bikeDeep = const Color(0xFF0D190E),
    this.bikeUnder = const Color(0xFF39317F),
    this.shield = const Color(0xFF3A3D4E),
  });

  static const ArtPalette drawn = ArtPalette();

  /// The palette the artwork shapes read while a rider is being painted.
  static ArtPalette active = drawn;

  /// Runs [paint] with [palette] as the active palette.
  static void use(ArtPalette palette, void Function() paint) {
    final previous = active;
    active = palette;
    try {
      paint();
    } finally {
      active = previous;
    }
  }

  final Color helmet;
  final Color helmetPrint;
  final Color helmetStripe;
  final Color visor;
  final Color visorEdge;
  final Color legs;
  final Color panel;
  final Color boots;
  final Color leather;
  final Color jacket;
  final Color sleeve;
  final Color gloves;
  final Color bikeLight;
  final Color bikeDark;
  final Color bikeBase;
  final Color bikeDeep;
  final Color bikeUnder;
  final Color shield;
}
