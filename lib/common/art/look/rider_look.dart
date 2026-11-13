// Flutter imports:
import 'package:flutter/painting.dart';

// Project imports:
import 'art_palette.dart';
import 'bike_look.dart';
import 'bike_looks.dart';

/// Colors of the rider's suit, helmet and details.
class RiderLook {
  const RiderLook({
    this.suit = const Color(0xFFA349A4),
    this.stripe = const Color(0xFF22B14C),
    this.stripeEdge = const Color(0xFFB5E61D),
    this.backPatch = const Color(0xFF880015),
    this.helmet = const Color(0xFFF2C21C),
    this.helmetShadeOverride,
    this.neck = const Color(0xFF23242B),
    this.gloves = const Color(0xFF23242B),
    this.boots = const Color(0xFF000000),
    this.helmetGraphic,
    this.helmetGraphic2,
    this.visor,
    this.gloveAccent,
    this.bike = BikeLook.stock,
    this.art,
  });

  static const RiderLook main = RiderLook(
    suit: Color(0xFFF28C28),
    stripe: Color(0xFF70452D),
    stripeEdge: Color(0xFFC62828),
    backPatch: Color(0xFF70452D),
    helmet: Color(0xFFF28C28),
    helmetGraphic: Color(0xFF70452D),
    helmetGraphic2: Color(0xFFC62828),
    visor: Color(0xFF14141A),
    neck: Color(0xFF23242B),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFFC62828),
    boots: Color(0xFF1A1A1A),
    bike: BikeLooks.player,
    art: ArtPalette(
      helmet: Color(0xFFF28C28),
      helmetPrint: Color(0xFF70452D),
      helmetStripe: Color(0xFFC62828),
      visor: Color(0xFF3B261B),
      legs: Color(0xFFF28C28),
      panel: Color(0xFFC62828),
      jacket: Color(0xFF70452D),
      sleeve: Color(0xFFB86127),
      bikeDark: Color(0xFF124A29),
      bike: Color(0xFF238342),
    ),
  );

  final Color suit;
  final Color stripe;
  final Color stripeEdge;
  final Color backPatch;
  final Color helmet;
  final Color? helmetShadeOverride;
  final Color neck;
  final Color gloves;
  final Color boots;
  final Color? helmetGraphic;
  final Color? helmetGraphic2;
  final Color? visor;
  final Color? gloveAccent;
  final BikeLook bike;
  final ArtPalette? art;

  static const Color helmetGloss = Color(0x66FFFFFF);

  /// First helmet graphic color, the suit stripe unless set.
  Color get graphicA => helmetGraphic ?? stripe;

  /// Second helmet graphic color, the stripe edge unless set.
  Color get graphicB => helmetGraphic2 ?? stripeEdge;

  /// Glove knuckle color, the suit stripe unless set.
  Color get knuckle => gloveAccent ?? stripe;

  /// Shaded helmet color, derived unless overridden.
  Color get helmetShade {
    final shadeOverride = helmetShadeOverride;
    if (shadeOverride != null) return shadeOverride;
    final hsl = HSLColor.fromColor(helmet);
    return hsl.withLightness((hsl.lightness * 0.77).clamp(0.0, 1.0)).toColor();
  }

  /// Returns a copy with the given colors replaced.
  RiderLook copyWith({
    Color? suit,
    Color? stripe,
    Color? stripeEdge,
    Color? backPatch,
    Color? helmet,
    Color? helmetShadeOverride,
    Color? neck,
    Color? gloves,
    Color? boots,
    Color? helmetGraphic,
    Color? helmetGraphic2,
    Color? visor,
    Color? gloveAccent,
    BikeLook? bike,
    ArtPalette? art,
  }) => RiderLook(
    suit: suit ?? this.suit,
    stripe: stripe ?? this.stripe,
    stripeEdge: stripeEdge ?? this.stripeEdge,
    backPatch: backPatch ?? this.backPatch,
    helmet: helmet ?? this.helmet,
    helmetShadeOverride: helmetShadeOverride ?? this.helmetShadeOverride,
    neck: neck ?? this.neck,
    gloves: gloves ?? this.gloves,
    boots: boots ?? this.boots,
    helmetGraphic: helmetGraphic ?? this.helmetGraphic,
    helmetGraphic2: helmetGraphic2 ?? this.helmetGraphic2,
    visor: visor ?? this.visor,
    gloveAccent: gloveAccent ?? this.gloveAccent,
    bike: bike ?? this.bike,
    art: art ?? this.art,
  );
}
