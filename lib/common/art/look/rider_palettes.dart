// Dart imports:
import 'dart:ui';

// Project imports:
import 'art_palette.dart';

/// Artwork palettes for the five rivals and traffic police.
abstract final class RiderPalettes {
  static const ArtPalette blue = ArtPalette(
    helmet: Color(0xFF2563EB),
    helmetPrint: Color(0xFF7E22CE),
    helmetStripe: Color(0xFF7DD3FC),
    visor: Color(0xFF14141A),
    legs: Color(0xFF2563EB),
    panel: Color(0xFF7E22CE),
    jacket: Color(0xFF54208A),
    sleeve: Color(0xFF7DD3FC),
    bikeDark: Color(0xFFB8202D),
    bike: Color(0xFF17191D),
  );

  static const ArtPalette black = ArtPalette(
    helmet: Color(0xFF22252B),
    helmetPrint: Color(0xFFD5D8DD),
    helmetStripe: Color(0xFFD6A528),
    visor: Color(0xFF14141A),
    legs: Color(0xFF22252B),
    panel: Color(0xFFD6A528),
    jacket: Color(0xFF35383E),
    sleeve: Color(0xFFD5D8DD),
    bikeDark: Color(0xFF9FA5AE),
    bike: Color(0xFFF2F3F4),
  );

  static const ArtPalette red = ArtPalette(
    helmet: Color(0xFFC62828),
    helmetPrint: Color(0xFF70452D),
    helmetStripe: Color(0xFFF2C94C),
    visor: Color(0xFF14141A),
    legs: Color(0xFFC62828),
    panel: Color(0xFF70452D),
    jacket: Color(0xFF70452D),
    sleeve: Color(0xFFF2C94C),
    bikeDark: Color(0xFFE5B51B),
    bike: Color(0xFFE8DAB7),
  );

  static const ArtPalette lime = ArtPalette(
    helmet: Color(0xFFA3D900),
    helmetPrint: Color(0xFF174A2A),
    helmetStripe: Color(0xFFE6D5A8),
    visor: Color(0xFF14141A),
    legs: Color(0xFFA3D900),
    panel: Color(0xFF174A2A),
    jacket: Color(0xFF285A36),
    sleeve: Color(0xFFE6D5A8),
    bikeDark: Color(0xFF65442E),
    bike: Color(0xFF781C28),
  );

  static const ArtPalette white = ArtPalette(
    helmet: Color(0xFFF2F2EC),
    helmetPrint: Color(0xFF17191D),
    helmetStripe: Color(0xFFBFC4CC),
    visor: Color(0xFF14141A),
    legs: Color(0xFFF2F2EC),
    panel: Color(0xFFBFC4CC),
    jacket: Color(0xFFD9D9D4),
    sleeve: Color(0xFF17191D),
    bikeDark: Color(0xFF23814D),
    bike: Color(0xFF2368B5),
  );

  static const ArtPalette cop = ArtPalette(
    helmet: Color(0xFFF5F5F5),
    helmetPrint: Color(0xFF17191D),
    helmetStripe: Color(0xFF7F858F),
    visor: Color(0xFF14141A),
    legs: Color(0xFF1B2A49),
    panel: Color(0xFF7F858F),
    jacket: Color(0xFF0B1224),
    sleeve: Color(0xFFBFC4CC),
    bikeDark: Color(0xFF17191D),
    bike: Color(0xFFBFC4CC),
  );
}
