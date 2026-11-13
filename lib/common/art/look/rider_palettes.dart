// Dart imports:
import 'dart:ui';

// Project imports:
import 'art_palette.dart';

/// Artwork colors of each rival and the cop. Edit the values to restyle them.
abstract final class RiderPalettes {
  static const ArtPalette yellow = ArtPalette(
    helmet: Color(0xFFF5C518),
    helmetPrint: Color(0xFF1A1A20),
    helmetStripe: Color(0xFFFFFFFF),
    visor: Color(0xFF14141A),
    legs: Color(0xFFF5C518),
    panel: Color(0xFF1A1A20),
    jacket: Color(0xFF4A3F10),
    sleeve: Color(0xFFFFFFFF),
    bikeDark: Color(0xFF8A6A00),
    bike: Color(0xFFF5C518),
  );

  static const ArtPalette blue = ArtPalette(
    helmet: Color(0xFFFFFFFF),
    helmetPrint: Color(0xFF1E4FD6),
    helmetStripe: Color(0xFF0E2A7A),
    visor: Color(0xFF14141A),
    legs: Color(0xFF1E4FD6),
    panel: Color(0xFFFFFFFF),
    jacket: Color(0xFF0E2A7A),
    sleeve: Color(0xFF6C93FF),
    bikeDark: Color(0xFF0E2A7A),
    bike: Color(0xFF1E4FD6),
  );

  static const ArtPalette green = ArtPalette(
    helmet: Color(0xFF2EC02E),
    helmetPrint: Color(0xFF1A1A20),
    helmetStripe: Color(0xFFFFFFFF),
    visor: Color(0xFF14141A),
    legs: Color(0xFF2EC02E),
    panel: Color(0xFF1A1A20),
    jacket: Color(0xFF14661B),
    sleeve: Color(0xFF8CE86B),
    bikeDark: Color(0xFF14661B),
    bike: Color(0xFF2EC02E),
  );

  static const ArtPalette purple = ArtPalette(
    helmet: Color(0xFF7A35C9),
    helmetPrint: Color(0xFFF2F2F2),
    helmetStripe: Color(0xFF3F1A73),
    visor: Color(0xFF14141A),
    legs: Color(0xFF7A35C9),
    panel: Color(0xFFF2F2F2),
    jacket: Color(0xFF3F1A73),
    sleeve: Color(0xFFB98AF0),
    bikeDark: Color(0xFF3F1A73),
    bike: Color(0xFF7A35C9),
  );

  static const ArtPalette orange = ArtPalette(
    helmet: Color(0xFFF26A1B),
    helmetPrint: Color(0xFF1A1A20),
    helmetStripe: Color(0xFFFFFFFF),
    visor: Color(0xFF14141A),
    legs: Color(0xFFF26A1B),
    panel: Color(0xFF1A1A20),
    jacket: Color(0xFF8A3A0A),
    sleeve: Color(0xFFFFB074),
    bikeDark: Color(0xFF8A3A0A),
    bike: Color(0xFFF26A1B),
  );

  static const ArtPalette cop = ArtPalette(
    helmet: Color(0xFFF5F5F5),
    helmetPrint: Color(0xFF1B2A49),
    helmetStripe: Color(0xFF2979FF),
    visor: Color(0xFF14141A),
    legs: Color(0xFF1B2A49),
    panel: Color(0xFFFFFFFF),
    jacket: Color(0xFF0B1224),
    sleeve: Color(0xFF2979FF),
    bikeDark: Color(0xFF0B1224),
    bike: Color(0xFF2979FF),
  );
}
