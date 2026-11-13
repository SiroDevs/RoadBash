// Dart imports:
import 'dart:ui';

/// Colors of the recolorable parts of the layered rider and bike artwork.
/// The defaults are the colors the artwork was drawn in.
class ArtPalette {
  const ArtPalette({
    this.helmet = const Color(0xFFFF7F27),
    this.helmetPrint = const Color(0xFFA349A4),
    this.helmetStripe = const Color(0xFF3F48CC),
    this.visor = const Color(0xFFB97A57),
    this.legs = const Color(0xFF00A2E8),
    this.panel = const Color(0xFFED1C24),
    this.jacket = const Color(0xFF3A3D4E),
    this.sleeve = const Color(0xFFFFFFFF),
    this.bikeDark = const Color(0xFF19311D),
    this.bike = const Color(0xFF468638),
  });

  static const ArtPalette drawn = ArtPalette();

  final Color helmet;
  final Color helmetPrint;
  final Color helmetStripe;
  final Color visor;
  final Color legs;
  final Color panel;
  final Color jacket;
  final Color sleeve;
  final Color bikeDark;
  final Color bike;

  /// Solid colors of the drawn artwork, each with the color that replaces it.
  Map<Color, Color> swapsFrom(ArtPalette source) => {
    source.helmet: helmet,
    source.helmetPrint: helmetPrint,
    source.helmetStripe: helmetStripe,
    source.visor: visor,
    source.legs: legs,
    source.panel: panel,
    source.jacket: jacket,
    source.sleeve: sleeve,
    source.bikeDark: bikeDark,
  };
}
