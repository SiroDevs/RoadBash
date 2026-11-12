// Project imports:
import '../sheet/art_tone.dart';
import 'art_palette.dart';
import 'rider_look.dart';

/// Builds the artwork palette that dresses a rider and bike in a look.
abstract final class ArtPalettes {
  static const double jacketShade = 0.5;
  static const double baseShade = 0.7;
  static const double deepShade = 0.5;

  /// Returns the palette of [look], its own if it has one.
  static ArtPalette of(RiderLook look) {
    final own = look.art;
    if (own != null) return own;
    final bike = look.bike;
    final visor = look.visor ?? ArtPalette.drawn.visor;
    return ArtPalette(
      helmet: look.helmet,
      helmetPrint: look.graphicA,
      helmetStripe: look.graphicB,
      visor: visor,
      visorEdge: ToneColors.edgeOf(visor),
      legs: look.suit,
      panel: look.stripe,
      boots: look.boots,
      leather: look.backPatch,
      jacket: ToneColors.shaded(look.suit, jacketShade),
      sleeve: look.stripeEdge,
      gloves: look.gloves,
      bikeLight: bike.panel,
      bikeDark: bike.panelDark,
      bikeBase: ToneColors.shaded(bike.panel, baseShade),
      bikeDeep: ToneColors.shaded(bike.panelDark, deepShade),
      bikeUnder: bike.accent,
      shield: bike.frame,
    );
  }
}
