// Dart imports:
import 'dart:ui';

// Project imports:
import 'bike_looks.dart';
import 'rider_look.dart';
import 'rider_palettes.dart';

/// Predefined rider looks for the player and rivals.
abstract final class RiderLooks {
  static const RiderLook player = RiderLook.main;

  /// Blue, purple and light-blue suit with a black and red bike.
  static const RiderLook blue = RiderLook(
    suit: Color(0xFF2563EB),
    stripe: Color(0xFF7E22CE),
    stripeEdge: Color(0xFF7DD3FC),
    backPatch: Color(0xFF54208A),
    helmet: Color(0xFF2563EB),
    helmetGraphic: Color(0xFF7E22CE),
    helmetGraphic2: Color(0xFF7DD3FC),
    visor: Color(0xFF14141A),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFF7E22CE),
    boots: Color(0xFF1A1A1A),
    bike: BikeLooks.blackRed,
    art: RiderPalettes.blue,
  );

  /// Black, silver and gold suit with a white and silver bike.
  static const RiderLook black = RiderLook(
    suit: Color(0xFF22252B),
    stripe: Color(0xFFD5D8DD),
    stripeEdge: Color(0xFFD6A528),
    backPatch: Color(0xFF17191D),
    helmet: Color(0xFF22252B),
    helmetGraphic: Color(0xFFD5D8DD),
    helmetGraphic2: Color(0xFFD6A528),
    visor: Color(0xFF14141A),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFFD6A528),
    boots: Color(0xFF1A1A1A),
    bike: BikeLooks.whiteSilver,
    art: RiderPalettes.black,
  );

  /// Red, brown and yellow suit with a cream and yellow bike.
  static const RiderLook red = RiderLook(
    suit: Color(0xFFC62828),
    stripe: Color(0xFF70452D),
    stripeEdge: Color(0xFFF2C94C),
    backPatch: Color(0xFF70452D),
    helmet: Color(0xFFC62828),
    helmetGraphic: Color(0xFF70452D),
    helmetGraphic2: Color(0xFFF2C94C),
    visor: Color(0xFF14141A),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFF70452D),
    boots: Color(0xFF1A1A1A),
    bike: BikeLooks.creamYellow,
    art: RiderPalettes.red,
  );

  /// Lime, beige and dark-green suit with a dark-red and brown bike.
  static const RiderLook lime = RiderLook(
    suit: Color(0xFFA3D900),
    stripe: Color(0xFFE6D5A8),
    stripeEdge: Color(0xFF174A2A),
    backPatch: Color(0xFF174A2A),
    helmet: Color(0xFFA3D900),
    helmetGraphic: Color(0xFF174A2A),
    helmetGraphic2: Color(0xFFE6D5A8),
    visor: Color(0xFF14141A),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFF174A2A),
    boots: Color(0xFF1A1A1A),
    bike: BikeLooks.darkRedBrown,
    art: RiderPalettes.lime,
  );

  /// White, black and silver suit with a blue and green bike.
  static const RiderLook white = RiderLook(
    suit: Color(0xFFF2F2EC),
    stripe: Color(0xFF17191D),
    stripeEdge: Color(0xFFBFC4CC),
    backPatch: Color(0xFF17191D),
    helmet: Color(0xFFF2F2EC),
    helmetGraphic: Color(0xFF17191D),
    helmetGraphic2: Color(0xFFBFC4CC),
    visor: Color(0xFF14141A),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFF17191D),
    boots: Color(0xFF1A1A1A),
    bike: BikeLooks.blueGreen,
    art: RiderPalettes.white,
  );

  /// Traffic police uses the remaining silver and black bike scheme.
  static const RiderLook cop = RiderLook(
    suit: Color(0xFF1B2A49),
    stripe: Color(0xFFBFC4CC),
    stripeEdge: Color(0xFF17191D),
    backPatch: Color(0xFF0B1224),
    helmet: Color(0xFFF5F5F5),
    gloves: Color(0xFF111111),
    boots: Color(0xFF0A0A0A),
    bike: BikeLooks.silverBlack,
    art: RiderPalettes.cop,
  );

  static const List<RiderLook> field = [red, blue, lime, black, white];
}
