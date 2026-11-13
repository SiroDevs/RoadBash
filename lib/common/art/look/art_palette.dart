// Dart imports:
import 'dart:ui';

// Project imports:
import '../sheet/art_tone.dart';

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
    source.panel: panel,
    source.jacket: jacket,
    source.sleeve: sleeve,
    source.bikeDark: bikeDark,
  };

  static const Color _drawnBikeDark = Color(0xFF19311D);
  static const Color _drawnBikeSide = Color(0xFF2F5C37);
  static const Color _drawnUnderPanel = Color(0xFF39317F);
  static const Color _drawnJacket = Color(0xFF3A3D4E);
  static const Color _drawnGlass = Color(0xFF563828);
  static const Color _drawnJacketDark = Color(0xFF1D1F27);
  static const Color _drawnBodyArm = Color(0xFF000002);
  static const Color _drawnBodyBoot = Color(0xFF000003);

  /// Shaded variants of the drawn colors that are not in [swapsFrom].
  Map<Color, Color> get shadeSwaps => {
    _drawnGlass: ToneColors.shaded(visor, 0.6),
    _drawnJacketDark: ToneColors.shaded(jacket, 0.55),
    _drawnBodyArm: ToneColors.shaded(jacket, 0.7),
    _drawnBodyBoot: ToneColors.shaded(panel, 0.5),
  };

  /// Colors that replace the drawn colors of one gradient.
  ///
  /// Gradients that are not part of the suit or the bike body, such as tyres,
  /// chrome and the brake light, keep their drawn colors.
  List<Color> gradientColors(List<Color> drawn) {
    final first = drawn.first;
    if (first == _drawnBikeDark) return [bikeDark, bike];
    if (first == _drawnBikeSide) {
      return [ToneColors.shaded(bike, 0.7), ToneColors.shaded(bikeDark, 0.5)];
    }
    if (first == _drawnUnderPanel) {
      return [ToneColors.shaded(bike, 0.55), drawn.last];
    }
    if (first == _drawnJacket) {
      return [jacket, ToneColors.shaded(jacket, 0.55)];
    }
    return drawn;
  }
}
