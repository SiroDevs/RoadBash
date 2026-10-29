// Dart imports:
import 'dart:ui';

// Project imports:
import 'bike_look.dart';
import 'rider_look.dart';

/// Predefined rider looks for the player and rivals.
abstract final class RiderLooks {
  static const RiderLook player = RiderLook.main;

  static const RiderLook mike = RiderLook(
    suit: Color(0xFFD32F2F),
    stripe: Color(0xFFFFFFFF),
    stripeEdge: Color(0xFFFFC107),
    backPatch: Color(0xFF5D1010),
    helmet: Color(0xFFF5F5F5),
    gloves: Color(0xFF212121),
    boots: Color(0xFF1A1A1A),
    bike: BikeLook(
      panel: Color(0xFFE53935),
      panelDark: Color(0xFF8E1B1B),
      accent: Color(0xFFFFFFFF),
      accentEdge: Color(0xFFFFC107),
      trim: Color(0xFFFFF3E0),
    ),
  );

  static const RiderLook bose = RiderLook(
    suit: Color(0xFF1565C0),
    stripe: Color(0xFF00E5FF),
    stripeEdge: Color(0xFFFFFFFF),
    backPatch: Color(0xFF0D2B5C),
    helmet: Color(0xFF212121),
    gloves: Color(0xFF00E5FF),
    boots: Color(0xFF0D1B2A),
    bike: BikeLook(
      frame: Color(0xFF0D1B2A),
      panel: Color(0xFF1E88E5),
      panelDark: Color(0xFF0D47A1),
      accent: Color(0xFF00E5FF),
      accentEdge: Color(0xFFFFFFFF),
      trim: Color(0xFFB3E5FC),
    ),
  );

  static const RiderLook sam = RiderLook(
    suit: Color(0xFFFF6F00),
    stripe: Color(0xFF212121),
    stripeEdge: Color(0xFFFFD54F),
    backPatch: Color(0xFF3E2723),
    helmet: Color(0xFFFF8F00),
    gloves: Color(0xFF212121),
    boots: Color(0xFF3E2723),
    bike: BikeLook(
      panel: Color(0xFFFF9800),
      panelDark: Color(0xFF8D4B00),
      accent: Color(0xFF212121),
      accentEdge: Color(0xFFFFD54F),
      trim: Color(0xFFFFE0B2),
    ),
  );

  static const RiderLook kamau = RiderLook(
    suit: Color(0xFFECEFF1),
    stripe: Color(0xFF2E7D32),
    stripeEdge: Color(0xFFD32F2F),
    backPatch: Color(0xFF1B5E20),
    helmet: Color(0xFF2E7D32),
    gloves: Color(0xFFD32F2F),
    boots: Color(0xFF111111),
    bike: BikeLook(
      panel: Color(0xFFECEFF1),
      panelDark: Color(0xFF607D8B),
      accent: Color(0xFF2E7D32),
      accentEdge: Color(0xFFD32F2F),
      trim: Color(0xFFFFFFFF),
    ),
  );

  static const RiderLook brayo = RiderLook(
    suit: Color(0xFF00897B),
    stripe: Color(0xFFFDD835),
    stripeEdge: Color(0xFFFFFFFF),
    backPatch: Color(0xFF004D40),
    helmet: Color(0xFFFDD835),
    gloves: Color(0xFFFDD835),
    boots: Color(0xFF263238),
    bike: BikeLook(
      frame: Color(0xFF102027),
      panel: Color(0xFF26A69A),
      panelDark: Color(0xFF00574B),
      accent: Color(0xFFFDD835),
      accentEdge: Color(0xFFFFFFFF),
      trim: Color(0xFFE0F2F1),
    ),
  );

  static const List<RiderLook> field = [mike, bose, sam, kamau, brayo];
}
