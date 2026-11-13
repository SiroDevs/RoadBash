// Project imports:
import '../sheet/art_tone.dart';
import 'art_palette.dart';
import 'rider_look.dart';

/// Builds the artwork palette that dresses a rider and bike in a look.
abstract final class ArtPalettes {
  static const double jacketShade = 0.5;

  /// Returns the palette of [look], its own if it has one.
  static ArtPalette of(RiderLook look) {
    final own = look.art;
    if (own != null) return own;
    return ArtPalette(
      helmet: look.helmet,
      helmetPrint: look.graphicA,
      helmetStripe: look.graphicB,
      visor: look.visor ?? ArtPalette.drawn.visor,
      legs: look.suit,
      panel: look.stripe,
      jacket: ToneColors.shaded(look.suit, jacketShade),
      sleeve: look.stripeEdge,
      bikeDark: look.bike.panelDark,
      bike: look.bike.panel,
    );
  }
}
