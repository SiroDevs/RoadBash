// Dart imports:
import 'dart:ui';

// Project imports:
import 'bike_look.dart';
import 'rider_look.dart';

/// Predefined rider looks for the player and rivals.
abstract final class RiderLooks {
  static const RiderLook player = RiderLook.main;

  /// Yellow rival.
  static const RiderLook yellow = RiderLook(
    suit: Color(0xFFF5C518),
    stripe: Color(0xFF8A6A00),
    stripeEdge: Color(0xFFFFE066),
    backPatch: Color(0xFF1A1A20),
    helmet: Color(0xFFF5C518),
    helmetGraphic: Color(0xFF1A1A20),
    helmetGraphic2: Color(0xFFFFE066),
    visor: Color(0xFF14141A),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFF8A6A00),
    boots: Color(0xFF1A1A1A),
    bike: BikeLook(
      frame: Color(0xFF101014),
      panel: Color(0xFFF5C518),
      panelDark: Color(0xFF8A6A00),
      accent: Color(0xFF22222A),
      accentEdge: Color(0xFFFFE066),
      trim: Color(0xFFD9DADF),
    ),
  );

  /// Blue rival.
  static const RiderLook blue = RiderLook(
    suit: Color(0xFF1E4FD6),
    stripe: Color(0xFF0E2A7A),
    stripeEdge: Color(0xFF6C93FF),
    backPatch: Color(0xFF1A1A20),
    helmet: Color(0xFF1E4FD6),
    helmetGraphic: Color(0xFF1A1A20),
    helmetGraphic2: Color(0xFF6C93FF),
    visor: Color(0xFF14141A),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFF0E2A7A),
    boots: Color(0xFF1A1A1A),
    bike: BikeLook(
      frame: Color(0xFF101014),
      panel: Color(0xFF1E4FD6),
      panelDark: Color(0xFF0E2A7A),
      accent: Color(0xFF22222A),
      accentEdge: Color(0xFF6C93FF),
      trim: Color(0xFFD9DADF),
    ),
  );

  /// Green rival.
  static const RiderLook green = RiderLook(
    suit: Color(0xFF2EC02E),
    stripe: Color(0xFF14661B),
    stripeEdge: Color(0xFF8CE86B),
    backPatch: Color(0xFF1A1A20),
    helmet: Color(0xFF2EC02E),
    helmetGraphic: Color(0xFF1A1A20),
    helmetGraphic2: Color(0xFF8CE86B),
    visor: Color(0xFF14141A),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFF14661B),
    boots: Color(0xFF1A1A1A),
    bike: BikeLook(
      frame: Color(0xFF101014),
      panel: Color(0xFF2EC02E),
      panelDark: Color(0xFF14661B),
      accent: Color(0xFF22222A),
      accentEdge: Color(0xFF8CE86B),
      trim: Color(0xFFD9DADF),
    ),
  );

  /// Purple rival.
  static const RiderLook purple = RiderLook(
    suit: Color(0xFF7A35C9),
    stripe: Color(0xFF3F1A73),
    stripeEdge: Color(0xFFB98AF0),
    backPatch: Color(0xFF1A1A20),
    helmet: Color(0xFF7A35C9),
    helmetGraphic: Color(0xFF1A1A20),
    helmetGraphic2: Color(0xFFB98AF0),
    visor: Color(0xFF14141A),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFF3F1A73),
    boots: Color(0xFF1A1A1A),
    bike: BikeLook(
      frame: Color(0xFF101014),
      panel: Color(0xFF7A35C9),
      panelDark: Color(0xFF3F1A73),
      accent: Color(0xFF22222A),
      accentEdge: Color(0xFFB98AF0),
      trim: Color(0xFFD9DADF),
    ),
  );

  /// Orange rival, the fifth on the higher levels.
  static const RiderLook orange = RiderLook(
    suit: Color(0xFFF26A1B),
    stripe: Color(0xFF8A3A0A),
    stripeEdge: Color(0xFFFFB074),
    backPatch: Color(0xFF1A1A20),
    helmet: Color(0xFFF26A1B),
    helmetGraphic: Color(0xFF1A1A20),
    helmetGraphic2: Color(0xFFFFB074),
    visor: Color(0xFF14141A),
    gloves: Color(0xFF1E1E22),
    gloveAccent: Color(0xFF8A3A0A),
    boots: Color(0xFF1A1A1A),
    bike: BikeLook(
      frame: Color(0xFF101014),
      panel: Color(0xFFF26A1B),
      panelDark: Color(0xFF8A3A0A),
      accent: Color(0xFF22222A),
      accentEdge: Color(0xFFFFB074),
      trim: Color(0xFFD9DADF),
    ),
  );

  /// Traffic police rider: navy suit, white helmet, blue and white bike.
  /// Not part of [field], so it never joins the race grid.
  static const RiderLook cop = RiderLook(
    suit: Color(0xFF1B2A49),
    stripe: Color(0xFFFFFFFF),
    stripeEdge: Color(0xFF2979FF),
    backPatch: Color(0xFF0B1224),
    helmet: Color(0xFFF5F5F5),
    gloves: Color(0xFF111111),
    boots: Color(0xFF0A0A0A),
    bike: BikeLook(
      frame: Color(0xFF0B1224),
      panel: Color(0xFFF2F4F8),
      panelDark: Color(0xFF8E99AD),
      accent: Color(0xFF2979FF),
      accentEdge: Color(0xFFFFFFFF),
      trim: Color(0xFFFFFFFF),
    ),
  );

  static const List<RiderLook> field = [yellow, blue, green, purple, orange];
}
