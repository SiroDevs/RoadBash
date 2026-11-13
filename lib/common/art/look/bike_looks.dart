// Dart imports:
import 'dart:ui';

// Project imports:
import 'bike_look.dart';

/// Standard color schemes for the player, rivals and traffic police bikes.
abstract final class BikeLooks {
  static const BikeLook player = BikeLook(
    frame: Color(0xFF101412),
    panel: Color(0xFF238342),
    panelDark: Color(0xFF124A29),
    accent: Color(0xFF0A0C0B),
    accentEdge: Color(0xFF1B5C32),
    trim: Color(0xFFB7C0BA),
  );

  static const BikeLook blackRed = BikeLook(
    frame: Color(0xFF101014),
    panel: Color(0xFF17191D),
    panelDark: Color(0xFF0A0B0D),
    accent: Color(0xFFB8202D),
    accentEdge: Color(0xFFE34C57),
    trim: Color(0xFFC4C7CE),
  );

  static const BikeLook whiteSilver = BikeLook(
    frame: Color(0xFF30343B),
    panel: Color(0xFFF2F3F4),
    panelDark: Color(0xFFC7CBD1),
    accent: Color(0xFF9FA5AE),
    accentEdge: Color(0xFFE0E3E7),
    trim: Color(0xFFD4D7DC),
  );

  static const BikeLook creamYellow = BikeLook(
    frame: Color(0xFF3A3527),
    panel: Color(0xFFE8DAB7),
    panelDark: Color(0xFFB9A878),
    accent: Color(0xFFE5B51B),
    accentEdge: Color(0xFFFFD84A),
    trim: Color(0xFFD7C79F),
  );

  static const BikeLook darkRedBrown = BikeLook(
    frame: Color(0xFF241713),
    panel: Color(0xFF781C28),
    panelDark: Color(0xFF470E17),
    accent: Color(0xFF65442E),
    accentEdge: Color(0xFF8A6345),
    trim: Color(0xFFB9A99A),
  );

  static const BikeLook blueGreen = BikeLook(
    frame: Color(0xFF111A24),
    panel: Color(0xFF2368B5),
    panelDark: Color(0xFF153D6C),
    accent: Color(0xFF23814D),
    accentEdge: Color(0xFF51A66D),
    trim: Color(0xFFBEC9D6),
  );

  static const BikeLook silverBlack = BikeLook(
    frame: Color(0xFF191A1D),
    panel: Color(0xFFBFC4CC),
    panelDark: Color(0xFF7F858F),
    accent: Color(0xFF17191D),
    accentEdge: Color(0xFF42464E),
    trim: Color(0xFFE0E2E5),
  );
}
